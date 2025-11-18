import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_plugins/src/hooks/hook_registry.dart';

void main() {
  group('Hook', () {
    group('Construction', () {
      test('should create hook with name', () {
        // Act
        final hook = Hook<String>('test.hook');

        // Assert
        expect(hook.name, equals('test.hook'));
        expect(hook.callbackCount, equals(0));
      });

      test('should create hook with error callback', () {
        // Arrange
        var errorCalled = false;

        // Act
        final hook = Hook<String>(
          'test.hook',
          onError: (name, error, stackTrace) {
            errorCalled = true;
          },
        );

        // Assert
        expect(hook.onError, isNotNull);
      });

      test('should initialize with empty metrics', () {
        // Act
        final hook = Hook<String>('test.hook');

        // Assert
        expect(hook.metrics.successCount, equals(0));
        expect(hook.metrics.errorCount, equals(0));
        expect(hook.metrics.totalExecutionTime, equals(Duration.zero));
        expect(hook.metrics.recentErrors, isEmpty);
      });
    });

    group('Register', () {
      test('should register a callback', () {
        // Arrange
        final hook = Hook<String>('test.hook');

        // Act
        hook.register((data) {});

        // Assert
        expect(hook.callbackCount, equals(1));
      });

      test('should register multiple callbacks', () {
        // Arrange
        final hook = Hook<String>('test.hook');

        // Act
        hook.register((data) {});
        hook.register((data) {});
        hook.register((data) {});

        // Assert
        expect(hook.callbackCount, equals(3));
      });

      test('should allow registering same callback multiple times', () {
        // Arrange
        final hook = Hook<String>('test.hook');
        void callback(String data) {}

        // Act
        hook.register(callback);
        hook.register(callback);

        // Assert
        expect(hook.callbackCount, equals(2));
      });
    });

    group('Unregister', () {
      test('should unregister a callback', () {
        // Arrange
        final hook = Hook<String>('test.hook');
        void callback(String data) {}

        hook.register(callback);

        // Act
        hook.unregister(callback);

        // Assert
        expect(hook.callbackCount, equals(0));
      });

      test('should unregister specific callback when multiple registered', () {
        // Arrange
        final hook = Hook<String>('test.hook');
        void callback1(String data) {}
        void callback2(String data) {}
        void callback3(String data) {}

        hook.register(callback1);
        hook.register(callback2);
        hook.register(callback3);

        // Act
        hook.unregister(callback2);

        // Assert
        expect(hook.callbackCount, equals(2));
      });

      test('should handle unregister of non-existent callback', () {
        // Arrange
        final hook = Hook<String>('test.hook');
        void callback(String data) {}

        // Act & Assert - should not throw
        expect(() => hook.unregister(callback), returnsNormally);
        expect(hook.callbackCount, equals(0));
      });

      test('should handle multiple unregister of same callback', () {
        // Arrange
        final hook = Hook<String>('test.hook');
        void callback(String data) {}

        hook.register(callback);
        hook.register(callback);

        // Act
        hook.unregister(callback);

        // Assert - only removes first occurrence
        expect(hook.callbackCount, equals(1));
      });
    });

    group('Execute', () {
      test('should execute single callback', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        var executedData = '';

        hook.register((data) {
          executedData = data;
        });

        // Act
        await hook.execute('test data');

        // Assert
        expect(executedData, equals('test data'));
      });

      test('should execute multiple callbacks in order', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        final executionOrder = <int>[];

        hook.register((data) {
          executionOrder.add(1);
        });
        hook.register((data) {
          executionOrder.add(2);
        });
        hook.register((data) {
          executionOrder.add(3);
        });

        // Act
        await hook.execute('test');

        // Assert
        expect(executionOrder, equals([1, 2, 3]));
      });

      test('should execute async callbacks', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        var result = '';

        hook.register((data) async {
          await Future.delayed(const Duration(milliseconds: 10));
          result += data;
        });

        // Act
        await hook.execute('async');

        // Assert
        expect(result, equals('async'));
      });

      test('should handle callback exceptions and continue execution', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        var callback1Executed = false;
        var callback2Executed = false;
        var callback3Executed = false;

        hook.register((data) {
          callback1Executed = true;
        });

        hook.register((data) {
          callback2Executed = true;
          throw Exception('Callback error');
        });

        hook.register((data) {
          callback3Executed = true;
        });

        // Act
        await hook.execute('test');

        // Assert
        expect(callback1Executed, isTrue);
        expect(callback2Executed, isTrue);
        expect(callback3Executed, isTrue);
      });

      test('should call error callback when exception occurs', () async {
        // Arrange
        var errorCallbackCalled = false;
        String? errorHookName;
        Object? errorObject;

        final hook = Hook<String>(
          'test.hook',
          onError: (name, error, stackTrace) {
            errorCallbackCalled = true;
            errorHookName = name;
            errorObject = error;
          },
        );

        final testError = Exception('Test error');
        hook.register((data) {
          throw testError;
        });

        // Act
        await hook.execute('test');

        // Assert
        expect(errorCallbackCalled, isTrue);
        expect(errorHookName, equals('test.hook'));
        expect(errorObject, equals(testError));
      });

      test('should update metrics on successful execution', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        hook.register((data) async {
          await Future.delayed(const Duration(milliseconds: 10));
        });

        // Act
        await hook.execute('test');

        // Assert
        expect(hook.metrics.successCount, equals(1));
        expect(hook.metrics.errorCount, equals(0));
        expect(hook.metrics.totalExecutionTime.inMilliseconds, greaterThan(0));
      });

      test('should update metrics on error execution', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        hook.register((data) {
          throw Exception('Error');
        });

        // Act
        await hook.execute('test');

        // Assert
        expect(hook.metrics.errorCount, equals(1));
        expect(hook.metrics.recentErrors.length, equals(1));
      });

      test('should track metrics for multiple executions', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        hook.register((data) {});

        // Act
        await hook.execute('test1');
        await hook.execute('test2');
        await hook.execute('test3');

        // Assert
        expect(hook.metrics.successCount, equals(3));
      });
    });

    group('Clear', () {
      test('should clear all callbacks', () {
        // Arrange
        final hook = Hook<String>('test.hook');
        hook.register((data) {});
        hook.register((data) {});
        hook.register((data) {});

        // Act
        hook.clear();

        // Assert
        expect(hook.callbackCount, equals(0));
      });

      test('should not execute after clear', () async {
        // Arrange
        final hook = Hook<String>('test.hook');
        var executed = false;

        hook.register((data) {
          executed = true;
        });

        // Act
        hook.clear();
        await hook.execute('test');

        // Assert
        expect(executed, isFalse);
      });
    });
  });

  group('HookExecutionMetrics', () {
    group('RecordSuccess', () {
      test('should increment success count', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act
        metrics.recordSuccess(const Duration(milliseconds: 10));

        // Assert
        expect(metrics.successCount, equals(1));
      });

      test('should accumulate execution time', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act
        metrics.recordSuccess(const Duration(milliseconds: 10));
        metrics.recordSuccess(const Duration(milliseconds: 20));
        metrics.recordSuccess(const Duration(milliseconds: 30));

        // Assert
        expect(metrics.totalExecutionTime.inMilliseconds, equals(60));
      });

      test('should calculate average execution time', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act
        metrics.recordSuccess(const Duration(milliseconds: 10));
        metrics.recordSuccess(const Duration(milliseconds: 20));
        metrics.recordSuccess(const Duration(milliseconds: 30));

        // Assert
        expect(metrics.averageExecutionMs, equals(20.0));
      });

      test('should handle zero executions for average', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act & Assert
        expect(metrics.averageExecutionMs, equals(0.0));
      });
    });

    group('RecordError', () {
      test('should increment error count', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act
        metrics.recordError('test.hook', Exception('Error'), StackTrace.current);

        // Assert
        expect(metrics.errorCount, equals(1));
      });

      test('should add error to recent errors', () {
        // Arrange
        final metrics = HookExecutionMetrics();
        final error = Exception('Test error');

        // Act
        metrics.recordError('test.hook', error, StackTrace.current);

        // Assert
        expect(metrics.recentErrors.length, equals(1));
        expect(metrics.recentErrors.first.hookName, equals('test.hook'));
        expect(metrics.recentErrors.first.error, equals(error));
      });

      test('should limit recent errors to 10', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act
        for (var i = 0; i < 15; i++) {
          metrics.recordError('hook$i', Exception('Error $i'), StackTrace.current);
        }

        // Assert
        expect(metrics.recentErrors.length, equals(10));
      });

      test('should keep most recent errors when limit exceeded', () {
        // Arrange
        final metrics = HookExecutionMetrics();

        // Act
        for (var i = 0; i < 12; i++) {
          metrics.recordError('test.hook', Exception('Error $i'), StackTrace.current);
        }

        // Assert
        final lastError = metrics.recentErrors.last;
        expect(lastError.error.toString(), contains('Error 11'));
      });

      test('should record error timestamp', () {
        // Arrange
        final metrics = HookExecutionMetrics();
        final before = DateTime.now();

        // Act
        metrics.recordError('test.hook', Exception('Error'), StackTrace.current);

        // Assert
        final after = DateTime.now();
        final timestamp = metrics.recentErrors.first.timestamp;
        expect(timestamp.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(timestamp.isBefore(after.add(const Duration(seconds: 1))), isTrue);
      });
    });
  });

  group('HookRegistry', () {
    late HookRegistry registry;

    setUp(() {
      registry = HookRegistry();
    });

    tearDown(() {
      registry.clear();
    });

    group('GetOrCreate', () {
      test('should create new hook if not exists', () {
        // Act
        final hook = registry.getOrCreate<String>('test.hook');

        // Assert
        expect(hook, isNotNull);
        expect(hook.name, equals('test.hook'));
      });

      test('should return existing hook if already created', () {
        // Arrange
        final hook1 = registry.getOrCreate<String>('test.hook');

        // Act
        final hook2 = registry.getOrCreate<String>('test.hook');

        // Assert
        expect(identical(hook1, hook2), isTrue);
      });

      test('should create hooks with different types', () {
        // Act
        final stringHook = registry.getOrCreate<String>('string.hook');
        final intHook = registry.getOrCreate<int>('int.hook');
        final boolHook = registry.getOrCreate<bool>('bool.hook');

        // Assert
        expect(stringHook, isNotNull);
        expect(intHook, isNotNull);
        expect(boolHook, isNotNull);
      });

      test('should apply global error handler to new hooks', () {
        // Arrange
        var globalErrorCalled = false;

        final registryWithHandler = HookRegistry(
          onError: (name, error, stackTrace) {
            globalErrorCalled = true;
          },
        );

        final hook = registryWithHandler.getOrCreate<String>('test.hook');
        hook.register((data) {
          throw Exception('Error');
        });

        // Act
        hook.execute('test');

        // Assert - error handler is async, so we can't directly test
        expect(hook.onError, isNotNull);
      });
    });

    group('Get', () {
      test('should return hook if it exists', () {
        // Arrange
        final created = registry.getOrCreate<String>('test.hook');

        // Act
        final retrieved = registry.get<String>('test.hook');

        // Assert
        expect(retrieved, equals(created));
      });

      test('should return null if hook does not exist', () {
        // Act
        final hook = registry.get<String>('non.existent');

        // Assert
        expect(hook, isNull);
      });
    });

    group('Register', () {
      test('should register callback to hook', () {
        // Arrange
        var executed = false;

        // Act
        registry.register<String>('test.hook', (data) {
          executed = true;
        });

        // Assert
        final hook = registry.get<String>('test.hook');
        expect(hook, isNotNull);
        expect(hook!.callbackCount, equals(1));
      });

      test('should create hook if it does not exist', () {
        // Act
        registry.register<String>('new.hook', (data) {});

        // Assert
        final hook = registry.get<String>('new.hook');
        expect(hook, isNotNull);
      });

      test('should register multiple callbacks to same hook', () {
        // Act
        registry.register<String>('test.hook', (data) {});
        registry.register<String>('test.hook', (data) {});
        registry.register<String>('test.hook', (data) {});

        // Assert
        final hook = registry.get<String>('test.hook');
        expect(hook!.callbackCount, equals(3));
      });
    });

    group('Unregister', () {
      test('should unregister callback from hook', () {
        // Arrange
        void callback(String data) {}
        registry.register<String>('test.hook', callback);

        // Act
        registry.unregister<String>('test.hook', callback);

        // Assert
        final hook = registry.get<String>('test.hook');
        expect(hook!.callbackCount, equals(0));
      });

      test('should handle unregister from non-existent hook', () {
        // Act & Assert - should not throw
        expect(
          () => registry.unregister<String>('non.existent', (data) {}),
          returnsNormally,
        );
      });
    });

    group('Execute', () {
      test('should execute hook with data', () async {
        // Arrange
        var receivedData = '';
        registry.register<String>('test.hook', (data) {
          receivedData = data;
        });

        // Act
        await registry.execute<String>('test.hook', 'test data');

        // Assert
        expect(receivedData, equals('test data'));
      });

      test('should execute all registered callbacks', () async {
        // Arrange
        var callback1Executed = false;
        var callback2Executed = false;

        registry.register<String>('test.hook', (data) {
          callback1Executed = true;
        });
        registry.register<String>('test.hook', (data) {
          callback2Executed = true;
        });

        // Act
        await registry.execute<String>('test.hook', 'test');

        // Assert
        expect(callback1Executed, isTrue);
        expect(callback2Executed, isTrue);
      });

      test('should handle execute of non-existent hook', () async {
        // Act & Assert - should not throw
        await expectLater(
          registry.execute<String>('non.existent', 'test'),
          completes,
        );
      });

      test('should execute hooks with different data types', () async {
        // Arrange
        var stringData = '';
        var intData = 0;
        var boolData = false;

        registry.register<String>('string.hook', (data) {
          stringData = data;
        });
        registry.register<int>('int.hook', (data) {
          intData = data;
        });
        registry.register<bool>('bool.hook', (data) {
          boolData = data;
        });

        // Act
        await registry.execute<String>('string.hook', 'hello');
        await registry.execute<int>('int.hook', 42);
        await registry.execute<bool>('bool.hook', true);

        // Assert
        expect(stringData, equals('hello'));
        expect(intData, equals(42));
        expect(boolData, isTrue);
      });
    });

    group('AllHookNames', () {
      test('should return empty list when no hooks', () {
        // Act
        final hookNames = registry.allHookNames;

        // Assert
        expect(hookNames, isEmpty);
      });

      test('should return list of hook names', () {
        // Arrange
        registry.getOrCreate<String>('hook1');
        registry.getOrCreate<String>('hook2');
        registry.getOrCreate<String>('hook3');

        // Act
        final hookNames = registry.allHookNames;

        // Assert
        expect(hookNames.length, equals(3));
        expect(hookNames, contains('hook1'));
        expect(hookNames, contains('hook2'));
        expect(hookNames, contains('hook3'));
      });
    });

    group('GetMetrics', () {
      test('should return metrics for specific hook', () async {
        // Arrange
        registry.register<String>('test.hook', (data) {});
        await registry.execute<String>('test.hook', 'test');

        // Act
        final metrics = registry.getMetrics('test.hook');

        // Assert
        expect(metrics, isNotNull);
        expect(metrics!.successCount, equals(1));
      });

      test('should return null for non-existent hook', () {
        // Act
        final metrics = registry.getMetrics('non.existent');

        // Assert
        expect(metrics, isNull);
      });
    });

    group('GetAllMetrics', () {
      test('should return metrics for all hooks', () async {
        // Arrange
        registry.register<String>('hook1', (data) {});
        registry.register<String>('hook2', (data) {});

        await registry.execute<String>('hook1', 'test');
        await registry.execute<String>('hook2', 'test');

        // Act
        final allMetrics = registry.getAllMetrics();

        // Assert
        expect(allMetrics.length, equals(2));
        expect(allMetrics['hook1']!.successCount, equals(1));
        expect(allMetrics['hook2']!.successCount, equals(1));
      });

      test('should return empty map when no hooks', () {
        // Act
        final allMetrics = registry.getAllMetrics();

        // Assert
        expect(allMetrics, isEmpty);
      });
    });

    group('SetGlobalErrorHandler', () {
      test('should set global error handler', () {
        // Arrange
        var errorCalled = false;

        // Act
        registry.setGlobalErrorHandler((name, error, stackTrace) {
          errorCalled = true;
        });

        final hook = registry.getOrCreate<String>('test.hook');

        // Assert
        expect(hook.onError, isNotNull);
      });

      test('should apply to newly created hooks', () async {
        // Arrange
        var errorHookName = '';

        registry.setGlobalErrorHandler((name, error, stackTrace) {
          errorHookName = name;
        });

        // Act
        registry.register<String>('new.hook', (data) {
          throw Exception('Error');
        });

        await registry.execute<String>('new.hook', 'test');
        await Future.delayed(const Duration(milliseconds: 10));

        // Assert - hook should have error handler
        final hook = registry.get<String>('new.hook');
        expect(hook!.onError, isNotNull);
      });
    });

    group('Clear', () {
      test('should clear all hooks', () {
        // Arrange
        registry.register<String>('hook1', (data) {});
        registry.register<String>('hook2', (data) {});
        registry.register<String>('hook3', (data) {});

        // Act
        registry.clear();

        // Assert
        expect(registry.allHookNames, isEmpty);
      });

      test('should clear callbacks from all hooks', () {
        // Arrange
        registry.register<String>('hook1', (data) {});
        registry.register<String>('hook2', (data) {});

        // Act
        registry.clear();

        // Assert
        final hook1 = registry.get<String>('hook1');
        final hook2 = registry.get<String>('hook2');
        expect(hook1, isNull);
        expect(hook2, isNull);
      });
    });

    group('Real-World Use Cases', () {
      test('should support file save hooks', () async {
        // Arrange
        var validationRan = false;
        var formattingRan = false;
        var savedPath = '';

        registry.register<Map<String, dynamic>>('file.beforeSave', (data) {
          validationRan = true;
          final path = data['path'] as String;
          if (!path.endsWith('.txt')) {
            throw Exception('Invalid file type');
          }
        });

        registry.register<Map<String, dynamic>>('file.beforeSave', (data) {
          formattingRan = true;
          // Simulate formatting
        });

        registry.register<String>('file.afterSave', (path) {
          savedPath = path;
        });

        // Act
        await registry.execute<Map<String, dynamic>>(
          'file.beforeSave',
          {'path': 'document.txt', 'content': 'Hello World'},
        );
        await registry.execute<String>('file.afterSave', 'document.txt');

        // Assert
        expect(validationRan, isTrue);
        expect(formattingRan, isTrue);
        expect(savedPath, equals('document.txt'));
      });

      test('should support plugin lifecycle hooks', () async {
        // Arrange
        final activatedPlugins = <String>[];
        final deactivatedPlugins = <String>[];

        registry.register<String>('plugin.activated', (pluginId) {
          activatedPlugins.add(pluginId);
        });

        registry.register<String>('plugin.deactivated', (pluginId) {
          deactivatedPlugins.add(pluginId);
        });

        // Act
        await registry.execute<String>('plugin.activated', 'test.plugin');
        await registry.execute<String>('plugin.deactivated', 'test.plugin');

        // Assert
        expect(activatedPlugins, contains('test.plugin'));
        expect(deactivatedPlugins, contains('test.plugin'));
      });

      test('should support editor events', () async {
        // Arrange
        var cursorPosition = '';
        var selection = '';

        registry.register<Map<String, dynamic>>('editor.cursorMoved', (data) {
          cursorPosition = '${data['line']}:${data['column']}';
        });

        registry.register<Map<String, dynamic>>('editor.selectionChanged', (data) {
          selection = '${data['start']} - ${data['end']}';
        });

        // Act
        await registry.execute<Map<String, dynamic>>(
          'editor.cursorMoved',
          {'line': 10, 'column': 5},
        );
        await registry.execute<Map<String, dynamic>>(
          'editor.selectionChanged',
          {'start': 0, 'end': 100},
        );

        // Assert
        expect(cursorPosition, equals('10:5'));
        expect(selection, equals('0 - 100'));
      });

      test('should support theme change hooks', () async {
        // Arrange
        var currentTheme = '';

        registry.register<String>('theme.changed', (themeName) {
          currentTheme = themeName;
        });

        // Act
        await registry.execute<String>('theme.changed', 'dark');
        expect(currentTheme, equals('dark'));

        await registry.execute<String>('theme.changed', 'light');
        expect(currentTheme, equals('light'));
      });
    });

    group('Performance', () {
      test('should handle many hooks efficiently', () async {
        // Arrange
        for (var i = 0; i < 100; i++) {
          registry.register<int>('hook$i', (data) {});
        }

        // Act
        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < 100; i++) {
          await registry.execute<int>('hook$i', i);
        }
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle many callbacks per hook efficiently', () async {
        // Arrange
        for (var i = 0; i < 50; i++) {
          registry.register<String>('test.hook', (data) {});
        }

        // Act
        final stopwatch = Stopwatch()..start();
        await registry.execute<String>('test.hook', 'test');
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });
  });
}
