import 'dart:typed_data';
import 'package:flutter_plugin_system_wasm/flutter_plugin_system_wasm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock WASM module
class MockWasmModule extends Mock implements IWasmModule {}

/// Mock WASM instance
class MockWasmInstance extends Mock implements IWasmInstance {}

/// Mock WASM memory
class MockWasmMemory extends Mock implements IWasmMemory {}

/// Test WASM runtime
class TestWasmRuntime implements IWasmRuntime {
  bool shouldFailLoad = false;
  bool shouldFailInstantiate = false;
  final List<Uint8List> loadedModules = [];

  @override
  String get name => 'TestWasmRuntime';

  @override
  String get version => '1.0.0-test';

  @override
  WasmFeatures get supportedFeatures => const WasmFeatures(
    supportsWasi: false,
    supportsMultiValue: true,
    supportsBulkMemory: true,
  );

  @override
  WasmRuntimeConfig get config => const WasmRuntimeConfig();

  @override
  Future<IWasmModule> loadModule(Uint8List wasmBytes) async {
    if (shouldFailLoad) {
      throw const WasmCompilationException('Mock compilation error');
    }
    loadedModules.add(wasmBytes);
    final module = MockWasmModule();
    when(() => module.exports).thenReturn(['test_function']);
    when(() => module.imports).thenReturn(['env.log']);
    return module;
  }

  @override
  Future<IWasmModule> loadModuleFromFile(String path) async {
    final bytes = Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]); // WASM magic number
    return loadModule(bytes);
  }

  @override
  Future<IWasmInstance> instantiate(
    IWasmModule module,
    Map<String, Map<String, WasmImport>> imports,
  ) async {
    if (shouldFailInstantiate) {
      throw const WasmInstantiationException('Mock instantiation error');
    }

    final instance = MockWasmInstance();
    final memory = MockWasmMemory();

    when(() => memory.size).thenReturn(65536);
    when(() => memory.sizeInPages).thenReturn(1);
    when(() => memory.read(any(), any())).thenAnswer(
      (_) async => Uint8List(10),
    );
    when(() => memory.write(any(), any())).thenAnswer((_) async => {});

    when(() => instance.memory).thenReturn(memory);
    when(() => instance.getFunction(any())).thenReturn(
      (List args) async => 0,
    );

    return instance;
  }

  @override
  Future<WasmModuleValidation> validateBytes(Uint8List wasmBytes) async {
    if (wasmBytes.length < 4) {
      return const WasmModuleValidation(
        isValid: false,
        errors: ['Invalid WASM magic number'],
      );
    }
    return const WasmModuleValidation(isValid: true);
  }

  @override
  Map<String, dynamic> getStatistics() => {
    'modules_loaded': loadedModules.length,
    'instances_active': 0,
    'total_memory_bytes': 0,
  };

  @override
  Future<void> dispose() async {
    loadedModules.clear();
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('WASM Runtime', () {
    late TestWasmRuntime runtime;

    setUp(() {
      runtime = TestWasmRuntime();
    });

    tearDown(() async {
      await runtime.dispose();
    });

    group('Runtime Info', () {
      test('should provide runtime name and version', () {
        // Assert
        expect(runtime.name, equals('TestWasmRuntime'));
        expect(runtime.version, equals('1.0.0-test'));
      });

      test('should provide supported features', () {
        // Act
        final features = runtime.supportedFeatures;

        // Assert
        expect(features.supportsMultiValue, isTrue);
        expect(features.supportsBulkMemory, isTrue);
        expect(features.supportsWasi, isFalse);
      });

      test('should provide runtime configuration', () {
        // Act
        final config = runtime.config;

        // Assert
        expect(config, isNotNull);
        expect(config.enableOptimization, isTrue);
      });
    });

    group('Module Loading', () {
      test('should load WASM module from bytes', () async {
        // Arrange
        final wasmBytes = Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]);

        // Act
        final module = await runtime.loadModule(wasmBytes);

        // Assert
        expect(module, isNotNull);
        expect(runtime.loadedModules, hasLength(1));
      });

      test('should load WASM module from file', () async {
        // Act
        final module = await runtime.loadModuleFromFile('/test/module.wasm');

        // Assert
        expect(module, isNotNull);
        expect(runtime.loadedModules, hasLength(1));
      });

      test('should throw WasmCompilationException on invalid module', () async {
        // Arrange
        runtime.shouldFailLoad = true;
        final bytes = Uint8List(10);

        // Act & Assert
        expect(
          () => runtime.loadModule(bytes),
          throwsA(isA<WasmCompilationException>()),
        );
      });

      test('should validate WASM bytes before loading', () async {
        // Arrange
        final validBytes = Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]);
        final invalidBytes = Uint8List.fromList([0x00, 0x00]);

        // Act
        final validResult = await runtime.validateBytes(validBytes);
        final invalidResult = await runtime.validateBytes(invalidBytes);

        // Assert
        expect(validResult.isValid, isTrue);
        expect(invalidResult.isValid, isFalse);
        expect(invalidResult.errors, isNotEmpty);
      });
    });

    group('Module Instantiation', () {
      test('should instantiate module with imports', () async {
        // Arrange
        final module = await runtime.loadModule(Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]));
        final imports = <String, Map<String, WasmImport>>{
          'env': {
            'log': WasmImport.function((args) async => null),
          },
        };

        // Act
        final instance = await runtime.instantiate(module, imports);

        // Assert
        expect(instance, isNotNull);
        expect(instance.memory, isNotNull);
      });

      test('should throw WasmInstantiationException on failure', () async {
        // Arrange
        runtime.shouldFailInstantiate = true;
        final module = await runtime.loadModule(Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]));

        // Act & Assert
        expect(
          () => runtime.instantiate(module, {}),
          throwsA(isA<WasmInstantiationException>()),
        );
      });

      test('should instantiate with empty imports', () async {
        // Arrange
        final module = await runtime.loadModule(Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]));

        // Act
        final instance = await runtime.instantiate(module, {});

        // Assert
        expect(instance, isNotNull);
      });
    });

    group('Statistics', () {
      test('should track loaded modules', () async {
        // Act
        await runtime.loadModule(Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]));
        await runtime.loadModule(Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]));

        final stats = runtime.getStatistics();

        // Assert
        expect(stats['modules_loaded'], equals(2));
      });

      test('should provide comprehensive statistics', () {
        // Act
        final stats = runtime.getStatistics();

        // Assert
        expect(stats.containsKey('modules_loaded'), isTrue);
        expect(stats.containsKey('instances_active'), isTrue);
        expect(stats.containsKey('total_memory_bytes'), isTrue);
      });
    });

    group('Resource Management', () {
      test('should dispose runtime cleanly', () async {
        // Arrange
        await runtime.loadModule(Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]));

        // Act
        await runtime.dispose();

        // Assert
        expect(runtime.loadedModules, isEmpty);
      });

      test('should handle multiple dispose calls', () async {
        // Act & Assert - should not throw
        await runtime.dispose();
        await runtime.dispose();
      });
    });

    group('Configuration', () {
      test('should support custom runtime config', () {
        // Arrange
        const config = WasmRuntimeConfig(
          enableOptimization: false,
          maxMemoryPages: 100,
          maxStackDepth: 50,
          fuelLimit: 1000000,
        );

        // Assert
        expect(config.enableOptimization, isFalse);
        expect(config.maxMemoryPages, equals(100));
        expect(config.maxStackDepth, equals(50));
        expect(config.fuelLimit, equals(1000000));
      });

      test('should support WASI configuration', () {
        // Arrange
        const config = WasmRuntimeConfig(enableWasi: true);

        // Assert
        expect(config.enableWasi, isTrue);
      });

      test('should support custom configuration options', () {
        // Arrange
        const config = WasmRuntimeConfig(
          custom: {'custom_option': 'value'},
        );

        // Assert
        expect(config.custom['custom_option'], equals('value'));
      });
    });

    group('Features', () {
      test('should check for WASI support', () {
        // Arrange
        const features = WasmFeatures(supportsWasi: true);

        // Assert
        expect(features.supportsWasi, isTrue);
      });

      test('should check for multi-value support', () {
        // Arrange
        const features = WasmFeatures(supportsMultiValue: true);

        // Assert
        expect(features.supportsMultiValue, isTrue);
      });

      test('should check for bulk memory support', () {
        // Arrange
        const features = WasmFeatures(supportsBulkMemory: true);

        // Assert
        expect(features.supportsBulkMemory, isTrue);
      });

      test('should check for SIMD support', () {
        // Arrange
        const features = WasmFeatures(supportsSimd: true);

        // Assert
        expect(features.supportsSimd, isTrue);
      });

      test('should support custom features', () {
        // Arrange
        const features = WasmFeatures(
          customFeatures: {'custom_feature': true},
        );

        // Assert
        expect(features.customFeatures['custom_feature'], isTrue);
      });
    });

    group('Concurrent Operations', () {
      test('should load multiple modules concurrently', () async {
        // Arrange
        final bytes = List.generate(
          5,
          (_) => Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]),
        );

        // Act
        await Future.wait(
          bytes.map((b) => runtime.loadModule(b)),
        );

        // Assert
        expect(runtime.loadedModules, hasLength(5));
      });

      test('should handle concurrent instantiations', () async {
        // Arrange
        final module = await runtime.loadModule(
          Uint8List.fromList([0x00, 0x61, 0x73, 0x6d]),
        );

        // Act
        final instances = await Future.wait(
          List.generate(
            3,
            (_) => runtime.instantiate(module, {}),
          ),
        );

        // Assert
        expect(instances, hasLength(3));
      });
    });

    group('Error Handling', () {
      test('should provide detailed compilation errors', () {
        // Arrange
        const exception = WasmCompilationException(
          'Compilation failed',
          errors: ['Error 1', 'Error 2'],
        );

        // Assert
        expect(exception.message, equals('Compilation failed'));
        expect(exception.errors, hasLength(2));
        expect(exception.toString(), contains('Error 1'));
      });

      test('should provide detailed instantiation errors', () {
        // Arrange
        const exception = WasmInstantiationException(
          'Instantiation failed',
          missingImports: ['env.log', 'env.memory'],
        );

        // Assert
        expect(exception.message, equals('Instantiation failed'));
        expect(exception.missingImports, hasLength(2));
        expect(exception.toString(), contains('env.log'));
      });
    });
  });

  group('Module Validation', () {
    test('should validate valid WASM module', () {
      // Arrange
      const validation = WasmModuleValidation(isValid: true);

      // Assert
      expect(validation.isValid, isTrue);
      expect(validation.errors, isNull);
    });

    test('should validate invalid WASM module with errors', () {
      // Arrange
      const validation = WasmModuleValidation(
        isValid: false,
        errors: ['Invalid magic number', 'Missing export'],
      );

      // Assert
      expect(validation.isValid, isFalse);
      expect(validation.errors, hasLength(2));
    });
  });

  group('WASM Imports', () {
    test('should create function import', () {
      // Arrange
      final import = WasmImport.function((args) async => 'result');

      // Assert
      expect(import, isNotNull);
    });

    test('should create memory import', () {
      // Arrange
      final memory = MockWasmMemory();
      final import = WasmImport.memory(memory);

      // Assert
      expect(import, isNotNull);
    });

    test('should create global import', () {
      // Arrange
      final import = WasmImport.global(42);

      // Assert
      expect(import, isNotNull);
    });

    test('should create table import', () {
      // Arrange
      final import = WasmImport.table(10);

      // Assert
      expect(import, isNotNull);
    });
  });
}
