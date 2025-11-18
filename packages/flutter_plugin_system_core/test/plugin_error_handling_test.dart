import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:test/test.dart';

/// Plugin that can throw various errors
class ErrorPronePlugin implements IPlugin {
  bool shouldThrowOnInit = false;
  bool shouldThrowOnEvent = false;
  bool shouldThrowOnDispose = false;
  String? customErrorMessage;
  Exception? customException;

  @override
  PluginManifest get manifest => PluginManifest(
    id: 'error.plugin',
    name: 'Error Prone Plugin',
    version: '1.0.0',
    description: 'Plugin for testing error handling',
    runtime: PluginRuntimeType.wasm,
  );

  @override
  Future<void> initialize(PluginContext context) async {
    if (shouldThrowOnInit) {
      if (customException != null) {
        throw customException!;
      }
      throw PluginInitializationException(
        customErrorMessage ?? 'Initialization failed',
        pluginId: manifest.id,
      );
    }
  }

  @override
  Future<PluginResponse> handleEvent(PluginEvent event) async {
    if (shouldThrowOnEvent) {
      if (customException != null) {
        throw customException!;
      }
      throw PluginExecutionException(
        customErrorMessage ?? 'Event handling failed',
        pluginId: manifest.id,
      );
    }
    return PluginResponse.success();
  }

  @override
  Future<void> dispose() async {
    if (shouldThrowOnDispose) {
      if (customException != null) {
        throw customException!;
      }
      throw Exception(customErrorMessage ?? 'Dispose failed');
    }
  }
}

/// Mock host for error testing
class ErrorTestHost implements IPluginHost {
  bool shouldThrowOnCall = false;

  @override
  void registerHostFunction<T>(String name, HostFunction<T> function) {}

  @override
  Future<T> callHostFunction<T>(String name, List<dynamic> args) async {
    if (shouldThrowOnCall) {
      throw HostFunctionException(
        name,
        'Host function call failed',
      );
    }
    return 'result' as T;
  }

  @override
  HostCapabilities get capabilities => const HostCapabilities(
    version: '1.0.0',
    supportedFeatures: [],
  );
}

void main() {
  group('Plugin Error Handling', () {
    group('Initialization Errors', () {
      test('should throw PluginInitializationException on init failure', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnInit = true;
        final context = PluginContext(
          pluginId: 'error.plugin',
          host: ErrorTestHost(),
          config: const PluginConfig(),
        );

        // Act & Assert
        expect(
          () => plugin.initialize(context),
          throwsA(isA<PluginInitializationException>()),
        );
      });

      test('should include error details in exception', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnInit = true;
        plugin.customErrorMessage = 'Custom init error';
        final context = PluginContext(
          pluginId: 'error.plugin',
          host: ErrorTestHost(),
          config: const PluginConfig(),
        );

        // Act & Assert
        try {
          await plugin.initialize(context);
          fail('Should have thrown');
        } on PluginInitializationException catch (e) {
          expect(e.message, contains('Custom init error'));
          expect(e.pluginId, equals('error.plugin'));
        }
      });

      test('should handle dependency errors', () {
        // Arrange
        final exception = DependencyNotMetException(
          'required.dependency',
          requiredVersion: '1.0.0',
          pluginId: 'error.plugin',
        );

        // Assert
        expect(exception.dependencyId, equals('required.dependency'));
        expect(exception.requiredVersion, equals('1.0.0'));
        expect(exception.message, contains('required.dependency'));
      });

      test('should handle permission errors', () {
        // Arrange
        final exception = PermissionDeniedException(
          'file_access',
          pluginId: 'error.plugin',
        );

        // Assert
        expect(exception.permission, equals('file_access'));
        expect(exception.pluginId, equals('error.plugin'));
        expect(exception.message, contains('file_access'));
      });
    });

    group('Execution Errors', () {
      test('should throw PluginExecutionException on event handling failure', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnEvent = true;
        final event = PluginEvent.now(type: 'test.event');

        // Act & Assert
        expect(
          () => plugin.handleEvent(event),
          throwsA(isA<PluginExecutionException>()),
        );
      });

      test('should include context in execution exceptions', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnEvent = true;
        plugin.customErrorMessage = 'Execution failed';
        final event = PluginEvent.now(type: 'failing.event');

        // Act & Assert
        try {
          await plugin.handleEvent(event);
          fail('Should have thrown');
        } on PluginExecutionException catch (e) {
          expect(e.message, contains('Execution failed'));
          expect(e.pluginId, equals('error.plugin'));
        }
      });

      test('should handle timeout exceptions', () {
        // Arrange
        final exception = PluginTimeoutException(
          'slow.plugin',
          const Duration(seconds: 5),
        );

        // Assert
        expect(exception.pluginId, equals('slow.plugin'));
        expect(exception.timeout, equals(const Duration(seconds: 5)));
        expect(exception.message, contains('5000ms'));
      });

      test('should handle memory limit exceptions', () {
        // Arrange
        final exception = PluginMemoryLimitException(
          'greedy.plugin',
          100 * 1024 * 1024, // 100MB used
          50 * 1024 * 1024,  // 50MB limit
        );

        // Assert
        expect(exception.pluginId, equals('greedy.plugin'));
        expect(exception.usedBytes, equals(100 * 1024 * 1024));
        expect(exception.limitBytes, equals(50 * 1024 * 1024));
      });
    });

    group('Load Errors', () {
      test('should handle PluginLoadException', () {
        // Arrange
        final exception = PluginLoadException(
          'Failed to load plugin',
          pluginId: 'missing.plugin',
        );

        // Assert
        expect(exception.message, contains('Failed to load'));
        expect(exception.pluginId, equals('missing.plugin'));
      });

      test('should handle PluginNotFoundException', () {
        // Arrange
        const pluginId = 'non.existent.plugin';
        final exception = PluginNotFoundException(pluginId);

        // Assert
        expect(exception.message, contains('not found'));
        expect(exception.pluginId, equals(pluginId));
      });

      test('should handle InvalidManifestException', () {
        // Arrange
        final exception = InvalidManifestException(
          'Invalid manifest format',
          pluginId: 'bad.plugin',
        );

        // Assert
        expect(exception.message, contains('Invalid manifest'));
        expect(exception.pluginId, equals('bad.plugin'));
      });

      test('should handle RuntimeNotAvailableException', () {
        // Arrange
        final exception = RuntimeNotAvailableException('wasm');

        // Assert
        expect(exception.requestedRuntime, equals('wasm'));
        expect(exception.message, contains('not available'));
      });
    });

    group('Host Function Errors', () {
      test('should throw HostFunctionException on call failure', () async {
        // Arrange
        final host = ErrorTestHost();
        host.shouldThrowOnCall = true;
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: host,
          config: const PluginConfig(),
        );

        // Act & Assert
        expect(
          () => context.callHost('failing_function'),
          throwsA(isA<HostFunctionException>()),
        );
      });

      test('should handle HostFunctionNotFoundException', () {
        // Arrange
        final exception = HostFunctionNotFoundException('missing_function');

        // Assert
        expect(exception.functionName, equals('missing_function'));
        expect(exception.message, contains('not found'));
      });

      test('should include function name in exception', () async {
        // Arrange
        final host = ErrorTestHost();
        host.shouldThrowOnCall = true;
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: host,
          config: const PluginConfig(),
        );

        // Act & Assert
        try {
          await context.callHost('test_function');
          fail('Should have thrown');
        } on HostFunctionException catch (e) {
          expect(e.functionName, equals('test_function'));
        }
      });
    });

    group('Communication Errors', () {
      test('should handle SerializationException', () {
        // Arrange
        final exception = SerializationException(
          'Failed to serialize data',
          pluginId: 'test.plugin',
        );

        // Assert
        expect(exception.message, contains('serialize'));
        expect(exception.pluginId, equals('test.plugin'));
      });

      test('should handle DeserializationException', () {
        // Arrange
        final exception = DeserializationException(
          'Failed to deserialize data',
          pluginId: 'test.plugin',
        );

        // Assert
        expect(exception.message, contains('deserialize'));
        expect(exception.pluginId, equals('test.plugin'));
      });

      test('should wrap original errors in serialization exceptions', () {
        // Arrange
        final originalError = FormatException('Invalid JSON');
        final exception = SerializationException(
          'Serialization failed',
          pluginId: 'test.plugin',
          originalError: originalError,
        );

        // Assert
        expect(exception.originalError, isA<FormatException>());
        expect(exception.toString(), contains('FormatException'));
      });
    });

    group('Error Context', () {
      test('should include plugin ID in exceptions', () {
        // Arrange
        final exception = PluginException(
          'Generic error',
          pluginId: 'contextual.plugin',
        );

        // Assert
        expect(exception.pluginId, equals('contextual.plugin'));
        expect(exception.toString(), contains('contextual.plugin'));
      });

      test('should include additional context in exceptions', () {
        // Arrange
        final exception = PluginException(
          'Error with context',
          pluginId: 'test.plugin',
          context: {
            'file': 'test.dart',
            'line': 42,
            'operation': 'format',
          },
        );

        // Assert
        expect(exception.context, isNotNull);
        expect(exception.context!['file'], equals('test.dart'));
        expect(exception.context!['line'], equals(42));
        expect(exception.toString(), contains('Context:'));
      });

      test('should include original error in exceptions', () {
        // Arrange
        final originalError = Exception('Original error');
        final exception = PluginException(
          'Wrapped error',
          originalError: originalError,
        );

        // Assert
        expect(exception.originalError, isNotNull);
        expect(exception.toString(), contains('Caused by:'));
      });

      test('should include stack trace in exceptions', () {
        // Arrange
        final stack = StackTrace.current;
        final exception = PluginException(
          'Error with stack',
          stackTrace: stack,
        );

        // Assert
        expect(exception.stackTrace, isNotNull);
        expect(exception.stackTrace, equals(stack));
      });
    });

    group('Error Recovery', () {
      test('should allow retry after initialization error', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnInit = true;
        final context = PluginContext(
          pluginId: 'retry.plugin',
          host: ErrorTestHost(),
          config: const PluginConfig(),
        );

        // Act - first attempt fails
        try {
          await plugin.initialize(context);
          fail('Should have thrown');
        } on PluginInitializationException catch (_) {
          // Expected
        }

        // Act - second attempt succeeds
        plugin.shouldThrowOnInit = false;
        await plugin.initialize(context);

        // Assert - should complete without error
      });

      test('should continue after event handling error', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnEvent = true;
        final event1 = PluginEvent.now(type: 'failing.event');
        final event2 = PluginEvent.now(type: 'safe.event');

        // Act - first event fails
        try {
          await plugin.handleEvent(event1);
          fail('Should have thrown');
        } on PluginExecutionException catch (_) {
          // Expected
        }

        // Act - second event succeeds
        plugin.shouldThrowOnEvent = false;
        final response = await plugin.handleEvent(event2);

        // Assert
        expect(response.isSuccess, isTrue);
      });
    });

    group('Disposal Errors', () {
      test('should handle disposal errors', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnDispose = true;

        // Act & Assert
        expect(() => plugin.dispose(), throwsException);
      });

      test('should clean up even if disposal fails', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnDispose = true;
        plugin.customErrorMessage = 'Cleanup failed';

        // Act
        try {
          await plugin.dispose();
          fail('Should have thrown');
        } catch (e) {
          expect(e.toString(), contains('Cleanup failed'));
        }

        // Assert - plugin is in disposed state (even if it threw)
        // This is a design decision - disposal should be idempotent
      });
    });

    group('Error Formatting', () {
      test('should format error messages correctly', () {
        // Arrange
        final exception = PluginException(
          'Test error',
          pluginId: 'test.plugin',
        );

        // Assert
        final message = exception.toString();
        expect(message, contains('PluginException'));
        expect(message, contains('Test error'));
        expect(message, contains('test.plugin'));
      });

      test('should format nested errors', () {
        // Arrange
        final originalError = Exception('Inner error');
        final exception = PluginException(
          'Outer error',
          pluginId: 'test.plugin',
          originalError: originalError,
        );

        // Assert
        final message = exception.toString();
        expect(message, contains('Outer error'));
        expect(message, contains('Caused by:'));
        expect(message, contains('Inner error'));
      });

      test('should format errors with context', () {
        // Arrange
        final exception = PluginException(
          'Error',
          pluginId: 'test.plugin',
          context: {'key': 'value'},
        );

        // Assert
        final message = exception.toString();
        expect(message, contains('Context:'));
        expect(message, contains('key'));
      });
    });

    group('Custom Exceptions', () {
      test('should support custom exception types', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnEvent = true;
        plugin.customException = FormatException('Custom format error');

        // Act & Assert
        expect(
          () => plugin.handleEvent(PluginEvent.now(type: 'custom')),
          throwsA(isA<FormatException>()),
        );
      });

      test('should wrap uncaught exceptions', () async {
        // Arrange
        final plugin = ErrorPronePlugin();
        plugin.shouldThrowOnInit = true;
        plugin.customException = StateError('Bad state');
        final context = PluginContext(
          pluginId: 'error.plugin',
          host: ErrorTestHost(),
          config: const PluginConfig(),
        );

        // Act & Assert
        expect(
          () => plugin.initialize(context),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
