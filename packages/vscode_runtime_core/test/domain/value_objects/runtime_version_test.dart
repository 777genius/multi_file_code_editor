import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/runtime_version.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('RuntimeVersion', () {
    group('constructor', () {
      test('creates valid version', () {
        final version = RuntimeVersion(major: 1, minor: 2, patch: 3);

        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, isNull);
        expect(version.build, isNull);
      });

      test('creates version with preRelease', () {
        final version = RuntimeVersion(
          major: 1,
          minor: 2,
          patch: 3,
          preRelease: 'beta.1',
        );

        expect(version.preRelease, 'beta.1');
      });

      test('creates version with build', () {
        final version = RuntimeVersion(
          major: 1,
          minor: 2,
          patch: 3,
          build: '20231215',
        );

        expect(version.build, '20231215');
      });

      test('throws on negative major', () {
        expect(
          () => RuntimeVersion(major: -1, minor: 0, patch: 0),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on negative minor', () {
        expect(
          () => RuntimeVersion(major: 1, minor: -1, patch: 0),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on negative patch', () {
        expect(
          () => RuntimeVersion(major: 1, minor: 0, patch: -1),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('fromString', () {
      test('parses simple version', () {
        final version = RuntimeVersion.fromString('1.2.3');

        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, isNull);
        expect(version.build, isNull);
      });

      test('parses version with preRelease', () {
        final version = RuntimeVersion.fromString('1.2.3-beta.1');

        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, 'beta.1');
      });

      test('parses version with build', () {
        final version = RuntimeVersion.fromString('1.2.3+20231215');

        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.build, '20231215');
      });

      test('parses version with preRelease and build', () {
        final version = RuntimeVersion.fromString('1.2.3-beta.1+20231215');

        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, 'beta.1');
        expect(version.build, '20231215');
      });

      test('throws on invalid format', () {
        expect(
          () => RuntimeVersion.fromString('invalid'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on missing parts', () {
        expect(
          () => RuntimeVersion.fromString('1.2'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on non-numeric parts', () {
        expect(
          () => RuntimeVersion.fromString('1.x.3'),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('toString', () {
      test('formats simple version', () {
        final version = RuntimeVersion(major: 1, minor: 2, patch: 3);
        expect(version.toString(), '1.2.3');
      });

      test('formats version with preRelease', () {
        final version = RuntimeVersion(
          major: 1,
          minor: 2,
          patch: 3,
          preRelease: 'beta.1',
        );
        expect(version.toString(), '1.2.3-beta.1');
      });

      test('formats version with build', () {
        final version = RuntimeVersion(
          major: 1,
          minor: 2,
          patch: 3,
          build: '20231215',
        );
        expect(version.toString(), '1.2.3+20231215');
      });

      test('formats version with preRelease and build', () {
        final version = RuntimeVersion(
          major: 1,
          minor: 2,
          patch: 3,
          preRelease: 'beta.1',
          build: '20231215',
        );
        expect(version.toString(), '1.2.3-beta.1+20231215');
      });
    });

    group('compareTo', () {
      test('compares major versions', () {
        final v1 = RuntimeVersion(major: 1, minor: 0, patch: 0);
        final v2 = RuntimeVersion(major: 2, minor: 0, patch: 0);

        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('compares minor versions when major is equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 1, patch: 0);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 0);

        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('compares patch versions when major and minor are equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 0, patch: 1);
        final v2 = RuntimeVersion(major: 1, minor: 0, patch: 2);

        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('equal versions return 0', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3);

        expect(v1.compareTo(v2), 0);
      });

      test('release version is greater than preRelease', () {
        final v1 = RuntimeVersion(major: 1, minor: 0, patch: 0, preRelease: 'beta');
        final v2 = RuntimeVersion(major: 1, minor: 0, patch: 0);

        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('compares preRelease lexicographically', () {
        final v1 = RuntimeVersion(major: 1, minor: 0, patch: 0, preRelease: 'alpha');
        final v2 = RuntimeVersion(major: 1, minor: 0, patch: 0, preRelease: 'beta');

        expect(v1.compareTo(v2), lessThan(0));
      });
    });

    group('isNewerThan', () {
      test('returns true when version is newer', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 2);

        expect(v1.isNewerThan(v2), isTrue);
      });

      test('returns false when version is older', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 2);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3);

        expect(v1.isNewerThan(v2), isFalse);
      });

      test('returns false when versions are equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3);

        expect(v1.isNewerThan(v2), isFalse);
      });
    });

    group('isCompatibleWith', () {
      test('returns true for same major version', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 4, patch: 5);

        expect(v1.isCompatibleWith(v2), isTrue);
      });

      test('returns false for different major version', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 2, minor: 0, patch: 0);

        expect(v1.isCompatibleWith(v2), isFalse);
      });

      test('returns true for exact match', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3);

        expect(v1.isCompatibleWith(v2), isTrue);
      });
    });

    group('equality', () {
      test('equal versions are equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3);

        expect(v1, equals(v2));
        expect(v1.hashCode, equals(v2.hashCode));
      });

      test('different versions are not equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 4);

        expect(v1, isNot(equals(v2)));
      });

      test('versions with different preRelease are not equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3, preRelease: 'beta.1');
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3, preRelease: 'beta.2');

        expect(v1, isNot(equals(v2)));
      });

      test('versions with different build are not equal', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3, build: '123');
        final v2 = RuntimeVersion(major: 1, minor: 2, patch: 3, build: '456');

        expect(v1, isNot(equals(v2)));
      });
    });

    group('copyWith', () {
      test('creates copy with updated major', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = v1.copyWith(major: 2);

        expect(v2.major, 2);
        expect(v2.minor, 2);
        expect(v2.patch, 3);
      });

      test('creates copy with updated minor', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = v1.copyWith(minor: 5);

        expect(v2.major, 1);
        expect(v2.minor, 5);
        expect(v2.patch, 3);
      });

      test('creates copy with updated patch', () {
        final v1 = RuntimeVersion(major: 1, minor: 2, patch: 3);
        final v2 = v1.copyWith(patch: 7);

        expect(v2.major, 1);
        expect(v2.minor, 2);
        expect(v2.patch, 7);
      });
    });
  });
}
