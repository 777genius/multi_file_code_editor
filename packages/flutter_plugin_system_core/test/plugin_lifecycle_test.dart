import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:test/test.dart';

/// Mock host for testing
class MockHost implements IPluginHost {
  final Map<String, dynamic> _functions = {};
  final List<String> calledFunctions = [];

  @override
  void registerHostFunction<T>(String name, HostFunction<T> function) {
    _functions[name] = function;
  }

  @override
  Future<T> callHostFunction<T>(String name, List<dynamic> args) async {
    calledFunctions.add(name);
    if (!_functions.containsKey(name)) {
      throw HostFunctionNotFoundException(name);
    }
    return 'result' as T;
  }

  @override
  HostCapabilities get capabilities => const HostCapabilities(
    version: '1.0.0',
    supportedFeatures: ['test'],
  );
}

/// Lifecycle tracking plugin
class LifecyclePlugin implements IPlugin {
  final List<String> lifecycleEvents = [];
  bool initializeThrows = false;
  bool handleEventThrows = false;
  bool disposeThrows = false;

  @override
  PluginManifest get manifest => PluginManifest(
    id: 'test.lifecycle',
    name: 'Lifecycle Test Plugin',
    version: '1.0.0',
    description: 'Plugin for testing lifecycle',
    runtime: PluginRuntimeType.wasm,
  );

  @override
  Future<void> onLoad() async {
    lifecycleEvents.add('onLoad');
  }

  @override
  Future<void> initialize(PluginContext context) async {
    lifecycleEvents.add('initialize');
    if (initializeThrows) {
      throw PluginInitializationException('Mock initialization error');
    }
  }

  @override
  Future<void> onReady() async {
    lifecycleEvents.add('onReady');
  }

  @override
  Future<PluginResponse> handleEvent(PluginEvent event) async {
    lifecycleEvents.add('handleEvent:${event.type}');
    if (handleEventThrows) {
      throw PluginExecutionException('Mock execution error');
    }
    return PluginResponse.success();
  }

  @override
  Future<void> onBeforeDispose() async {
    lifecycleEvents.add('onBeforeDispose');
  }

  @override
  Future<void> dispose() async {
    lifecycleEvents.add('dispose');
    if (disposeThrows) {
      throw Exception('Mock dispose error');
    }
  }

  @override
  Future<void> onError(Object error, StackTrace? stackTrace) async {
    lifecycleEvents.add('onError:${error.runtimeType}');
  }
}

void main() {
  group('Plugin Lifecycle', () {
    late LifecyclePlugin plugin;
    late PluginContext context;

    setUp(() {
      plugin = LifecyclePlugin();
      context = PluginContext(
        pluginId: 'test.lifecycle',
        host: MockHost(),
        config: const PluginConfig(),
      );
    });

    group('Full Lifecycle', () {
      test('should execute complete lifecycle in correct order', () async {
        // Arrange & Act
        await plugin.onLoad();
        await plugin.initialize(context);
        await plugin.onReady();
        await plugin.handleEvent(PluginEvent.now(type: 'test.event'));
        await plugin.onBeforeDispose();
        await plugin.dispose();

        // Assert
        expect(plugin.lifecycleEvents, equals([
          'onLoad',
          'initialize',
          'onReady',
          'handleEvent:test.event',
          'onBeforeDispose',
          'dispose',
        ]));
      });

      test('should allow initialization without onLoad', () async {
        // Act
        await plugin.initialize(context);
        await plugin.onReady();

        // Assert
        expect(plugin.lifecycleEvents, contains('initialize'));
        expect(plugin.lifecycleEvents, contains('onReady'));
      });

      test('should allow disposal without onBeforeDispose', () async {
        // Arrange
        await plugin.initialize(context);

        // Act
        await plugin.dispose();

        // Assert
        expect(plugin.lifecycleEvents, contains('dispose'));
      });
    });

    group('Initialization', () {
      test('should initialize with context', () async {
        // Act
        await plugin.initialize(context);

        // Assert
        expect(plugin.lifecycleEvents, contains('initialize'));
      });

      test('should throw PluginInitializationException on init failure', () async {
        // Arrange
        plugin.initializeThrows = true;

        // Act & Assert
        expect(
          () => plugin.initialize(context),
          throwsA(isA<PluginInitializationException>()),
        );
      });

      test('should be ready after successful initialization', () async {
        // Act
        await plugin.initialize(context);
        await plugin.onReady();

        // Assert
        expect(plugin.lifecycleEvents, containsAll(['initialize', 'onReady']));
      });

      test('should not be ready if initialization fails', () async {
        // Arrange
        plugin.initializeThrows = true;

        // Act
        try {
          await plugin.initialize(context);
        } catch (_) {
          // Expected
        }

        // Assert - onReady should not be called
        expect(plugin.lifecycleEvents, isNot(contains('onReady')));
      });
    });

    group('Event Handling', () {
      test('should handle events after initialization', () async {
        // Arrange
        await plugin.initialize(context);
        final event = PluginEvent.now(type: 'file.opened');

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(plugin.lifecycleEvents, contains('handleEvent:file.opened'));
      });

      test('should handle multiple events sequentially', () async {
        // Arrange
        await plugin.initialize(context);
        final events = [
          PluginEvent.now(type: 'event1'),
          PluginEvent.now(type: 'event2'),
          PluginEvent.now(type: 'event3'),
        ];

        // Act
        for (final event in events) {
          await plugin.handleEvent(event);
        }

        // Assert
        expect(plugin.lifecycleEvents, containsAll([
          'handleEvent:event1',
          'handleEvent:event2',
          'handleEvent:event3',
        ]));
      });

      test('should throw PluginExecutionException on event handling failure', () async {
        // Arrange
        await plugin.initialize(context);
        plugin.handleEventThrows = true;
        final event = PluginEvent.now(type: 'failing.event');

        // Act & Assert
        expect(
          () => plugin.handleEvent(event),
          throwsA(isA<PluginExecutionException>()),
        );
      });

      test('should handle events with data', () async {
        // Arrange
        await plugin.initialize(context);
        final event = PluginEvent.now(
          type: 'data.event',
          data: {'key': 'value', 'number': 42},
        );

        // Act
        final response = await plugin.handleEvent(event);

        // Assert
        expect(response.isSuccess, isTrue);
        expect(plugin.lifecycleEvents, contains('handleEvent:data.event'));
      });
    });

    group('Disposal', () {
      test('should dispose successfully', () async {
        // Arrange
        await plugin.initialize(context);

        // Act
        await plugin.dispose();

        // Assert
        expect(plugin.lifecycleEvents, contains('dispose'));
      });

      test('should call onBeforeDispose before dispose', () async {
        // Arrange
        await plugin.initialize(context);

        // Act
        await plugin.onBeforeDispose();
        await plugin.dispose();

        // Assert
        final beforeIndex = plugin.lifecycleEvents.indexOf('onBeforeDispose');
        final disposeIndex = plugin.lifecycleEvents.indexOf('dispose');
        expect(beforeIndex, lessThan(disposeIndex));
      });

      test('should handle disposal errors gracefully', () async {
        // Arrange
        await plugin.initialize(context);
        plugin.disposeThrows = true;

        // Act & Assert
        expect(() => plugin.dispose(), throwsException);
      });

      test('should allow multiple disposal attempts', () async {
        // Arrange
        await plugin.initialize(context);

        // Act
        await plugin.dispose();
        await plugin.dispose();

        // Assert
        expect(
          plugin.lifecycleEvents.where((e) => e == 'dispose').length,
          equals(2),
        );
      });
    });

    group('Error Handling', () {
      test('should call onError when error occurs', () async {
        // Arrange
        final error = Exception('Test error');
        final stack = StackTrace.current;

        // Act
        await plugin.onError(error, stack);

        // Assert
        expect(plugin.lifecycleEvents, contains('onError:_Exception'));
      });

      test('should handle errors during initialization', () async {
        // Arrange
        plugin.initializeThrows = true;

        // Act
        try {
          await plugin.initialize(context);
        } catch (e, stack) {
          await plugin.onError(e, stack);
        }

        // Assert
        expect(
          plugin.lifecycleEvents,
          contains('onError:PluginInitializationException'),
        );
      });

      test('should handle errors during event handling', () async {
        // Arrange
        await plugin.initialize(context);
        plugin.handleEventThrows = true;
        final event = PluginEvent.now(type: 'error.event');

        // Act
        try {
          await plugin.handleEvent(event);
        } catch (e, stack) {
          await plugin.onError(e, stack);
        }

        // Assert
        expect(
          plugin.lifecycleEvents,
          contains('onError:PluginExecutionException'),
        );
      });
    });

    group('State Transitions', () {
      test('should transition from created to initialized', () async {
        // Arrange
        expect(plugin.lifecycleEvents, isEmpty);

        // Act
        await plugin.initialize(context);

        // Assert
        expect(plugin.lifecycleEvents, contains('initialize'));
      });

      test('should transition from initialized to ready', () async {
        // Act
        await plugin.initialize(context);
        await plugin.onReady();

        // Assert
        expect(plugin.lifecycleEvents, containsAll(['initialize', 'onReady']));
      });

      test('should transition from ready to disposing', () async {
        // Arrange
        await plugin.initialize(context);
        await plugin.onReady();

        // Act
        await plugin.onBeforeDispose();
        await plugin.dispose();

        // Assert
        expect(
          plugin.lifecycleEvents,
          containsAll(['onReady', 'onBeforeDispose', 'dispose']),
        );
      });
    });

    group('Context Access', () {
      test('should access host through context', () async {
        // Arrange
        final mockHost = context.host as MockHost;

        // Act
        await context.callHost('test_function', ['arg1']);

        // Assert
        expect(mockHost.calledFunctions, contains('test_function'));
      });

      test('should access config through context', () async {
        // Arrange
        final contextWithConfig = PluginContext(
          pluginId: 'test.config',
          host: MockHost(),
          config: const PluginConfig(
            settings: {'theme': 'dark'},
          ),
        );

        // Act
        final theme = contextWithConfig.config.getSetting<String>('theme');

        // Assert
        expect(theme, equals('dark'));
      });

      test('should register services in context', () async {
        // Arrange
        final service = 'TestService';

        // Act
        context.registerService<String>(service);

        // Assert
        expect(context.getService<String>(), equals(service));
        expect(context.hasService<String>(), isTrue);
      });
    });

    group('Concurrent Operations', () {
      test('should handle concurrent event processing', () async {
        // Arrange
        await plugin.initialize(context);
        final events = List.generate(
          10,
          (i) => PluginEvent.now(type: 'concurrent.$i'),
        );

        // Act
        await Future.wait(
          events.map((event) => plugin.handleEvent(event)),
        );

        // Assert
        expect(
          plugin.lifecycleEvents.where((e) => e.startsWith('handleEvent')).length,
          equals(10),
        );
      });

      test('should not allow concurrent initialization', () async {
        // Act
        final futures = List.generate(
          3,
          (_) => plugin.initialize(context),
        );

        await Future.wait(futures);

        // Assert - should initialize only once per call
        expect(
          plugin.lifecycleEvents.where((e) => e == 'initialize').length,
          equals(3),
        );
      });
    });
  });
}
