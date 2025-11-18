import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/module_id.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('ModuleId', () {
    group('well-known IDs', () {
      test('nodejs has correct value', () {
        expect(ModuleId.nodejs.value, 'nodejs');
      });

      test('openVSCodeServer has correct value', () {
        expect(ModuleId.openVSCodeServer.value, 'openvscode-server');
      });

      test('baseExtensions has correct value', () {
        expect(ModuleId.baseExtensions.value, 'base-extensions');
      });
    });

    group('constructor', () {
      test('creates valid module ID with lowercase letters', () {
        final id = ModuleId(value: 'mymodule');
        expect(id.value, 'mymodule');
      });

      test('creates valid module ID with numbers', () {
        final id = ModuleId(value: 'module123');
        expect(id.value, 'module123');
      });

      test('creates valid module ID with hyphens', () {
        final id = ModuleId(value: 'my-module-name');
        expect(id.value, 'my-module-name');
      });

      test('creates valid module ID with mixed lowercase, numbers, hyphens', () {
        final id = ModuleId(value: 'module-name-123');
        expect(id.value, 'module-name-123');
      });

      test('creates valid single character ID', () {
        final id = ModuleId(value: 'a');
        expect(id.value, 'a');
      });

      test('throws on empty string', () {
        expect(
          () => ModuleId(value: ''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on uppercase letters', () {
        expect(
          () => ModuleId(value: 'MyModule'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on spaces', () {
        expect(
          () => ModuleId(value: 'my module'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on underscores', () {
        expect(
          () => ModuleId(value: 'my_module'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on special characters', () {
        expect(
          () => ModuleId(value: 'my@module'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on dots', () {
        expect(
          () => ModuleId(value: 'my.module'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on starting with hyphen', () {
        expect(
          () => ModuleId(value: '-mymodule'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on ending with hyphen', () {
        expect(
          () => ModuleId(value: 'mymodule-'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on consecutive hyphens', () {
        expect(
          () => ModuleId(value: 'my--module'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on starting with number', () {
        expect(
          () => ModuleId(value: '123module'),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('toString', () {
      test('returns the value', () {
        final id = ModuleId(value: 'test-module');
        expect(id.toString(), 'test-module');
      });
    });

    group('equality', () {
      test('equal IDs are equal', () {
        final id1 = ModuleId(value: 'test-module');
        final id2 = ModuleId(value: 'test-module');
        expect(id1, equals(id2));
        expect(id1.hashCode, equals(id2.hashCode));
      });

      test('different IDs are not equal', () {
        final id1 = ModuleId(value: 'module-a');
        final id2 = ModuleId(value: 'module-b');
        expect(id1, isNot(equals(id2)));
      });

      test('well-known IDs work with equality', () {
        final id = ModuleId(value: 'nodejs');
        expect(id, equals(ModuleId.nodejs));
      });
    });

    group('copyWith', () {
      test('creates copy with new value', () {
        final id1 = ModuleId(value: 'module-a');
        final id2 = id1.copyWith(value: 'module-b');
        expect(id2.value, 'module-b');
        expect(id1.value, 'module-a');
      });
    });

    group('validation edge cases', () {
      test('accepts very long valid ID', () {
        final longId = 'a' * 100;
        final id = ModuleId(value: longId);
        expect(id.value, longId);
      });

      test('accepts ID with multiple hyphens properly spaced', () {
        final id = ModuleId(value: 'my-module-name-with-hyphens');
        expect(id.value, 'my-module-name-with-hyphens');
      });

      test('accepts ID ending with number', () {
        final id = ModuleId(value: 'module-v2');
        expect(id.value, 'module-v2');
      });

      test('accepts ID with all numbers (except first char)', () {
        final id = ModuleId(value: 'v123456');
        expect(id.value, 'v123456');
      });
    });
  });
}
