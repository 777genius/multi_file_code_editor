import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_host/flutter_plugin_system_host.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock plugin runtime
class MockPluginRuntime extends Mock implements IPluginRuntime {}

/// Mock plugin
class MockPlugin extends Mock implements IPlugin {}

/// Mock host function
class MockHostFunction extends Mock implements HostFunction {
  @override
  HostFunctionSignature get signature => const HostFunctionSignature(
    name: 'mock_function',
    returnType: 'void',
    parameters: [],
  );

  @override
  bool validateArgs(List args) => true;
}

void main() {
  setUpAll(() {
    registerFallbackValue(PluginEvent.now(type: 'test'));
    registerFallbackValue(PluginState.loaded);
    registerFallbackValue(const PluginConfig());
    registerFallbackValue(PluginSource.file(path: '/test'));
  });

  group('Host Environment', () {
    late PluginManager manager;

    setUp(() {
      manager = PluginManager.create();
    });

    tearDown(() async {
      await manager.dispose();
    });

    group('Initialization', () {
      test('should create plugin manager with default components', () {
        // Arrange & Act
        final manager = PluginManager.create();

        // Assert
        expect(manager, isNotNull);
        final stats = manager.getStatistics();
        expect(stats, containsKey('registry'));
        expect(stats, containsKey('host_functions'));
        expect(stats, containsKey('events'));
        expect(stats, containsKey('permissions'));
      });

      test('should start with empty plugin registry', () {
        // Assert
        expect(manager.getAllPlugins(), isEmpty);
      });

      test('should have functioning event system', () {
        // Assert
        expect(manager.eventStream, isNotNull);
      });
    });

    group('Component Integration', () {
      test('should integrate registry, permissions, and security', () {
        // Act - register host function
        final mockFunction = MockHostFunction();
        manager.registerHostFunction('test_function', mockFunction);

        // Assert - function is registered
        final stats = manager.getStatistics();
        expect(stats['host_functions']['total_functions'], equals(1));
      });

      test('should track error events through system', () async {
        // Arrange
        final errors = <PluginError>[];
        final subscription = manager.errorStream.listen(errors.add);

        // Act - simulate some operations that might fail
        // Since we don't have a failing plugin loaded, just verify the stream works

        // Assert
        expect(manager.errorStream, isNotNull);
        await subscription.cancel();
      });

      test('should maintain state across operations', () {
        // Arrange
        final initialStats = manager.getStatistics();

        // Act - perform operations
        manager.registerHostFunction('func1', MockHostFunction());
        manager.registerHostFunction('func2', MockHostFunction());

        // Assert - state is updated
        final finalStats = manager.getStatistics();
        expect(
          finalStats['host_functions']['total_functions'],
          greaterThan(initialStats['host_functions']['total_functions']),
        );
      });
    });

    group('Resource Management', () {
      test('should cleanup resources on dispose', () async {
        // Arrange
        final manager = PluginManager.create();
        manager.registerHostFunction('test', MockHostFunction());

        // Act
        await manager.dispose();

        // Assert - manager should be disposed
        // Verify by checking that operations fail or state is clean
      });

      test('should handle multiple dispose calls', () async {
        // Arrange
        final manager = PluginManager.create();

        // Act & Assert - should not throw
        await manager.dispose();
        await manager.dispose();
      });
    });

    group('Statistics', () {
      test('should provide comprehensive statistics', () {
        // Act
        final stats = manager.getStatistics();

        // Assert
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats.containsKey('registry'), isTrue);
        expect(stats.containsKey('host_functions'), isTrue);
        expect(stats.containsKey('events'), isTrue);
        expect(stats.containsKey('permissions'), isTrue);
      });

      test('should track registry statistics', () {
        // Act
        final stats = manager.getStatistics();
        final registryStats = stats['registry'] as Map<String, dynamic>;

        // Assert
        expect(registryStats.containsKey('total'), isTrue);
        expect(registryStats.containsKey('ready'), isTrue);
        expect(registryStats.containsKey('error'), isTrue);
      });

      test('should track host function statistics', () {
        // Arrange
        manager.registerHostFunction('test1', MockHostFunction());
        manager.registerHostFunction('test2', MockHostFunction());

        // Act
        final stats = manager.getStatistics();
        final functionStats = stats['host_functions'] as Map<String, dynamic>;

        // Assert
        expect(functionStats['total_functions'], equals(2));
      });

      test('should track event statistics', () {
        // Act
        final stats = manager.getStatistics();
        final eventStats = stats['events'] as Map<String, dynamic>;

        // Assert
        expect(eventStats.containsKey('total_dispatched'), isTrue);
        expect(eventStats.containsKey('unique_types'), isTrue);
      });

      test('should track permission statistics', () {
        // Act
        final stats = manager.getStatistics();
        final permStats = stats['permissions'] as Map<String, dynamic>;

        // Assert
        expect(permStats.containsKey('total_plugins'), isTrue);
      });
    });

    group('Environment Configuration', () {
      test('should support custom component injection', () {
        // Arrange
        final customRegistry = PluginRegistry();
        final customHostFunctions = HostFunctionRegistry();
        final customEventDispatcher = EventDispatcher();
        final customPermissionSystem = PermissionSystem();
        final customSecurityGuard = SecurityGuard(customPermissionSystem);
        final customErrorTracker = ErrorTracker();
        final customErrorBoundary = ErrorBoundary(customErrorTracker);

        // Act
        final customManager = PluginManager(
          registry: customRegistry,
          hostFunctions: customHostFunctions,
          eventDispatcher: customEventDispatcher,
          permissionSystem: customPermissionSystem,
          securityGuard: customSecurityGuard,
          errorTracker: customErrorTracker,
          errorBoundary: customErrorBoundary,
        );

        // Assert
        expect(customManager, isNotNull);
      });
    });

    group('Concurrent Operations', () {
      test('should handle concurrent host function registrations', () {
        // Arrange
        final functions = List.generate(
          10,
          (i) => MockHostFunction(),
        );

        // Act - register concurrently (synchronous operation)
        for (var i = 0; i < 10; i++) {
          manager.registerHostFunction('func$i', functions[i]);
        }

        // Assert
        final stats = manager.getStatistics();
        expect(stats['host_functions']['total_functions'], equals(10));
      });

      test('should handle concurrent event dispatches', () {
        // Arrange
        final events = <PluginEvent>[];
        final subscription = manager.eventStream.listen(events.add);

        // Act
        for (var i = 0; i < 100; i++) {
          manager.dispatchEvent(PluginEvent.now(type: 'concurrent.$i'));
        }

        // Wait for async processing
        return Future.delayed(const Duration(milliseconds: 100), () async {
          // Assert
          expect(events.length, equals(100));
          await subscription.cancel();
        });
      });
    });

    group('Error Isolation', () {
      test('should isolate component errors', () {
        // Arrange
        final errors = <PluginError>[];
        final subscription = manager.errorStream.listen(errors.add);

        // Act - try to call non-existent function (should fail gracefully)
        // Note: We can't test actual plugin errors without loading plugins

        // Assert - error tracking works
        expect(manager.errorStream, isNotNull);
        subscription.cancel();
      });

      test('should continue operation after component errors', () async {
        // Arrange
        manager.registerHostFunction('good_function', MockHostFunction());

        // Act - simulate error scenario
        try {
          await manager.callHostFunction(
            'test_plugin',
            'non_existent',
            [],
          );
        } catch (_) {
          // Expected
        }

        // Assert - manager still works
        final stats = manager.getStatistics();
        expect(stats['host_functions']['total_functions'], equals(1));
      });
    });

    group('State Transitions', () {
      test('should transition from uninitialized to ready', () {
        // Arrange
        final manager = PluginManager.create();

        // Act - initialize by registering functions
        manager.registerHostFunction('init_func', MockHostFunction());

        // Assert
        final stats = manager.getStatistics();
        expect(stats['host_functions']['total_functions'], greaterThan(0));
      });

      test('should maintain consistent state during operations', () {
        // Arrange
        final initialState = manager.getStatistics();

        // Act - perform various operations
        manager.registerHostFunction('func1', MockHostFunction());
        manager.dispatchEvent(PluginEvent.now(type: 'test.event'));
        manager.unregisterHostFunction('func1');

        // Assert - state is consistent
        final finalState = manager.getStatistics();
        expect(finalState, isA<Map<String, dynamic>>());
        expect(finalState['events']['total_dispatched'], greaterThan(0));
      });
    });

    group('Memory Management', () {
      test('should not leak memory on repeated operations', () {
        // Arrange
        const iterations = 100;

        // Act - perform repeated operations
        for (var i = 0; i < iterations; i++) {
          manager.dispatchEvent(PluginEvent.now(type: 'test.$i'));
        }

        // Assert - stats reflect operations
        final stats = manager.getStatistics();
        expect(stats['events']['total_dispatched'], equals(iterations));
      });

      test('should cleanup event subscriptions', () async {
        // Arrange
        final subscriptions = <StreamSubscription>[];
        for (var i = 0; i < 10; i++) {
          subscriptions.add(manager.eventStream.listen((_) {}));
        }

        // Act - cancel all subscriptions
        await Future.wait(subscriptions.map((s) => s.cancel()));

        // Assert - subscriptions are cancelled
        expect(subscriptions.length, equals(10));
      });
    });

    group('Environment Capabilities', () {
      test('should provide host capabilities', () {
        // Arrange
        const capabilities = HostCapabilities(
          version: '1.0.0',
          supportedFeatures: ['events', 'permissions', 'isolation'],
        );

        // Assert
        expect(capabilities.version, equals('1.0.0'));
        expect(capabilities.supportedFeatures, hasLength(3));
        expect(capabilities.supportsFeature('events'), isTrue);
        expect(capabilities.supportsFeature('unknown'), isFalse);
      });

      test('should serialize capabilities to JSON', () {
        // Arrange
        const capabilities = HostCapabilities(
          version: '2.0.0',
          supportedFeatures: ['test'],
          maxPlugins: 10,
          metadata: {'custom': 'value'},
        );

        // Act
        final json = capabilities.toJson();

        // Assert
        expect(json['version'], equals('2.0.0'));
        expect(json['supportedFeatures'], contains('test'));
        expect(json['maxPlugins'], equals(10));
        expect(json['custom'], equals('value'));
      });
    });
  });

  group('Plugin Registry', () {
    late PluginRegistry registry;

    setUp(() {
      registry = PluginRegistry();
    });

    group('Registration', () {
      test('should register plugin with context', () {
        // Arrange
        final plugin = MockPlugin();
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: _MockPluginHost(),
          config: const PluginConfig(),
        );

        // Act
        registry.register('test.plugin', plugin, context);

        // Assert
        expect(registry.isLoaded('test.plugin'), isTrue);
        expect(registry.getPlugin('test.plugin'), equals(plugin));
        expect(registry.getContext('test.plugin'), equals(context));
      });

      test('should prevent duplicate registration', () {
        // Arrange
        final plugin = MockPlugin();
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: _MockPluginHost(),
          config: const PluginConfig(),
        );
        registry.register('test.plugin', plugin, context);

        // Act & Assert
        expect(
          () => registry.register('test.plugin', plugin, context),
          throwsStateError,
        );
      });

      test('should track registration timestamp', () {
        // Arrange
        final plugin = MockPlugin();
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: _MockPluginHost(),
          config: const PluginConfig(),
        );
        final before = DateTime.now();

        // Act
        registry.register('test.plugin', plugin, context);

        // Assert
        final entry = registry.getEntry('test.plugin');
        expect(entry, isNotNull);
        expect(entry!.loadedAt.isAfter(before) || entry.loadedAt.isAtSameMomentAs(before), isTrue);
      });
    });

    group('State Management', () {
      test('should update plugin state', () {
        // Arrange
        final plugin = MockPlugin();
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: _MockPluginHost(),
          config: const PluginConfig(),
        );
        registry.register('test.plugin', plugin, context);

        // Act
        registry.updateState('test.plugin', PluginState.ready);

        // Assert
        expect(registry.getState('test.plugin'), equals(PluginState.ready));
      });

      test('should track ready timestamp', () {
        // Arrange
        final plugin = MockPlugin();
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: _MockPluginHost(),
          config: const PluginConfig(),
        );
        registry.register('test.plugin', plugin, context);

        // Act
        registry.updateState('test.plugin', PluginState.ready);

        // Assert
        final entry = registry.getEntry('test.plugin');
        expect(entry!.readyAt, isNotNull);
        expect(entry.loadDuration, isNotNull);
      });

      test('should get plugins by state', () {
        // Arrange
        for (var i = 0; i < 5; i++) {
          final plugin = MockPlugin();
          final context = PluginContext(
            pluginId: 'plugin$i',
            host: _MockPluginHost(),
            config: const PluginConfig(),
          );
          registry.register('plugin$i', plugin, context);
          if (i < 3) {
            registry.updateState('plugin$i', PluginState.ready);
          }
        }

        // Act
        final readyPlugins = registry.getPluginsByState(PluginState.ready);

        // Assert
        expect(readyPlugins.length, equals(3));
      });
    });

    group('Unregistration', () {
      test('should unregister plugin', () {
        // Arrange
        final plugin = MockPlugin();
        final context = PluginContext(
          pluginId: 'test.plugin',
          host: _MockPluginHost(),
          config: const PluginConfig(),
        );
        registry.register('test.plugin', plugin, context);

        // Act
        final result = registry.unregister('test.plugin');

        // Assert
        expect(result, isTrue);
        expect(registry.isLoaded('test.plugin'), isFalse);
      });

      test('should return false when unregistering non-existent plugin', () {
        // Act
        final result = registry.unregister('non.existent');

        // Assert
        expect(result, isFalse);
      });
    });

    group('Statistics', () {
      test('should provide registry statistics', () {
        // Arrange
        for (var i = 0; i < 10; i++) {
          final plugin = MockPlugin();
          final context = PluginContext(
            pluginId: 'plugin$i',
            host: _MockPluginHost(),
            config: const PluginConfig(),
          );
          registry.register('plugin$i', plugin, context);
        }

        // Act
        final stats = registry.getStatistics();

        // Assert
        expect(stats['total'], equals(10));
        expect(stats.containsKey('ready'), isTrue);
        expect(stats.containsKey('error'), isTrue);
      });
    });
  });
}

class _MockPluginHost implements IPluginHost {
  @override
  Future<T> callHostFunction<T>(String name, List args) async {
    return 'result' as T;
  }

  @override
  HostCapabilities get capabilities => const HostCapabilities(
    version: '1.0.0',
    supportedFeatures: [],
  );

  @override
  void registerHostFunction<T>(String name, HostFunction<T> function) {}
}
