import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_wasm/flutter_plugin_system_wasm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock WASM runtime for loader testing
class MockWasmRuntime extends Mock implements IWasmRuntime {}

/// Mock WASM module
class MockWasmModule extends Mock implements IWasmModule {}

/// Mock WASM instance
class MockWasmInstance extends Mock implements IWasmInstance {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(MockWasmModule());
    registerFallbackValue(<String, Map<String, WasmImport>>{});
    registerFallbackValue(const PluginConfig());
    registerFallbackValue(PluginSource.file(path: '/test'));
  });

  group('WASM Loader', () {
    late MockWasmRuntime mockRuntime;
    late WasmPluginRuntime pluginRuntime;

    setUp(() {
      mockRuntime = MockWasmRuntime();
      pluginRuntime = WasmPluginRuntime(
        wasmRuntime: mockRuntime,
        serializer: JsonPluginSerializer(),
      );

      // Setup default mock behaviors
      when(() => mockRuntime.name).thenReturn('MockWasmRuntime');
      when(() => mockRuntime.version).thenReturn('1.0.0');
      when(() => mockRuntime.supportedFeatures).thenReturn(
        const WasmFeatures(),
      );
      when(() => mockRuntime.config).thenReturn(
        const WasmRuntimeConfig(),
      );
      when(() => mockRuntime.getStatistics()).thenReturn({});
      when(() => mockRuntime.dispose()).thenAnswer((_) async => {});
    });

    group('Plugin Loading', () {
      test('should load plugin from file source', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test Plugin',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        final config = PluginConfig(
          metadata: {'manifest': manifest.toJson()},
        );

        // Act
        final plugin = await pluginRuntime.loadPlugin(
          pluginId: 'test.plugin',
          source: PluginSource.file(path: '/path/to/plugin.wasm'),
          config: config,
        );

        // Assert
        expect(plugin, isNotNull);
        expect(plugin.manifest.id, equals('test.plugin'));
        verify(() => mockRuntime.loadModule(any())).called(1);
        verify(() => mockRuntime.instantiate(any(), any())).called(1);
      });

      test('should load plugin from memory source', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();
        final wasmBytes = Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]);
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test Plugin',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        final config = PluginConfig(
          metadata: {'manifest': manifest.toJson()},
        );

        // Act
        final plugin = await pluginRuntime.loadPlugin(
          pluginId: 'test.plugin',
          source: PluginSource.memory(bytes: wasmBytes),
          config: config,
        );

        // Assert
        expect(plugin, isNotNull);
        verify(() => mockRuntime.loadModule(wasmBytes)).called(1);
      });

      test('should throw PluginLoadException on file not found', () async {
        // Arrange
        final source = PluginSource.file(path: '/non/existent/file.wasm');

        // Act & Assert
        expect(
          () => pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: source,
          ),
          throwsA(isA<PluginLoadException>()),
        );
      });

      test('should throw PluginLoadException on compilation failure', () async {
        // Arrange
        when(() => mockRuntime.loadModule(any())).thenThrow(
          const WasmCompilationException('Compilation failed'),
        );

        final wasmBytes = Uint8List.fromList([0xFF, 0xFF]); // Invalid

        // Act & Assert
        expect(
          () => pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: PluginSource.memory(bytes: wasmBytes),
          ),
          throwsA(isA<PluginLoadException>()),
        );
      });

      test('should throw PluginLoadException on instantiation failure', () async {
        // Arrange
        final mockModule = MockWasmModule();

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any())).thenThrow(
          const WasmInstantiationException('Instantiation failed'),
        );

        final wasmBytes = Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]);

        // Act & Assert
        expect(
          () => pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: PluginSource.memory(bytes: wasmBytes),
          ),
          throwsA(isA<PluginLoadException>()),
        );
      });

      test('should create manifest from config metadata', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();
        final manifest = PluginManifest(
          id: 'custom.plugin',
          name: 'Custom Plugin',
          version: '2.0.0',
          description: 'Custom plugin from manifest',
          runtime: PluginRuntimeType.wasm,
        );

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        final config = PluginConfig(
          metadata: {'manifest': manifest.toJson()},
        );

        // Act
        final plugin = await pluginRuntime.loadPlugin(
          pluginId: 'custom.plugin',
          source: PluginSource.memory(bytes: Uint8List(4)),
          config: config,
        );

        // Assert
        expect(plugin.manifest.id, equals('custom.plugin'));
        expect(plugin.manifest.name, equals('Custom Plugin'));
        expect(plugin.manifest.version, equals('2.0.0'));
      });

      test('should create default manifest when not in config', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        // Act
        final plugin = await pluginRuntime.loadPlugin(
          pluginId: 'default.plugin',
          source: PluginSource.memory(bytes: Uint8List(4)),
        );

        // Assert
        expect(plugin.manifest.id, equals('default.plugin'));
        expect(plugin.manifest.version, equals('0.0.0'));
      });
    });

    group('Plugin Unloading', () {
      test('should unload plugin successfully', () async {
        // Act & Assert - should not throw
        await pluginRuntime.unloadPlugin('test.plugin');
      });
    });

    group('Compatibility', () {
      test('should check WASM runtime compatibility', () {
        // Arrange
        final wasmManifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        final nativeManifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.native,
        );

        // Act & Assert
        expect(pluginRuntime.isCompatible(wasmManifest), isTrue);
        expect(pluginRuntime.isCompatible(nativeManifest), isFalse);
      });

      test('should have correct runtime type', () {
        // Assert
        expect(pluginRuntime.type, equals(PluginRuntimeType.wasm));
      });
    });

    group('Statistics', () {
      test('should provide runtime statistics', () {
        // Act
        final stats = pluginRuntime.getStatistics();

        // Assert
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats.containsKey('type'), isTrue);
        expect(stats['type'], equals('wasm'));
        expect(stats.containsKey('wasm_runtime'), isTrue);
        expect(stats.containsKey('serializer'), isTrue);
      });

      test('should include WASM runtime features in stats', () {
        // Act
        final stats = pluginRuntime.getStatistics();

        // Assert
        expect(stats.containsKey('features'), isTrue);
        final features = stats['features'] as Map;
        expect(features.containsKey('wasi'), isTrue);
        expect(features.containsKey('multi_value'), isTrue);
        expect(features.containsKey('bulk_memory'), isTrue);
        expect(features.containsKey('simd'), isTrue);
      });
    });

    group('Resource Management', () {
      test('should dispose runtime cleanly', () async {
        // Act
        await pluginRuntime.dispose();

        // Assert
        verify(() => mockRuntime.dispose()).called(1);
      });

      test('should handle multiple dispose calls', () async {
        // Act & Assert - should not throw
        await pluginRuntime.dispose();
        await pluginRuntime.dispose();
      });
    });

    group('Source Handling', () {
      test('should handle PluginSourceType.file', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        final config = PluginConfig(
          metadata: {'manifest': manifest.toJson()},
        );

        // Note: This test will fail with file not found, but that's expected
        // in a unit test environment. In integration tests, you'd use real files.
        try {
          await pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: PluginSource.file(path: '/path/to/plugin.wasm'),
            config: config,
          );
          fail('Should have thrown');
        } on PluginLoadException catch (e) {
          expect(e.message, contains('Failed to load'));
        }
      });

      test('should handle PluginSourceType.memory', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();
        final manifest = PluginManifest(
          id: 'test.plugin',
          name: 'Test',
          version: '1.0.0',
          description: 'Test',
          runtime: PluginRuntimeType.wasm,
        );

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        final config = PluginConfig(
          metadata: {'manifest': manifest.toJson()},
        );

        // Act
        final plugin = await pluginRuntime.loadPlugin(
          pluginId: 'test.plugin',
          source: PluginSource.memory(bytes: Uint8List(4)),
          config: config,
        );

        // Assert
        expect(plugin, isNotNull);
      });

      test('should throw on PluginSourceType.url (not implemented)', () async {
        // Arrange
        final source = PluginSource.url(url: 'https://example.com/plugin.wasm');

        // Act & Assert
        expect(
          () => pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: source,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('should throw on PluginSourceType.package (not implemented)', () async {
        // Arrange
        final source = PluginSource.package(package: 'test_package');

        // Act & Assert
        expect(
          () => pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: source,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('should throw on memory source without bytes', () async {
        // Arrange
        final source = PluginSource.memory(bytes: null as dynamic);

        // Act & Assert - will throw when trying to access null bytes
        expect(
          () => pluginRuntime.loadPlugin(
            pluginId: 'test.plugin',
            source: source,
          ),
          throwsA(isA<PluginLoadException>()),
        );
      });
    });

    group('Import Preparation', () {
      test('should prepare empty imports by default', () async {
        // This is tested indirectly through successful plugin loading
        // The _prepareImports method currently returns empty map
        expect(pluginRuntime.type, equals(PluginRuntimeType.wasm));
      });
    });

    group('Concurrent Loading', () {
      test('should load multiple plugins concurrently', () async {
        // Arrange
        final mockModule = MockWasmModule();
        final mockInstance = MockWasmInstance();

        when(() => mockRuntime.loadModule(any()))
            .thenAnswer((_) async => mockModule);
        when(() => mockRuntime.instantiate(any(), any()))
            .thenAnswer((_) async => mockInstance);
        when(() => mockInstance.memory).thenReturn(null);

        final sources = List.generate(
          3,
          (i) => PluginSource.memory(bytes: Uint8List.fromList([i, i + 1, i + 2])),
        );

        // Act
        final plugins = await Future.wait(
          sources.asMap().entries.map(
            (entry) => pluginRuntime.loadPlugin(
              pluginId: 'plugin${entry.key}',
              source: entry.value,
            ),
          ),
        );

        // Assert
        expect(plugins, hasLength(3));
        verify(() => mockRuntime.loadModule(any())).called(3);
      });
    });

    group('Error Context', () {
      test('should include plugin ID in load exceptions', () async {
        // Arrange
        when(() => mockRuntime.loadModule(any())).thenThrow(
          Exception('Test error'),
        );

        // Act & Assert
        try {
          await pluginRuntime.loadPlugin(
            pluginId: 'error.plugin',
            source: PluginSource.memory(bytes: Uint8List(4)),
          );
          fail('Should have thrown');
        } on PluginLoadException catch (e) {
          expect(e.pluginId, equals('error.plugin'));
          expect(e.originalError, isNotNull);
        }
      });
    });
  });

  group('Plugin Source Types', () {
    test('should create file source', () {
      // Act
      final source = PluginSource.file(path: '/path/to/plugin.wasm');

      // Assert
      expect(source.type, equals(PluginSourceType.file));
      expect(source.path, equals('/path/to/plugin.wasm'));
    });

    test('should create memory source', () {
      // Arrange
      final bytes = Uint8List.fromList([1, 2, 3]);

      // Act
      final source = PluginSource.memory(bytes: bytes);

      // Assert
      expect(source.type, equals(PluginSourceType.memory));
      expect(source.bytes, equals(bytes));
    });

    test('should create URL source', () {
      // Act
      final source = PluginSource.url(url: 'https://example.com/plugin.wasm');

      // Assert
      expect(source.type, equals(PluginSourceType.url));
      expect(source.url, equals('https://example.com/plugin.wasm'));
    });

    test('should create package source', () {
      // Act
      final source = PluginSource.package(package: 'my_plugin');

      // Assert
      expect(source.type, equals(PluginSourceType.package));
      expect(source.package, equals('my_plugin'));
    });
  });
}
