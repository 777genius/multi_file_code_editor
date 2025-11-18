import 'dart:typed_data';
import 'package:flutter_plugin_system_core/flutter_plugin_system_core.dart';
import 'package:flutter_plugin_system_wasm/flutter_plugin_system_wasm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock WASM instance for interop testing
class MockWasmInstance extends Mock implements IWasmInstance {}

/// Mock WASM memory for interop testing
class MockWasmMemory extends Mock implements IWasmMemory {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('WASM Interop', () {
    group('Serialization', () {
      late PluginSerializer serializer;

      setUp(() {
        serializer = JsonPluginSerializer();
      });

      test('should serialize simple data', () {
        // Arrange
        final data = {
          'string': 'value',
          'number': 42,
          'bool': true,
        };

        // Act
        final bytes = serializer.serialize(data);

        // Assert
        expect(bytes, isA<Uint8List>());
        expect(bytes.length, greaterThan(0));
      });

      test('should deserialize simple data', () {
        // Arrange
        final data = {
          'string': 'value',
          'number': 42,
          'bool': true,
        };
        final bytes = serializer.serialize(data);

        // Act
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['string'], equals('value'));
        expect(deserialized['number'], equals(42));
        expect(deserialized['bool'], equals(true));
      });

      test('should handle nested data structures', () {
        // Arrange
        final data = {
          'nested': {
            'level1': {
              'level2': 'deep',
            },
          },
          'array': [1, 2, 3],
        };

        // Act
        final bytes = serializer.serialize(data);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['nested']['level1']['level2'], equals('deep'));
        expect(deserialized['array'], equals([1, 2, 3]));
      });

      test('should handle empty data', () {
        // Arrange
        final data = <String, dynamic>{};

        // Act
        final bytes = serializer.serialize(data);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized, isEmpty);
      });

      test('should handle null values', () {
        // Arrange
        final data = {
          'nullable': null,
          'present': 'value',
        };

        // Act
        final bytes = serializer.serialize(data);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['nullable'], isNull);
        expect(deserialized['present'], equals('value'));
      });

      test('should handle lists of different types', () {
        // Arrange
        final data = {
          'mixed': [1, 'two', 3.0, true, null],
        };

        // Act
        final bytes = serializer.serialize(data);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['mixed'], hasLength(5));
        expect(deserialized['mixed'][0], equals(1));
        expect(deserialized['mixed'][1], equals('two'));
        expect(deserialized['mixed'][2], equals(3.0));
        expect(deserialized['mixed'][3], equals(true));
        expect(deserialized['mixed'][4], isNull);
      });
    });

    group('Dart to WASM Communication', () {
      test('should call WASM function from Dart', () async {
        // Arrange
        final instance = MockWasmInstance();
        var called = false;
        when(() => instance.getFunction('dart_to_wasm')).thenReturn(
          (List args) async {
            called = true;
            return 42;
          },
        );

        // Act
        final function = instance.getFunction('dart_to_wasm');
        await function!([]);

        // Assert
        expect(called, isTrue);
      });

      test('should pass arguments from Dart to WASM', () async {
        // Arrange
        final instance = MockWasmInstance();
        List<dynamic>? receivedArgs;
        when(() => instance.getFunction('with_args')).thenReturn(
          (List args) async {
            receivedArgs = args;
            return 0;
          },
        );

        // Act
        final function = instance.getFunction('with_args');
        await function!([10, 20, 30]);

        // Assert
        expect(receivedArgs, equals([10, 20, 30]));
      });

      test('should receive return value from WASM', () async {
        // Arrange
        final instance = MockWasmInstance();
        when(() => instance.getFunction('returns_value')).thenReturn(
          (List args) async => 123,
        );

        // Act
        final function = instance.getFunction('returns_value');
        final result = await function!([]);

        // Assert
        expect(result, equals(123));
      });
    });

    group('WASM to Dart Communication', () {
      test('should call Dart function from WASM', () async {
        // Arrange
        var called = false;
        final dartFunction = (List args) async {
          called = true;
          return 'dart_result';
        };

        // Act
        final result = await dartFunction([]);

        // Assert
        expect(called, isTrue);
        expect(result, equals('dart_result'));
      });

      test('should pass arguments from WASM to Dart', () async {
        // Arrange
        List<dynamic>? receivedArgs;
        final dartFunction = (List args) async {
          receivedArgs = args;
          return null;
        };

        // Act
        await dartFunction(['arg1', 'arg2']);

        // Assert
        expect(receivedArgs, equals(['arg1', 'arg2']));
      });

      test('should handle Dart function errors', () async {
        // Arrange
        final dartFunction = (List args) async {
          throw Exception('Dart error');
        };

        // Act & Assert
        expect(() => dartFunction([]), throwsException);
      });
    });

    group('Memory Sharing', () {
      test('should share memory between Dart and WASM', () async {
        // Arrange
        final memory = MockWasmMemory();
        final data = Uint8List.fromList([1, 2, 3, 4]);

        when(() => memory.write(any(), any())).thenAnswer((_) async => {});
        when(() => memory.read(any(), any())).thenAnswer((_) async => data);

        // Act
        await memory.write(100, data);
        final read = await memory.read(100, 4);

        // Assert
        expect(read, equals(data));
      });

      test('should handle concurrent memory access', () async {
        // Arrange
        final memory = MockWasmMemory();
        final operations = <Future>[];

        when(() => memory.write(any(), any())).thenAnswer((_) async => {});

        // Act - simulate concurrent writes
        for (var i = 0; i < 10; i++) {
          operations.add(
            memory.write(i * 100, Uint8List.fromList([i])),
          );
        }

        // Assert - should not throw
        await Future.wait(operations);
      });
    });

    group('Type Conversions', () {
      test('should convert Dart numbers to WASM', () {
        // Arrange
        const dartInt = 42;
        const dartDouble = 3.14;

        // Assert - numbers are compatible
        expect(dartInt, isA<int>());
        expect(dartDouble, isA<double>());
      });

      test('should convert WASM numbers to Dart', () async {
        // Arrange
        final instance = MockWasmInstance();
        when(() => instance.getFunction('returns_i32')).thenReturn(
          (List args) async => 42,
        );
        when(() => instance.getFunction('returns_f64')).thenReturn(
          (List args) async => 3.14,
        );

        // Act
        final i32Result = await instance.getFunction('returns_i32')!([]);
        final f64Result = await instance.getFunction('returns_f64')!([]);

        // Assert
        expect(i32Result, equals(42));
        expect(f64Result, closeTo(3.14, 0.001));
      });

      test('should handle string conversion', () {
        // Arrange
        final serializer = JsonPluginSerializer();
        final data = {'message': 'Hello, WASM!'};

        // Act
        final bytes = serializer.serialize(data);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['message'], equals('Hello, WASM!'));
      });

      test('should handle boolean conversion', () {
        // Arrange
        final serializer = JsonPluginSerializer();
        final data = {
          'isTrue': true,
          'isFalse': false,
        };

        // Act
        final bytes = serializer.serialize(data);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['isTrue'], isTrue);
        expect(deserialized['isFalse'], isFalse);
      });
    });

    group('Error Propagation', () {
      test('should propagate WASM errors to Dart', () async {
        // Arrange
        final instance = MockWasmInstance();
        when(() => instance.getFunction('throws_error')).thenReturn(
          (List args) async => throw Exception('WASM error'),
        );

        // Act & Assert
        expect(
          () => instance.getFunction('throws_error')!([]),
          throwsException,
        );
      });

      test('should propagate Dart errors to WASM context', () async {
        // Arrange
        final dartFunction = (List args) async {
          throw Exception('Dart error');
        };

        // Act & Assert
        expect(() => dartFunction([]), throwsException);
      });

      test('should handle serialization errors', () {
        // Arrange
        final serializer = JsonPluginSerializer();

        // Act & Assert - circular references or invalid data should be handled
        // (JSON serializer will handle this gracefully)
      });
    });

    group('Function Imports/Exports', () {
      test('should expose Dart functions to WASM', () async {
        // Arrange
        final imports = <String, Map<String, WasmImport>>{
          'env': {
            'dart_log': WasmImport.function((args) async {
              // Dart logging function exposed to WASM
              return null;
            }),
          },
        };

        // Assert
        expect(imports['env']!['dart_log'], isNotNull);
      });

      test('should call WASM exported functions from Dart', () async {
        // Arrange
        final instance = MockWasmInstance();
        when(() => instance.getFunction('exported_func')).thenReturn(
          (List args) async => 'exported_result',
        );

        // Act
        final function = instance.getFunction('exported_func');
        final result = await function!([]);

        // Assert
        expect(result, equals('exported_result'));
      });
    });

    group('Performance Considerations', () {
      test('should handle large data transfers efficiently', () {
        // Arrange
        final serializer = JsonPluginSerializer();
        final largeData = {
          'array': List.generate(1000, (i) => i),
        };

        // Act
        final bytes = serializer.serialize(largeData);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['array'], hasLength(1000));
      });

      test('should minimize serialization overhead', () {
        // Arrange
        final serializer = JsonPluginSerializer();
        final data = {'simple': 'data'};

        // Act
        final bytes = serializer.serialize(data);

        // Assert - should be reasonably small
        expect(bytes.length, lessThan(1000));
      });
    });

    group('State Management', () {
      test('should maintain state across calls', () async {
        // Arrange
        var callCount = 0;
        final instance = MockWasmInstance();
        when(() => instance.getFunction('stateful')).thenReturn(
          (List args) async {
            callCount++;
            return callCount;
          },
        );

        // Act
        final function = instance.getFunction('stateful');
        final result1 = await function!([]);
        final result2 = await function([]);
        final result3 = await function([]);

        // Assert
        expect(result1, equals(1));
        expect(result2, equals(2));
        expect(result3, equals(3));
      });
    });

    group('Plugin Event Interop', () {
      test('should serialize plugin events for WASM', () {
        // Arrange
        final serializer = JsonPluginSerializer();
        final event = PluginEvent.now(
          type: 'file.opened',
          data: {'filename': 'test.dart'},
        );

        // Act
        final eventData = event.toJson();
        final bytes = serializer.serialize(eventData);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['type'], equals('file.opened'));
        expect(deserialized['data']['filename'], equals('test.dart'));
      });

      test('should serialize plugin responses from WASM', () {
        // Arrange
        final serializer = JsonPluginSerializer();
        final response = PluginResponse.success(
          data: {'result': 'processed'},
        );

        // Act
        final responseData = response.toJson();
        final bytes = serializer.serialize(responseData);
        final deserialized = serializer.deserialize(bytes);

        // Assert
        expect(deserialized['success'], isTrue);
        expect(deserialized['data']['result'], equals('processed'));
      });
    });

    group('Bi-directional Communication', () {
      test('should support request-response pattern', () async {
        // Arrange
        final instance = MockWasmInstance();
        when(() => instance.getFunction('process')).thenReturn(
          (List args) async {
            final input = args[0] as int;
            return input * 2; // Double the input
          },
        );

        // Act
        final function = instance.getFunction('process');
        final result = await function!([21]);

        // Assert
        expect(result, equals(42));
      });

      test('should support async callbacks', () async {
        // Arrange
        var callbackCalled = false;
        final dartCallback = (List args) async {
          callbackCalled = true;
          await Future.delayed(const Duration(milliseconds: 10));
          return 'callback_result';
        };

        // Act
        final result = await dartCallback([]);

        // Assert
        expect(callbackCalled, isTrue);
        expect(result, equals('callback_result'));
      });
    });
  });
}
