import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/sha256_hash.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('SHA256Hash', () {
    const validHash = 'a' * 64; // 64 'a' characters
    const anotherValidHash = 'b' * 64;

    group('constructor', () {
      test('creates valid hash with lowercase hex', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.value, validHash);
      });

      test('creates valid hash with uppercase hex', () {
        final upperHash = 'A' * 64;
        final hash = SHA256Hash(value: upperHash);
        expect(hash.value, upperHash.toLowerCase());
      });

      test('creates valid hash with mixed case', () {
        final mixedHash = 'AbCdEf' + 'a' * 58;
        final hash = SHA256Hash(value: mixedHash);
        expect(hash.value, mixedHash.toLowerCase());
      });

      test('throws on invalid length (too short)', () {
        expect(
          () => SHA256Hash('a' * 63),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on invalid length (too long)', () {
        expect(
          () => SHA256Hash('a' * 65),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on empty string', () {
        expect(
          () => SHA256Hash(''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on non-hex characters', () {
        expect(
          () => SHA256Hash('g' + 'a' * 63),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on special characters', () {
        expect(
          () => SHA256Hash('@' + 'a' * 63),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on spaces', () {
        expect(
          () => SHA256Hash('a' * 32 + ' ' + 'a' * 31),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('matches', () {
      test('returns true for same hash', () {
        final hash1 = SHA256Hash(value: validHash);
        final hash2 = SHA256Hash(value: validHash);
        expect(hash1.matches(hash2), isTrue);
      });

      test('returns false for different hashes', () {
        final hash1 = SHA256Hash(value: validHash);
        final hash2 = SHA256Hash(value: anotherValidHash);
        expect(hash1.matches(hash2), isFalse);
      });

      test('is case-insensitive', () {
        final lowerHash = SHA256Hash('a' * 64);
        final upperHash = SHA256Hash('A' * 64);
        expect(lowerHash.matches(upperHash), isTrue);
      });
    });

    group('truncate', () {
      test('truncates to specified length', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.truncate(8), 'a' * 8);
      });

      test('truncates to default length of 16', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.truncate(), 'a' * 16);
      });

      test('returns full hash when length exceeds hash length', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.truncate(100), validHash);
      });

      test('returns full hash when length equals hash length', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.truncate(64), validHash);
      });

      test('handles zero length', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.truncate(0), '');
      });

      test('handles length of 1', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.truncate(1), 'a');
      });
    });

    group('toString', () {
      test('returns the hash value', () {
        final hash = SHA256Hash(value: validHash);
        expect(hash.toString(), validHash);
      });

      test('returns lowercase value', () {
        final hash = SHA256Hash('A' * 64);
        expect(hash.toString(), 'a' * 64);
      });
    });

    group('equality', () {
      test('equal hashes are equal', () {
        final hash1 = SHA256Hash(value: validHash);
        final hash2 = SHA256Hash(value: validHash);
        expect(hash1, equals(hash2));
        expect(hash1.hashCode, equals(hash2.hashCode));
      });

      test('different hashes are not equal', () {
        final hash1 = SHA256Hash(value: validHash);
        final hash2 = SHA256Hash(value: anotherValidHash);
        expect(hash1, isNot(equals(hash2)));
      });

      test('case-insensitive equality', () {
        final lowerHash = SHA256Hash('a' * 64);
        final upperHash = SHA256Hash('A' * 64);
        expect(lowerHash, equals(upperHash));
      });
    });

    group('real-world hashes', () {
      test('accepts valid SHA256 hash from file', () {
        const realHash = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
        final hash = SHA256Hash(value: realHash);
        expect(hash.value, realHash);
      });

      test('accepts another valid SHA256 hash', () {
        const realHash = '2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae';
        final hash = SHA256Hash(value: realHash);
        expect(hash.value, realHash);
      });

      test('normalizes uppercase real hash', () {
        const upperHash = 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855';
        const lowerHash = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
        final hash = SHA256Hash(value: upperHash);
        expect(hash.value, lowerHash);
      });
    });

    group('copyWith', () {
      test('creates copy with new value', () {
        final hash1 = SHA256Hash(value: validHash);
        final hash2 = hash1.copyWith(value: anotherValidHash);
        expect(hash2.value, anotherValidHash);
        expect(hash1.value, validHash);
      });
    });
  });
}
