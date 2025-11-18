import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/installation_id.dart';

void main() {
  group('InstallationId', () {
    group('generate', () {
      test('generates valid UUID', () {
        final id = InstallationId.generate();
        // UUID v4 format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
        final uuidPattern = RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        );
        expect(uuidPattern.hasMatch(id.value), isTrue);
      });

      test('generates unique IDs', () {
        final id1 = InstallationId.generate();
        final id2 = InstallationId.generate();
        expect(id1, isNot(equals(id2)));
      });

      test('generates multiple unique IDs', () {
        final ids = List.generate(100, (_) => InstallationId.generate());
        final uniqueIds = ids.toSet();
        expect(uniqueIds.length, 100);
      });
    });

    group('constructor', () {
      test('creates ID with valid UUID', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final id = InstallationId(value: uuid);
        expect(id.value, uuid);
      });

      test('creates ID with uppercase UUID', () {
        const uuid = '550E8400-E29B-41D4-A716-446655440000';
        final id = InstallationId(value: uuid);
        expect(id.value, uuid.toLowerCase());
      });

      test('creates ID with mixed case UUID', () {
        const uuid = '550e8400-E29B-41d4-A716-446655440000';
        final id = InstallationId(value: uuid);
        expect(id.value, uuid.toLowerCase());
      });
    });

    group('toString', () {
      test('returns the UUID value', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final id = InstallationId(value: uuid);
        expect(id.toString(), uuid);
      });

      test('returns lowercase UUID', () {
        const uuid = '550E8400-E29B-41D4-A716-446655440000';
        final id = InstallationId(value: uuid);
        expect(id.toString(), uuid.toLowerCase());
      });
    });

    group('equality', () {
      test('equal IDs are equal', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final id1 = InstallationId(value: uuid);
        final id2 = InstallationId(value: uuid);
        expect(id1, equals(id2));
        expect(id1.hashCode, equals(id2.hashCode));
      });

      test('different IDs are not equal', () {
        final id1 = InstallationId(value: '550e8400-e29b-41d4-a716-446655440000');
        final id2 = InstallationId(value: '6ba7b810-9dad-11d1-80b4-00c04fd430c8');
        expect(id1, isNot(equals(id2)));
      });

      test('case-insensitive equality', () {
        final id1 = InstallationId(value: '550e8400-e29b-41d4-a716-446655440000');
        final id2 = InstallationId(value: '550E8400-E29B-41D4-A716-446655440000');
        expect(id1, equals(id2));
      });
    });

    group('copyWith', () {
      test('creates copy with new value', () {
        final id1 = InstallationId(value: '550e8400-e29b-41d4-a716-446655440000');
        final id2 = id1.copyWith(value: '6ba7b810-9dad-11d1-80b4-00c04fd430c8');
        expect(id2.value, '6ba7b810-9dad-11d1-80b4-00c04fd430c8');
        expect(id1.value, '550e8400-e29b-41d4-a716-446655440000');
      });
    });

    group('real-world usage', () {
      test('generated IDs are valid for construction', () {
        final generated = InstallationId.generate();
        final reconstructed = InstallationId(value: generated.value);
        expect(reconstructed, equals(generated));
      });

      test('can be used in Sets', () {
        final id1 = InstallationId.generate();
        final id2 = InstallationId.generate();
        final id3 = InstallationId(value: id1.value);

        final set = {id1, id2, id3};
        expect(set.length, 2); // id1 and id3 are equal
      });

      test('can be used in Maps', () {
        final id1 = InstallationId.generate();
        final id2 = InstallationId.generate();
        final id3 = InstallationId(value: id1.value);

        final map = {
          id1: 'value1',
          id2: 'value2',
          id3: 'value3',
        };

        expect(map.length, 2); // id1 and id3 map to same key
        expect(map[id1], 'value3'); // id3 overwrote id1's value
      });
    });
  });
}
