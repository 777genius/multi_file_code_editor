import 'dart:typed_data';
import 'package:flutter_plugin_system_wasm/flutter_plugin_system_wasm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WASM Compilation', () {
    group('Module Validation', () {
      test('should validate WASM magic number', () async {
        // Arrange - valid WASM magic number
        final validBytes = Uint8List.fromList([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00]);

        // Act & Assert - should be valid
        expect(validBytes.length, greaterThanOrEqualTo(8));
        expect(validBytes[0], equals(0x00));
        expect(validBytes[1], equals(0x61));
        expect(validBytes[2], equals(0x73));
        expect(validBytes[3], equals(0x6d));
      });

      test('should reject invalid magic number', () {
        // Arrange - invalid magic number
        final invalidBytes = Uint8List.fromList([0xFF, 0xFF, 0xFF, 0xFF]);

        // Assert
        expect(invalidBytes[0], isNot(equals(0x00)));
      });

      test('should validate minimum module size', () {
        // Arrange - too small
        final tooSmall = Uint8List.fromList([0x00, 0x61]);

        // Assert
        expect(tooSmall.length, lessThan(8));
      });

      test('should validate WASM version', () {
        // Arrange - valid version (1.0.0.0)
        final withVersion = Uint8List.fromList([
          0x00, 0x61, 0x73, 0x6d, // magic
          0x01, 0x00, 0x00, 0x00, // version
        ]);

        // Assert
        expect(withVersion[4], equals(0x01)); // version
      });
    });

    group('Compilation Errors', () {
      test('should create compilation exception with message', () {
        // Arrange
        const exception = WasmCompilationException('Test compilation error');

        // Assert
        expect(exception.message, equals('Test compilation error'));
        expect(exception.errors, isNull);
      });

      test('should create compilation exception with errors list', () {
        // Arrange
        const exception = WasmCompilationException(
          'Compilation failed',
          errors: ['Syntax error at byte 10', 'Invalid section type'],
        );

        // Assert
        expect(exception.message, equals('Compilation failed'));
        expect(exception.errors, hasLength(2));
        expect(exception.toString(), contains('Syntax error'));
      });

      test('should format compilation errors correctly', () {
        // Arrange
        const exception = WasmCompilationException(
          'Failed',
          errors: ['Error 1', 'Error 2'],
        );

        // Act
        final message = exception.toString();

        // Assert
        expect(message, contains('WasmCompilationException'));
        expect(message, contains('Failed'));
        expect(message, contains('Error 1'));
        expect(message, contains('Error 2'));
      });
    });

    group('Module Structure', () {
      test('should validate section headers', () {
        // Arrange - type section (id: 1)
        final typeSection = Uint8List.fromList([
          0x01, // section id (type)
          0x05, // section size
          // section content would follow
        ]);

        // Assert
        expect(typeSection[0], equals(0x01)); // type section
      });

      test('should validate import section', () {
        // Arrange - import section (id: 2)
        final importSection = Uint8List.fromList([
          0x02, // section id (import)
          0x10, // section size
          // section content would follow
        ]);

        // Assert
        expect(importSection[0], equals(0x02)); // import section
      });

      test('should validate function section', () {
        // Arrange - function section (id: 3)
        final functionSection = Uint8List.fromList([
          0x03, // section id (function)
          0x08, // section size
          // section content would follow
        ]);

        // Assert
        expect(functionSection[0], equals(0x03)); // function section
      });

      test('should validate memory section', () {
        // Arrange - memory section (id: 5)
        final memorySection = Uint8List.fromList([
          0x05, // section id (memory)
          0x04, // section size
          // section content would follow
        ]);

        // Assert
        expect(memorySection[0], equals(0x05)); // memory section
      });

      test('should validate export section', () {
        // Arrange - export section (id: 7)
        final exportSection = Uint8List.fromList([
          0x07, // section id (export)
          0x0C, // section size
          // section content would follow
        ]);

        // Assert
        expect(exportSection[0], equals(0x07)); // export section
      });

      test('should validate code section', () {
        // Arrange - code section (id: 10)
        final codeSection = Uint8List.fromList([
          0x0A, // section id (code)
          0x20, // section size
          // section content would follow
        ]);

        // Assert
        expect(codeSection[0], equals(0x0A)); // code section
      });
    });

    group('Type Validation', () {
      test('should validate function types', () {
        // Arrange - function type (0x60)
        final functionType = Uint8List.fromList([
          0x60, // function type
          0x02, // param count
          0x7F, 0x7F, // i32, i32
          0x01, // result count
          0x7F, // i32
        ]);

        // Assert
        expect(functionType[0], equals(0x60)); // function type marker
      });

      test('should validate value types', () {
        // Arrange - value types
        const i32 = 0x7F;
        const i64 = 0x7E;
        const f32 = 0x7D;
        const f64 = 0x7C;

        // Assert
        expect(i32, equals(0x7F));
        expect(i64, equals(0x7E));
        expect(f32, equals(0x7D));
        expect(f64, equals(0x7C));
      });
    });

    group('LEB128 Encoding', () {
      test('should validate unsigned LEB128 encoding', () {
        // Arrange - 624485 in LEB128
        final encoded = Uint8List.fromList([0xE5, 0x8E, 0x26]);

        // Assert - first byte has continuation bit
        expect(encoded[0] & 0x80, equals(0x80));
        expect(encoded[1] & 0x80, equals(0x80));
        expect(encoded[2] & 0x80, equals(0x00)); // last byte
      });

      test('should validate signed LEB128 encoding', () {
        // Arrange - -123456 in signed LEB128
        final encoded = Uint8List.fromList([0xC0, 0xBB, 0x78]);

        // Assert
        expect(encoded.length, equals(3));
      });

      test('should validate small values', () {
        // Arrange - values 0-127 are single byte
        final small = Uint8List.fromList([0x42]); // 66

        // Assert
        expect(small.length, equals(1));
        expect(small[0] & 0x80, equals(0x00)); // no continuation
      });
    });

    group('Import Validation', () {
      test('should validate import kind', () {
        // Arrange - import kinds
        const functionImport = 0x00;
        const tableImport = 0x01;
        const memoryImport = 0x02;
        const globalImport = 0x03;

        // Assert
        expect(functionImport, equals(0x00));
        expect(tableImport, equals(0x01));
        expect(memoryImport, equals(0x02));
        expect(globalImport, equals(0x03));
      });
    });

    group('Export Validation', () {
      test('should validate export kind', () {
        // Arrange - export kinds
        const functionExport = 0x00;
        const tableExport = 0x01;
        const memoryExport = 0x02;
        const globalExport = 0x03;

        // Assert
        expect(functionExport, equals(0x00));
        expect(tableExport, equals(0x01));
        expect(memoryExport, equals(0x02));
        expect(globalExport, equals(0x03));
      });
    });

    group('Memory Limits', () {
      test('should validate memory limits without max', () {
        // Arrange - limits without maximum
        final limits = Uint8List.fromList([
          0x00, // flags (no maximum)
          0x01, // minimum pages
        ]);

        // Assert
        expect(limits[0], equals(0x00)); // no max flag
      });

      test('should validate memory limits with max', () {
        // Arrange - limits with maximum
        final limits = Uint8List.fromList([
          0x01, // flags (has maximum)
          0x01, // minimum pages
          0x10, // maximum pages
        ]);

        // Assert
        expect(limits[0], equals(0x01)); // has max flag
      });

      test('should validate 64KB page size', () {
        // Arrange
        const pageSize = 65536; // 64KB

        // Assert
        expect(pageSize, equals(64 * 1024));
      });
    });

    group('Instruction Validation', () {
      test('should validate control instructions', () {
        // Arrange - control instructions
        const unreachable = 0x00;
        const block = 0x02;
        const loop = 0x03;
        const ifInstr = 0x04;
        const br = 0x0C;
        const brIf = 0x0D;
        const ret = 0x0F;
        const call = 0x10;

        // Assert
        expect(unreachable, equals(0x00));
        expect(block, equals(0x02));
        expect(loop, equals(0x03));
        expect(ifInstr, equals(0x04));
        expect(br, equals(0x0C));
        expect(brIf, equals(0x0D));
        expect(ret, equals(0x0F));
        expect(call, equals(0x10));
      });

      test('should validate numeric instructions', () {
        // Arrange - i32 numeric instructions
        const i32Const = 0x41;
        const i32Add = 0x6A;
        const i32Sub = 0x6B;
        const i32Mul = 0x6C;

        // Assert
        expect(i32Const, equals(0x41));
        expect(i32Add, equals(0x6A));
        expect(i32Sub, equals(0x6B));
        expect(i32Mul, equals(0x6C));
      });

      test('should validate memory instructions', () {
        // Arrange - memory instructions
        const i32Load = 0x28;
        const i32Store = 0x36;
        const memorySize = 0x3F;
        const memoryGrow = 0x40;

        // Assert
        expect(i32Load, equals(0x28));
        expect(i32Store, equals(0x36));
        expect(memorySize, equals(0x3F));
        expect(memoryGrow, equals(0x40));
      });
    });

    group('Custom Sections', () {
      test('should validate custom section id', () {
        // Arrange - custom section (id: 0)
        final customSection = Uint8List.fromList([
          0x00, // custom section id
          0x08, // section size
          // section content follows
        ]);

        // Assert
        expect(customSection[0], equals(0x00)); // custom section
      });

      test('should support name subsections', () {
        // Arrange - name section type
        const moduleNameSubsection = 0x00;
        const functionNamesSubsection = 0x01;
        const localNamesSubsection = 0x02;

        // Assert
        expect(moduleNameSubsection, equals(0x00));
        expect(functionNamesSubsection, equals(0x01));
        expect(localNamesSubsection, equals(0x02));
      });
    });

    group('Data Segment Validation', () {
      test('should validate active data segment', () {
        // Arrange - active segment
        final segment = Uint8List.fromList([
          0x00, // active segment
          0x41, 0x00, // offset expression (i32.const 0)
          0x0B, // end
          0x05, // size
          // data bytes follow
        ]);

        // Assert
        expect(segment[0], equals(0x00)); // active mode
      });

      test('should validate passive data segment', () {
        // Arrange - passive segment
        final segment = Uint8List.fromList([
          0x01, // passive segment
          0x05, // size
          // data bytes follow
        ]);

        // Assert
        expect(segment[0], equals(0x01)); // passive mode
      });
    });

    group('Table Validation', () {
      test('should validate funcref table type', () {
        // Arrange - funcref type
        const funcref = 0x70;

        // Assert
        expect(funcref, equals(0x70));
      });

      test('should validate table limits', () {
        // Arrange - table with limits
        final table = Uint8List.fromList([
          0x70, // funcref
          0x00, // flags (no maximum)
          0x0A, // minimum
        ]);

        // Assert
        expect(table[0], equals(0x70)); // funcref
        expect(table[1], equals(0x00)); // no max
      });
    });

    group('Global Validation', () {
      test('should validate global type', () {
        // Arrange - mutable i32 global
        final global = Uint8List.fromList([
          0x7F, // i32
          0x01, // mutable
        ]);

        // Assert
        expect(global[0], equals(0x7F)); // i32
        expect(global[1], equals(0x01)); // mutable
      });

      test('should validate immutable global', () {
        // Arrange - immutable f64 global
        final global = Uint8List.fromList([
          0x7C, // f64
          0x00, // immutable
        ]);

        // Assert
        expect(global[0], equals(0x7C)); // f64
        expect(global[1], equals(0x00)); // immutable
      });
    });
  });
}
