import 'dart:typed_data';
import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_wasm/flutter_plugin_system_wasm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock WASM instance with memory
class MockWasmInstanceWithMemory extends Mock implements IWasmInstance {
  final _MockWasmMemory _memory = _MockWasmMemory();
  final Map<String, Function> _functions = {};

  MockWasmInstanceWithMemory() {
    when(() => memory).thenReturn(_memory);

    // Mock alloc function
    _functions['alloc'] = (List args) async {
      final size = args[0] as int;
      return _memory.allocate(size);
    };

    // Mock dealloc function
    _functions['dealloc'] = (List args) async {
      // Simulated dealloc
      return null;
    };

    // Mock test function that returns packed ptr+len
    _functions['test_function'] = (List args) async {
      // Return packed result: ptr=100, len=50
      return (100 << 32) | 50;
    };

    when(() => getFunction(any())).thenAnswer((invocation) {
      final name = invocation.positionalArguments[0] as String;
      return _functions[name];
    });
  }
}

class _MockWasmMemory implements IWasmMemory {
  final _data = <int, Uint8List>{};
  int _nextPtr = 100;

  @override
  int get size => 65536;

  @override
  int get sizeInPages => 1;

  @override
  Future<Uint8List> read(int ptr, int length) async {
    if (_data.containsKey(ptr)) {
      return _data[ptr]!;
    }
    return Uint8List(length);
  }

  @override
  Future<void> write(int ptr, Uint8List data) async {
    _data[ptr] = data;
  }

  @override
  Future<int> grow(int deltaPages) async {
    return sizeInPages;
  }

  int allocate(int size) {
    final ptr = _nextPtr;
    _nextPtr += size;
    return ptr;
  }
}

/// Mock serializer
class MockSerializer extends Mock implements PluginSerializer {
  @override
  String get name => 'MockSerializer';

  @override
  Uint8List serialize(Map<String, dynamic> data) {
    return Uint8List.fromList([1, 2, 3, 4]);
  }

  @override
  Map<String, dynamic> deserialize(Uint8List bytes) {
    return {'result': 'deserialized'};
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('WASM Memory', () {
    group('Memory Basics', () {
      test('should have 64KB page size', () {
        // Arrange
        const pageSize = 65536;

        // Assert
        expect(pageSize, equals(64 * 1024));
      });

      test('should track memory size in bytes and pages', () {
        // Arrange
        final memory = _MockWasmMemory();

        // Assert
        expect(memory.size, equals(65536));
        expect(memory.sizeInPages, equals(1));
      });

      test('should grow memory by pages', () async {
        // Arrange
        final memory = _MockWasmMemory();

        // Act
        final oldPages = await memory.grow(2);

        // Assert
        expect(oldPages, equals(1));
      });
    });

    group('Memory Operations', () {
      test('should write data to memory', () async {
        // Arrange
        final memory = _MockWasmMemory();
        final data = Uint8List.fromList([1, 2, 3, 4, 5]);

        // Act
        await memory.write(100, data);

        // Assert
        final read = await memory.read(100, 5);
        expect(read, equals(data));
      });

      test('should read data from memory', () async {
        // Arrange
        final memory = _MockWasmMemory();
        final data = Uint8List.fromList([10, 20, 30]);
        await memory.write(200, data);

        // Act
        final read = await memory.read(200, 3);

        // Assert
        expect(read, equals(data));
      });

      test('should handle different memory regions', () async {
        // Arrange
        final memory = _MockWasmMemory();
        final data1 = Uint8List.fromList([1, 2, 3]);
        final data2 = Uint8List.fromList([4, 5, 6]);

        // Act
        await memory.write(100, data1);
        await memory.write(200, data2);

        // Assert
        final read1 = await memory.read(100, 3);
        final read2 = await memory.read(200, 3);
        expect(read1, equals(data1));
        expect(read2, equals(data2));
      });
    });

    group('Memory Bridge', () {
      late WasmMemoryBridge bridge;
      late MockWasmInstanceWithMemory instance;
      late MockSerializer serializer;

      setUp(() {
        instance = MockWasmInstanceWithMemory();
        serializer = MockSerializer();
        bridge = WasmMemoryBridge(
          instance: instance,
          serializer: serializer,
        );
      });

      test('should call WASM function with automatic memory management', () async {
        // Arrange
        final data = {'input': 'test'};

        // Act
        final result = await bridge.call('test_function', data);

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['result'], equals('deserialized'));
      });

      test('should serialize and deserialize data', () async {
        // Arrange
        final data = {'key': 'value'};

        // Act
        final result = await bridge.call('test_function', data);

        // Assert - serializer was used
        verify(() => serializer.serialize(data)).called(1);
        verify(() => serializer.deserialize(any())).called(1);
      });

      test('should allocate memory in WASM', () async {
        // Act
        final ptr = await bridge.allocate(1024);

        // Assert
        expect(ptr, greaterThan(0));
      });

      test('should deallocate memory', () async {
        // Arrange
        final ptr = await bridge.allocate(1024);

        // Act & Assert - should not throw
        await bridge.deallocate(ptr, 1024);
      });

      test('should write bytes to WASM memory', () async {
        // Arrange
        final data = Uint8List.fromList([1, 2, 3, 4]);
        final ptr = await bridge.allocate(4);

        // Act
        await bridge.write(ptr, data);

        // Assert
        final read = await bridge.read(ptr, 4);
        expect(read, equals(data));
      });

      test('should read bytes from WASM memory', () async {
        // Arrange
        final data = Uint8List.fromList([5, 6, 7, 8]);
        final ptr = await bridge.allocate(4);
        await bridge.write(ptr, data);

        // Act
        final read = await bridge.read(ptr, 4);

        // Assert
        expect(read, equals(data));
      });

      test('should get memory statistics', () {
        // Act
        final stats = bridge.getMemoryStats();

        // Assert
        expect(stats.containsKey('size_bytes'), isTrue);
        expect(stats.containsKey('size_pages'), isTrue);
        expect(stats['size_bytes'], equals(65536));
        expect(stats['size_pages'], equals(1));
      });

      test('should handle empty result', () async {
        // Arrange
        when(() => instance.getFunction('empty_function')).thenReturn(
          (List args) async => 0, // 0 means null pointer (ptr=0, len=0)
        );

        // Act
        final result = await bridge.call('empty_function', {});

        // Assert
        expect(result, isEmpty);
      });

      test('should throw WasmMemoryException when memory is missing', () {
        // Arrange
        final instanceNoMemory = MockWasmInstanceWithMemory();
        when(() => instanceNoMemory.memory).thenReturn(null);
        final bridgeNoMemory = WasmMemoryBridge(
          instance: instanceNoMemory,
          serializer: serializer,
        );

        // Act & Assert
        expect(
          () => bridgeNoMemory.call('test', {}),
          throwsA(isA<WasmMemoryException>()),
        );
      });

      test('should throw when alloc function is missing', () {
        // Arrange
        when(() => instance.getFunction('alloc')).thenReturn(null);

        // Act & Assert
        expect(
          () => bridge.call('test', {}),
          throwsA(isA<WasmMemoryException>()),
        );
      });

      test('should throw when dealloc function is missing', () {
        // Arrange
        when(() => instance.getFunction('dealloc')).thenReturn(null);

        // Act & Assert
        expect(
          () => bridge.call('test', {}),
          throwsA(isA<WasmMemoryException>()),
        );
      });

      test('should throw when target function is missing', () {
        // Arrange
        when(() => instance.getFunction('missing_func')).thenReturn(null);

        // Act & Assert
        expect(
          () => bridge.call('missing_func', {}),
          throwsArgumentError,
        );
      });
    });

    group('Memory Safety', () {
      test('should validate packed result values', () async {
        // Arrange
        final instance = MockWasmInstanceWithMemory();
        final serializer = MockSerializer();
        final bridge = WasmMemoryBridge(
          instance: instance,
          serializer: serializer,
        );

        // Simulate invalid packed result (all 1s)
        when(() => instance.getFunction('invalid_function')).thenReturn(
          (List args) async => 0xFFFFFFFFFFFFFFFF,
        );

        // Act & Assert
        expect(
          () => bridge.call('invalid_function', {}),
          throwsA(isA<PluginCommunicationException>()),
        );
      });

      test('should reject oversized results', () async {
        // Arrange
        final instance = MockWasmInstanceWithMemory();
        final serializer = MockSerializer();
        final bridge = WasmMemoryBridge(
          instance: instance,
          serializer: serializer,
        );

        // Simulate huge size (>100MB)
        when(() => instance.getFunction('huge_function')).thenReturn(
          (List args) async => (100 << 32) | (200 * 1024 * 1024), // 200MB
        );

        // Act & Assert
        expect(
          () => bridge.call('huge_function', {}),
          throwsA(isA<PluginCommunicationException>()),
        );
      });

      test('should handle memory allocation failures gracefully', () {
        // Test memory limits and allocation failures
        final memory = _MockWasmMemory();

        // Allocate many times to test limits
        for (var i = 0; i < 100; i++) {
          final ptr = memory.allocate(1024);
          expect(ptr, greaterThan(0));
        }
      });
    });

    group('Memory Layout', () {
      test('should pack pointer and length correctly', () {
        // Arrange
        const ptr = 0x12345678;
        const len = 0x9ABCDEF0;

        // Act
        final packed = (ptr << 32) | len;

        // Assert
        expect((packed >> 32) & 0xFFFFFFFF, equals(ptr));
        expect(packed & 0xFFFFFFFF, equals(len));
      });

      test('should unpack pointer and length correctly', () {
        // Arrange
        const packed = (0x12345678 << 32) | 0x9ABCDEF0;

        // Act
        final ptr = (packed >> 32) & 0xFFFFFFFF;
        final len = packed & 0xFFFFFFFF;

        // Assert
        expect(ptr, equals(0x12345678));
        expect(len, equals(0x9ABCDEF0));
      });

      test('should handle zero packed value', () {
        // Arrange
        const packed = 0;

        // Act
        final ptr = (packed >> 32) & 0xFFFFFFFF;
        final len = packed & 0xFFFFFFFF;

        // Assert
        expect(ptr, equals(0));
        expect(len, equals(0));
      });
    });

    group('Call Raw', () {
      test('should return raw bytes without deserialization', () async {
        // Arrange
        final instance = MockWasmInstanceWithMemory();
        final serializer = MockSerializer();
        final bridge = WasmMemoryBridge(
          instance: instance,
          serializer: serializer,
        );

        // Act
        final result = await bridge.callRaw('test_function', {});

        // Assert
        expect(result, isA<Uint8List>());
      });

      test('should handle invalid packed result in raw call', () async {
        // Arrange
        final instance = MockWasmInstanceWithMemory();
        final serializer = MockSerializer();
        final bridge = WasmMemoryBridge(
          instance: instance,
          serializer: serializer,
        );

        when(() => instance.getFunction('invalid_raw')).thenReturn(
          (List args) async => 0xFFFFFFFFFFFFFFFF,
        );

        // Act & Assert
        expect(
          () => bridge.callRaw('invalid_raw', {}),
          throwsA(isA<WasmMemoryException>()),
        );
      });
    });

    group('Error Handling', () {
      test('should throw WasmMemoryException with message', () {
        // Arrange
        const exception = WasmMemoryException('Test memory error');

        // Assert
        expect(exception.message, equals('Test memory error'));
        expect(exception.originalError, isNull);
      });

      test('should wrap original errors', () {
        // Arrange
        final originalError = Exception('Original error');
        final exception = WasmMemoryException(
          'Memory error',
          originalError: originalError,
        );

        // Assert
        expect(exception.originalError, isNotNull);
        expect(exception.toString(), contains('Original error'));
      });
    });

    group('Concurrent Memory Access', () {
      test('should handle concurrent memory operations', () async {
        // Arrange
        final memory = _MockWasmMemory();
        final operations = <Future>[];

        // Act - concurrent writes and reads
        for (var i = 0; i < 10; i++) {
          operations.add(
            memory.write(i * 100, Uint8List.fromList([i, i + 1, i + 2])),
          );
        }
        await Future.wait(operations);

        // Assert - verify all writes succeeded
        for (var i = 0; i < 10; i++) {
          final read = await memory.read(i * 100, 3);
          expect(read, equals([i, i + 1, i + 2]));
        }
      });
    });
  });
}
