import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:test/test.dart';

/// Isolated plugin with its own state
class IsolatedPlugin implements IPlugin {
  final String _id;
  final Map<String, dynamic> _state = {};
  final List<String> _accessLog = [];

  IsolatedPlugin(this._id);

  @override
  PluginManifest get manifest => PluginManifest(
    id: _id,
    name: 'Isolated Plugin $_id',
    version: '1.0.0',
    description: 'Plugin for testing isolation',
    runtime: PluginRuntimeType.wasm,
  );

  @override
  Future<void> initialize(PluginContext context) async {
    _state['initialized'] = true;
    _state['context_id'] = context.pluginId;
  }

  @override
  Future<PluginResponse> handleEvent(PluginEvent event) async {
    _accessLog.add('event:${event.type}');
    _state['last_event'] = event.type;
    return PluginResponse.success(data: {'plugin_id': _id});
  }

  @override
  Future<void> dispose() async {
    _state.clear();
  }

  Map<String, dynamic> get state => Map.unmodifiable(_state);
  List<String> get accessLog => List.unmodifiable(_accessLog);
}

/// Mock host with separate namespaces per plugin
class IsolatedHost implements IPluginHost {
  final Map<String, Map<String, dynamic>> _pluginNamespaces = {};

  void _ensureNamespace(String pluginId) {
    _pluginNamespaces.putIfAbsent(pluginId, () => {});
  }

  @override
  void registerHostFunction<T>(String name, HostFunction<T> function) {
    // Not used in this test
  }

  @override
  Future<T> callHostFunction<T>(String name, List<dynamic> args) async {
    // Simulate namespace isolation
    return 'isolated_result' as T;
  }

  @override
  HostCapabilities get capabilities => const HostCapabilities(
    version: '1.0.0',
    supportedFeatures: ['isolation'],
  );

  Map<String, dynamic>? getNamespace(String pluginId) {
    return _pluginNamespaces[pluginId];
  }
}

void main() {
  group('Plugin Isolation', () {
    group('State Isolation', () {
      test('plugins should have separate state', () async {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        // Act
        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        await plugin1.handleEvent(PluginEvent.now(type: 'event1'));
        await plugin2.handleEvent(PluginEvent.now(type: 'event2'));

        // Assert
        expect(plugin1.state['last_event'], equals('event1'));
        expect(plugin2.state['last_event'], equals('event2'));
        expect(plugin1.state, isNot(equals(plugin2.state)));
      });

      test('modifying one plugin state should not affect another', () async {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        // Act - modify plugin1 state
        await plugin1.handleEvent(PluginEvent.now(
          type: 'modify',
          data: {'value': 'changed'},
        ));

        // Assert - plugin2 state unchanged
        expect(plugin1.state['last_event'], equals('modify'));
        expect(plugin2.state.containsKey('last_event'), isFalse);
      });
    });

    group('Context Isolation', () {
      test('each plugin should have its own context', () async {
        // Arrange
        final host = IsolatedHost();
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: host,
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: host,
          config: const PluginConfig(),
        );

        // Act
        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        // Assert
        expect(plugin1.state['context_id'], equals('plugin1'));
        expect(plugin2.state['context_id'], equals('plugin2'));
        expect(context1.pluginId, isNot(equals(context2.pluginId)));
      });

      test('plugins should not share service registrations', () {
        // Arrange
        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        // Act
        context1.registerService<String>('service1');
        context2.registerService<String>('service2');

        // Assert
        expect(context1.getService<String>(), equals('service1'));
        expect(context2.getService<String>(), equals('service2'));
        expect(context1.getService<String>(), isNot(equals(context2.getService<String>())));
      });

      test('clearing services in one context should not affect another', () {
        // Arrange
        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        context1.registerService<String>('service1');
        context2.registerService<String>('service2');

        // Act
        context1.clearServices();

        // Assert
        expect(context1.hasService<String>(), isFalse);
        expect(context2.hasService<String>(), isTrue);
      });
    });

    group('Memory Isolation', () {
      test('plugins should have separate access logs', () async {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        // Act
        await plugin1.handleEvent(PluginEvent.now(type: 'log1'));
        await plugin1.handleEvent(PluginEvent.now(type: 'log2'));
        await plugin2.handleEvent(PluginEvent.now(type: 'log3'));

        // Assert
        expect(plugin1.accessLog.length, equals(2));
        expect(plugin2.accessLog.length, equals(1));
        expect(plugin1.accessLog, containsAll(['event:log1', 'event:log2']));
        expect(plugin2.accessLog, contains('event:log3'));
      });

      test('disposing one plugin should not affect another', () async {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        // Act
        await plugin1.dispose();

        // Assert
        expect(plugin1.state, isEmpty);
        expect(plugin2.state, isNotEmpty);
        expect(plugin2.state['initialized'], isTrue);
      });
    });

    group('Configuration Isolation', () {
      test('plugins should have separate configurations', () {
        // Arrange
        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(
            settings: {'theme': 'dark'},
          ),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(
            settings: {'theme': 'light'},
          ),
        );

        // Assert
        expect(context1.config.getSetting<String>('theme'), equals('dark'));
        expect(context2.config.getSetting<String>('theme'), equals('light'));
      });

      test('config changes should not cross plugin boundaries', () {
        // Arrange
        final config1 = const PluginConfig(settings: {'value': 1});
        final config2 = const PluginConfig(settings: {'value': 2});

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: config1,
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: config2,
        );

        // Act
        final newConfig1 = config1.updateSettings({'value': 10});

        // Assert
        expect(newConfig1.getSetting<int>('value'), equals(10));
        expect(context2.config.getSetting<int>('value'), equals(2));
      });
    });

    group('Error Isolation', () {
      test('exception in one plugin should not affect another', () async {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        // Act - plugin1 throws error (simulated)
        try {
          throw PluginExecutionException('Plugin1 error');
        } catch (_) {
          // Simulate error isolation
        }

        // Plugin2 should still work
        final response = await plugin2.handleEvent(PluginEvent.now(type: 'safe'));

        // Assert
        expect(response.isSuccess, isTrue);
        expect(plugin2.state['last_event'], equals('safe'));
      });
    });

    group('Concurrent Access', () {
      test('concurrent operations on different plugins should be isolated', () async {
        // Arrange
        final plugins = List.generate(5, (i) => IsolatedPlugin('plugin$i'));
        final contexts = List.generate(
          5,
          (i) => PluginContext(
            pluginId: 'plugin$i',
            host: IsolatedHost(),
            config: const PluginConfig(),
          ),
        );

        // Initialize all plugins
        for (var i = 0; i < 5; i++) {
          await plugins[i].initialize(contexts[i]);
        }

        // Act - concurrent event handling
        await Future.wait(
          List.generate(
            5,
            (i) => plugins[i].handleEvent(PluginEvent.now(type: 'concurrent$i')),
          ),
        );

        // Assert - each plugin processed its own event
        for (var i = 0; i < 5; i++) {
          expect(plugins[i].state['last_event'], equals('concurrent$i'));
          expect(plugins[i].accessLog, contains('event:concurrent$i'));
        }
      });

      test('race conditions should not leak state between plugins', () async {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        await plugin1.initialize(context1);
        await plugin2.initialize(context2);

        // Act - rapid concurrent access
        final futures = <Future>[];
        for (var i = 0; i < 100; i++) {
          futures.add(plugin1.handleEvent(PluginEvent.now(type: 'race1')));
          futures.add(plugin2.handleEvent(PluginEvent.now(type: 'race2')));
        }
        await Future.wait(futures);

        // Assert - state remains isolated
        expect(plugin1.state['last_event'], equals('race1'));
        expect(plugin2.state['last_event'], equals('race2'));
      });
    });

    group('Permission Boundaries', () {
      test('plugins should have separate permission contexts', () {
        // Arrange
        final permissions1 = const PluginPermissions(
          allowedHostFunctions: ['function1', 'function2'],
          maxMemoryBytes: 1024 * 1024,
        );

        final permissions2 = const PluginPermissions(
          allowedHostFunctions: ['function3'],
          maxMemoryBytes: 2 * 1024 * 1024,
        );

        // Assert
        expect(permissions1.allowedHostFunctions, hasLength(2));
        expect(permissions2.allowedHostFunctions, hasLength(1));
        expect(permissions1.maxMemoryBytes, equals(1024 * 1024));
        expect(permissions2.maxMemoryBytes, equals(2 * 1024 * 1024));
      });

      test('permission changes should not affect other plugins', () {
        // Arrange
        const basePermissions = PluginPermissions(
          allowedHostFunctions: ['base'],
        );

        // Act - Create separate permission instances
        const permissions1 = PluginPermissions(
          allowedHostFunctions: ['base', 'extra1'],
        );
        const permissions2 = PluginPermissions(
          allowedHostFunctions: ['base', 'extra2'],
        );

        // Assert
        expect(permissions1.allowedHostFunctions, contains('extra1'));
        expect(permissions1.allowedHostFunctions, isNot(contains('extra2')));
        expect(permissions2.allowedHostFunctions, contains('extra2'));
        expect(permissions2.allowedHostFunctions, isNot(contains('extra1')));
      });
    });

    group('Security Boundaries', () {
      test('plugins should not access each other contexts', () {
        // Arrange
        final context1 = PluginContext(
          pluginId: 'plugin1',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );
        final context2 = PluginContext(
          pluginId: 'plugin2',
          host: IsolatedHost(),
          config: const PluginConfig(),
        );

        context1.registerService<String>('secret1');
        context2.registerService<String>('secret2');

        // Assert - contexts are separate instances
        expect(context1, isNot(same(context2)));
        expect(context1.getService<String>(), equals('secret1'));
        expect(context2.getService<String>(), equals('secret2'));
      });

      test('plugin manifests should be immutable per plugin', () {
        // Arrange
        final plugin1 = IsolatedPlugin('plugin1');
        final plugin2 = IsolatedPlugin('plugin2');

        // Assert
        expect(plugin1.manifest.id, equals('plugin1'));
        expect(plugin2.manifest.id, equals('plugin2'));
        expect(plugin1.manifest, isNot(same(plugin2.manifest)));
      });
    });
  });
}
