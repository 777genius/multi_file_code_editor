import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:test/test.dart';

/// Mock plugin runtime for testing
class MockPluginRuntime implements IPluginRuntime {
  final List<String> loadedPlugins = [];
  final List<String> unloadedPlugins = [];
  bool shouldFailLoad = false;
  bool shouldFailCompatibility = false;

  @override
  PluginRuntimeType get type => PluginRuntimeType.wasm;

  @override
  Future<IPlugin> loadPlugin({
    required String pluginId,
    required PluginSource source,
    PluginConfig? config,
  }) async {
    if (shouldFailLoad) {
      throw PluginLoadException(
        'Mock load failure',
        pluginId: pluginId,
      );
    }

    loadedPlugins.add(pluginId);
    return MockPlugin(pluginId: pluginId);
  }

  @override
  Future<void> unloadPlugin(String pluginId) async {
    unloadedPlugins.add(pluginId);
  }

  @override
  bool isCompatible(PluginManifest manifest) {
    if (shouldFailCompatibility) return false;
    return manifest.runtime == PluginRuntimeType.wasm;
  }

  @override
  bool get supportsHotReload => false;

  @override
  Future<void> hotReload(String pluginId) async {
    throw UnsupportedError('Hot reload not supported');
  }

  @override
  Map<String, dynamic> getRuntimeInfo() => {
    'type': type.toString(),
    'supportsHotReload': supportsHotReload,
    'loaded_plugins': loadedPlugins.length,
  };
}

/// Mock plugin for testing
class MockPlugin implements IPlugin {
  final String pluginId;
  bool isInitialized = false;
  bool isDisposed = false;
  final List<PluginEvent> receivedEvents = [];

  MockPlugin({required this.pluginId});

  @override
  PluginManifest get manifest => PluginManifest(
    id: pluginId,
    name: 'Mock Plugin',
    version: '1.0.0',
    description: 'Test plugin',
    runtime: PluginRuntimeType.wasm,
  );

  @override
  Future<void> initialize(PluginContext context) async {
    isInitialized = true;
  }

  @override
  Future<PluginResponse> handleEvent(PluginEvent event) async {
    receivedEvents.add(event);
    return PluginResponse.success(data: {'handled': true});
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
  }
}

void main() {
  group('IPluginRuntime', () {
    late MockPluginRuntime runtime;

    setUp(() {
      runtime = MockPluginRuntime();
    });

    group('Plugin Loading', () {
      test('should load plugin from file source', () async {
        // Arrange
        const pluginId = 'test.plugin';
        final source = PluginSource.file(path: '/path/to/plugin.wasm');

        // Act
        final plugin = await runtime.loadPlugin(
          pluginId: pluginId,
          source: source,
        );

        // Assert
        expect(plugin, isNotNull);
        expect(plugin.manifest.id, equals(pluginId));
        expect(runtime.loadedPlugins, contains(pluginId));
      });

      test('should load plugin from memory source', () async {
        // Arrange
        const pluginId = 'test.memory.plugin';
        final bytes = [1, 2, 3, 4];
        final source = PluginSource.memory(bytes: bytes);

        // Act
        final plugin = await runtime.loadPlugin(
          pluginId: pluginId,
          source: source,
        );

        // Assert
        expect(plugin, isNotNull);
        expect(runtime.loadedPlugins, contains(pluginId));
      });

      test('should load plugin with config', () async {
        // Arrange
        const pluginId = 'test.config.plugin';
        final source = PluginSource.file(path: '/path/to/plugin.wasm');
        const config = PluginConfig(
          settings: {'theme': 'dark'},
          enabled: true,
        );

        // Act
        final plugin = await runtime.loadPlugin(
          pluginId: pluginId,
          source: source,
          config: config,
        );

        // Assert
        expect(plugin, isNotNull);
        expect(runtime.loadedPlugins, contains(pluginId));
      });

      test('should throw PluginLoadException on load failure', () async {
        // Arrange
        runtime.shouldFailLoad = true;
        const pluginId = 'test.failing.plugin';
        final source = PluginSource.file(path: '/path/to/plugin.wasm');

        // Act & Assert
        expect(
          () => runtime.loadPlugin(pluginId: pluginId, source: source),
          throwsA(isA<PluginLoadException>()),
        );
      });
    });

    group('Plugin Unloading', () {
      test('should unload plugin successfully', () async {
        // Arrange
        const pluginId = 'test.unload.plugin';
        final source = PluginSource.file(path: '/path/to/plugin.wasm');
        await runtime.loadPlugin(pluginId: pluginId, source: source);

        // Act
        await runtime.unloadPlugin(pluginId);

        // Assert
        expect(runtime.unloadedPlugins, contains(pluginId));
      });

      test('should handle unloading non-existent plugin', () async {
        // Arrange
        const pluginId = 'non.existent.plugin';

        // Act
        await runtime.unloadPlugin(pluginId);

        // Assert
        expect(runtime.unloadedPlugins, contains(pluginId));
      });
    });

    group('Compatibility Checking', () {
      test('should return true for compatible manifest', () {
        // Arrange
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        // Act
        final isCompatible = runtime.isCompatible(manifest);

        // Assert
        expect(isCompatible, isTrue);
      });

      test('should return false for incompatible manifest', () {
        // Arrange
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.native,
        );

        // Act
        final isCompatible = runtime.isCompatible(manifest);

        // Assert
        expect(isCompatible, isFalse);
      });

      test('should handle compatibility check failure', () {
        // Arrange
        runtime.shouldFailCompatibility = true;
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        // Act
        final isCompatible = runtime.isCompatible(manifest);

        // Assert
        expect(isCompatible, isFalse);
      });
    });

    group('Hot Reload', () {
      test('should not support hot reload by default', () {
        // Assert
        expect(runtime.supportsHotReload, isFalse);
      });

      test('should throw UnsupportedError on hot reload attempt', () {
        // Act & Assert
        expect(
          () => runtime.hotReload('test.plugin'),
          throwsUnsupportedError,
        );
      });
    });

    group('Runtime Info', () {
      test('should return runtime information', () {
        // Act
        final info = runtime.getRuntimeInfo();

        // Assert
        expect(info, isA<Map<String, dynamic>>());
        expect(info['type'], equals(PluginRuntimeType.wasm.toString()));
        expect(info['supportsHotReload'], isFalse);
        expect(info.containsKey('loaded_plugins'), isTrue);
      });

      test('should include loaded plugins count', () async {
        // Arrange
        await runtime.loadPlugin(
          pluginId: 'plugin1',
          source: PluginSource.file(path: '/path/1.wasm'),
        );
        await runtime.loadPlugin(
          pluginId: 'plugin2',
          source: PluginSource.file(path: '/path/2.wasm'),
        );

        // Act
        final info = runtime.getRuntimeInfo();

        // Assert
        expect(info['loaded_plugins'], equals(2));
      });
    });

    group('Runtime Type', () {
      test('should return correct runtime type', () {
        // Assert
        expect(runtime.type, equals(PluginRuntimeType.wasm));
      });
    });

    group('Multiple Plugin Loading', () {
      test('should load multiple plugins concurrently', () async {
        // Arrange
        final sources = List.generate(
          5,
          (i) => PluginSource.file(path: '/path/plugin$i.wasm'),
        );

        // Act
        final plugins = await Future.wait(
          sources.asMap().entries.map(
            (entry) => runtime.loadPlugin(
              pluginId: 'plugin${entry.key}',
              source: entry.value,
            ),
          ),
        );

        // Assert
        expect(plugins.length, equals(5));
        expect(runtime.loadedPlugins.length, equals(5));
      });
    });
  });

  group('Plugin Isolation', () {
    test('plugins should have separate contexts', () async {
      // Arrange
      final runtime = MockPluginRuntime();
      final source = PluginSource.file(path: '/path/to/plugin.wasm');

      // Act
      final plugin1 = await runtime.loadPlugin(
        pluginId: 'plugin1',
        source: source,
      );
      final plugin2 = await runtime.loadPlugin(
        pluginId: 'plugin2',
        source: source,
      );

      // Assert
      expect(plugin1.manifest.id, isNot(equals(plugin2.manifest.id)));
      expect(plugin1, isNot(same(plugin2)));
    });

    test('plugin errors should not affect other plugins', () async {
      // Arrange
      final runtime = MockPluginRuntime();
      final source = PluginSource.file(path: '/path/to/plugin.wasm');

      await runtime.loadPlugin(pluginId: 'plugin1', source: source);

      // Act - second load fails
      runtime.shouldFailLoad = true;
      try {
        await runtime.loadPlugin(pluginId: 'plugin2', source: source);
      } catch (_) {
        // Expected failure
      }

      // Assert - first plugin still loaded
      expect(runtime.loadedPlugins, contains('plugin1'));
      expect(runtime.loadedPlugins.length, equals(1));
    });
  });
}
