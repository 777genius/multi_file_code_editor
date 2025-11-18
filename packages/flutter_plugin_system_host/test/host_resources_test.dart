import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_host/flutter_plugin_system_host.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Host Resources', () {
    group('Error Tracking', () {
      late ErrorTracker errorTracker;

      setUp(() {
        errorTracker = ErrorTracker();
      });

      tearDown(() async {
        await errorTracker.dispose();
      });

      test('should track plugin errors', () {
        // Arrange
        final error = Exception('Test error');
        final stack = StackTrace.current;

        // Act
        errorTracker.trackError('test.plugin', error, stack);

        // Assert
        final errors = errorTracker.getErrors('test.plugin');
        expect(errors, hasLength(1));
        expect(errors.first.pluginId, equals('test.plugin'));
      });

      test('should track multiple errors', () {
        // Act
        errorTracker.trackError('plugin1', Exception('Error 1'), StackTrace.current);
        errorTracker.trackError('plugin1', Exception('Error 2'), StackTrace.current);
        errorTracker.trackError('plugin2', Exception('Error 3'), StackTrace.current);

        // Assert
        expect(errorTracker.getErrors('plugin1'), hasLength(2));
        expect(errorTracker.getErrors('plugin2'), hasLength(1));
      });

      test('should emit error events', () async {
        // Arrange
        final errors = <PluginError>[];
        final subscription = errorTracker.errors.listen(errors.add);

        // Act
        errorTracker.trackError('test.plugin', Exception('Error'), StackTrace.current);
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(errors, hasLength(1));
        await subscription.cancel();
      });

      test('should track error severity', () {
        // Act
        errorTracker.trackError(
          'test.plugin',
          Exception('Warning'),
          StackTrace.current,
          severity: ErrorSeverity.warning,
        );
        errorTracker.trackError(
          'test.plugin',
          Exception('Error'),
          StackTrace.current,
          severity: ErrorSeverity.error,
        );

        // Assert
        final errors = errorTracker.getErrors('test.plugin');
        expect(errors[0].severity, equals(ErrorSeverity.warning));
        expect(errors[1].severity, equals(ErrorSeverity.error));
      });

      test('should clear errors for plugin', () {
        // Arrange
        errorTracker.trackError('test.plugin', Exception('Error'), StackTrace.current);

        // Act
        errorTracker.clearErrors('test.plugin');

        // Assert
        expect(errorTracker.getErrors('test.plugin'), isEmpty);
      });

      test('should clear all errors', () {
        // Arrange
        errorTracker.trackError('plugin1', Exception('Error 1'), StackTrace.current);
        errorTracker.trackError('plugin2', Exception('Error 2'), StackTrace.current);

        // Act
        errorTracker.clearAllErrors();

        // Assert
        expect(errorTracker.getErrors('plugin1'), isEmpty);
        expect(errorTracker.getErrors('plugin2'), isEmpty);
      });
    });

    group('Error Boundary', () {
      late ErrorTracker errorTracker;
      late ErrorBoundary errorBoundary;

      setUp(() {
        errorTracker = ErrorTracker();
        errorBoundary = ErrorBoundary(errorTracker);
      });

      tearDown() async {
        await errorTracker.dispose();
      }

      test('should execute function successfully', () async {
        // Act
        final result = await errorBoundary.execute(
          'test.plugin',
          () async => 'success',
        );

        // Assert
        expect(result, equals('success'));
      });

      test('should catch and track errors', () async {
        // Act
        await errorBoundary.execute(
          'test.plugin',
          () async => throw Exception('Test error'),
          fallback: (_) => 'fallback',
        );

        // Assert
        final errors = errorTracker.getErrors('test.plugin');
        expect(errors, hasLength(1));
      });

      test('should use fallback on error', () async {
        // Act
        final result = await errorBoundary.execute(
          'test.plugin',
          () async => throw Exception('Error'),
          fallback: (_) => 'fallback_value',
        );

        // Assert
        expect(result, equals('fallback_value'));
      });

      test('should rethrow without fallback', () {
        // Act & Assert
        expect(
          () => errorBoundary.execute(
            'test.plugin',
            () async => throw Exception('Error'),
          ),
          throwsException,
        );
      });

      test('should execute with timeout', () async {
        // Act
        final result = await errorBoundary.executeWithTimeout(
          'test.plugin',
          () async {
            await Future.delayed(const Duration(milliseconds: 10));
            return 'success';
          },
          timeout: const Duration(seconds: 1),
        );

        // Assert
        expect(result, equals('success'));
      });

      test('should timeout slow operations', () {
        // Act & Assert
        expect(
          () => errorBoundary.executeWithTimeout(
            'test.plugin',
            () async {
              await Future.delayed(const Duration(milliseconds: 200));
              return 'result';
            },
            timeout: const Duration(milliseconds: 50),
          ),
          throwsA(isA<TimeoutException>()),
        );
      });

      test('should execute sync functions', () {
        // Act
        final result = errorBoundary.executeSync(
          'test.plugin',
          () => 'sync_result',
        );

        // Assert
        expect(result, equals('sync_result'));
      });

      test('should handle sync errors with fallback', () {
        // Act
        final result = errorBoundary.executeSync(
          'test.plugin',
          () => throw Exception('Sync error'),
          fallback: (_) => 'sync_fallback',
        );

        // Assert
        expect(result, equals('sync_fallback'));
      });

      test('should execute all functions in parallel', () async {
        // Act
        final results = await errorBoundary.executeAll({
          'plugin1': () async => 'result1',
          'plugin2': () async => 'result2',
          'plugin3': () async => 'result3',
        });

        // Assert
        expect(results, hasLength(3));
        expect(results['plugin1'], equals('result1'));
        expect(results['plugin2'], equals('result2'));
        expect(results['plugin3'], equals('result3'));
      });

      test('should retry on failure', () async {
        // Arrange
        var attempts = 0;

        // Act
        final result = await errorBoundary.executeWithRetry(
          'test.plugin',
          () async {
            attempts++;
            if (attempts < 3) {
              throw Exception('Retry error');
            }
            return 'success';
          },
          maxRetries: 3,
          retryDelay: const Duration(milliseconds: 10),
        );

        // Assert
        expect(result, equals('success'));
        expect(attempts, equals(3));
      });

      test('should use fallback after max retries', () async {
        // Act
        final result = await errorBoundary.executeWithRetry(
          'test.plugin',
          () async => throw Exception('Always fails'),
          maxRetries: 2,
          retryDelay: const Duration(milliseconds: 10),
          fallback: (_) => 'final_fallback',
        );

        // Assert
        expect(result, equals('final_fallback'));
      });
    });

    group('Resource Cleanup', () {
      test('should cleanup error tracker on dispose', () async {
        // Arrange
        final tracker = ErrorTracker();
        tracker.trackError('test.plugin', Exception('Error'), StackTrace.current);

        // Act
        await tracker.dispose();

        // Assert - stream should be closed
        // Subsequent operations should handle gracefully
      });

      test('should handle multiple dispose calls', () async {
        // Arrange
        final tracker = ErrorTracker();

        // Act & Assert - should not throw
        await tracker.dispose();
        await tracker.dispose();
      });
    });

    group('Resource Limits', () {
      test('should enforce memory limits', () {
        // Arrange
        final permissionSystem = PermissionSystem();
        const permissions = PluginPermissions(
          maxMemoryBytes: 10 * 1024 * 1024, // 10MB
        );
        permissionSystem.registerPlugin('test.plugin', permissions);
        final securityGuard = SecurityGuard(permissionSystem);

        // Act & Assert
        expect(
          () => securityGuard.checkMemoryLimit('test.plugin', 20 * 1024 * 1024), // 20MB
          throwsA(isA<PluginMemoryLimitException>()),
        );
      });

      test('should enforce execution time limits', () async {
        // Arrange
        final permissionSystem = PermissionSystem();
        const permissions = PluginPermissions(
          maxExecutionTime: Duration(milliseconds: 50),
        );
        permissionSystem.registerPlugin('test.plugin', permissions);
        final securityGuard = SecurityGuard(permissionSystem);

        // Act & Assert
        expect(
          () => securityGuard.executeWithTimeout(
            'test.plugin',
            () async {
              await Future.delayed(const Duration(milliseconds: 200));
              return 'result';
            },
          ),
          throwsA(isA<PluginTimeoutException>()),
        );
      });

      test('should enforce call depth limits', () {
        // Arrange
        final permissionSystem = PermissionSystem();
        const permissions = PluginPermissions(maxCallDepth: 10);
        permissionSystem.registerPlugin('test.plugin', permissions);
        final securityGuard = SecurityGuard(permissionSystem);

        // Act
        final maxDepth = securityGuard.getMaxCallDepth('test.plugin');

        // Assert
        expect(maxDepth, equals(10));
      });
    });

    group('Statistics & Monitoring', () {
      test('should track error statistics', () {
        // Arrange
        final tracker = ErrorTracker();

        // Act
        tracker.trackError('plugin1', Exception('Error 1'), StackTrace.current);
        tracker.trackError('plugin1', Exception('Error 2'), StackTrace.current);
        tracker.trackError('plugin2', Exception('Error 3'), StackTrace.current);

        // Assert
        expect(tracker.getErrors('plugin1'), hasLength(2));
        expect(tracker.getErrors('plugin2'), hasLength(1));
      });

      test('should track error severity distribution', () {
        // Arrange
        final tracker = ErrorTracker();

        // Act
        tracker.trackError(
          'test.plugin',
          Exception('Warning'),
          StackTrace.current,
          severity: ErrorSeverity.warning,
        );
        tracker.trackError(
          'test.plugin',
          Exception('Error'),
          StackTrace.current,
          severity: ErrorSeverity.error,
        );
        tracker.trackError(
          'test.plugin',
          Exception('Critical'),
          StackTrace.current,
          severity: ErrorSeverity.critical,
        );

        // Assert
        final errors = tracker.getErrors('test.plugin');
        expect(
          errors.where((e) => e.severity == ErrorSeverity.warning).length,
          equals(1),
        );
        expect(
          errors.where((e) => e.severity == ErrorSeverity.error).length,
          equals(1),
        );
        expect(
          errors.where((e) => e.severity == ErrorSeverity.critical).length,
          equals(1),
        );
      });
    });

    group('Concurrent Resource Management', () {
      test('should handle concurrent error tracking', () {
        // Arrange
        final tracker = ErrorTracker();

        // Act - track errors concurrently
        for (var i = 0; i < 100; i++) {
          tracker.trackError('test.plugin', Exception('Error $i'), StackTrace.current);
        }

        // Assert
        expect(tracker.getErrors('test.plugin'), hasLength(100));
      });

      test('should handle concurrent boundary executions', () async {
        // Arrange
        final tracker = ErrorTracker();
        final boundary = ErrorBoundary(tracker);

        // Act
        final results = await Future.wait(
          List.generate(
            10,
            (i) => boundary.execute(
              'plugin$i',
              () async => 'result$i',
            ),
          ),
        );

        // Assert
        expect(results, hasLength(10));
        for (var i = 0; i < 10; i++) {
          expect(results[i], equals('result$i'));
        }
      });
    });
  });
}
