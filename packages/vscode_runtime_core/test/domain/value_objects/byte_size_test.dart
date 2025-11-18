import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/byte_size.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('ByteSize', () {
    group('constructor', () {
      test('creates valid byte size', () {
        final size = ByteSize(1024);
        expect(size.bytes, 1024);
      });

      test('creates zero byte size', () {
        final size = ByteSize(0);
        expect(size.bytes, 0);
      });

      test('throws on negative bytes', () {
        expect(
          () => ByteSize(-1),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('factory constructors', () {
      test('fromKB creates correct byte size', () {
        final size = ByteSize.fromKB(1);
        expect(size.bytes, 1024);
      });

      test('fromMB creates correct byte size', () {
        final size = ByteSize.fromMB(1);
        expect(size.bytes, 1024 * 1024);
      });

      test('fromGB creates correct byte size', () {
        final size = ByteSize.fromGB(1);
        expect(size.bytes, 1024 * 1024 * 1024);
      });

      test('fromKB handles fractional values', () {
        final size = ByteSize.fromKB(1.5);
        expect(size.bytes, 1536); // 1.5 * 1024
      });

      test('fromMB handles fractional values', () {
        final size = ByteSize.fromMB(0.5);
        expect(size.bytes, 524288); // 0.5 * 1024 * 1024
      });
    });

    group('getters', () {
      test('inKB returns correct value', () {
        final size = ByteSize(2048);
        expect(size.inKB, 2.0);
      });

      test('inMB returns correct value', () {
        final size = ByteSize(2097152); // 2 * 1024 * 1024
        expect(size.inMB, 2.0);
      });

      test('inGB returns correct value', () {
        final size = ByteSize(2147483648); // 2 * 1024 * 1024 * 1024
        expect(size.inGB, 2.0);
      });

      test('inKB handles fractional values', () {
        final size = ByteSize(1536); // 1.5 KB
        expect(size.inKB, 1.5);
      });

      test('zero bytes returns zero for all units', () {
        final size = ByteSize(0);
        expect(size.inKB, 0.0);
        expect(size.inMB, 0.0);
        expect(size.inGB, 0.0);
      });
    });

    group('toHumanReadable', () {
      test('formats bytes', () {
        final size = ByteSize(512);
        expect(size.toHumanReadable(), '512 B');
      });

      test('formats KB', () {
        final size = ByteSize(1536); // 1.5 KB
        expect(size.toHumanReadable(), '1.50 KB');
      });

      test('formats MB', () {
        final size = ByteSize(1572864); // 1.5 MB
        expect(size.toHumanReadable(), '1.50 MB');
      });

      test('formats GB', () {
        final size = ByteSize(1610612736); // 1.5 GB
        expect(size.toHumanReadable(), '1.50 GB');
      });

      test('formats zero bytes', () {
        final size = ByteSize(0);
        expect(size.toHumanReadable(), '0 B');
      });

      test('uses correct precision', () {
        final size = ByteSize(1024 * 1024 + 512 * 1024); // 1.5 MB
        final readable = size.toHumanReadable();
        expect(readable, contains('1.50'));
      });
    });

    group('progressTo', () {
      test('calculates progress percentage', () {
        final current = ByteSize(50);
        final total = ByteSize(100);
        expect(current.progressTo(total), 0.5);
      });

      test('returns 0 when current is 0', () {
        final current = ByteSize(0);
        final total = ByteSize(100);
        expect(current.progressTo(total), 0.0);
      });

      test('returns 1 when current equals total', () {
        final current = ByteSize(100);
        final total = ByteSize(100);
        expect(current.progressTo(total), 1.0);
      });

      test('returns 0 when total is 0', () {
        final current = ByteSize(50);
        final total = ByteSize(0);
        expect(current.progressTo(total), 0.0);
      });

      test('handles fractional progress', () {
        final current = ByteSize(33);
        final total = ByteSize(100);
        expect(current.progressTo(total), 0.33);
      });
    });

    group('operators', () {
      test('+ adds byte sizes', () {
        final a = ByteSize(100);
        final b = ByteSize(50);
        final result = a + b;
        expect(result.bytes, 150);
      });

      test('- subtracts byte sizes', () {
        final a = ByteSize(100);
        final b = ByteSize(50);
        final result = a - b;
        expect(result.bytes, 50);
      });

      test('< compares byte sizes', () {
        final a = ByteSize(50);
        final b = ByteSize(100);
        expect(a < b, isTrue);
        expect(b < a, isFalse);
      });

      test('<= compares byte sizes', () {
        final a = ByteSize(50);
        final b = ByteSize(100);
        final c = ByteSize(50);
        expect(a <= b, isTrue);
        expect(a <= c, isTrue);
        expect(b <= a, isFalse);
      });

      test('> compares byte sizes', () {
        final a = ByteSize(100);
        final b = ByteSize(50);
        expect(a > b, isTrue);
        expect(b > a, isFalse);
      });

      test('>= compares byte sizes', () {
        final a = ByteSize(100);
        final b = ByteSize(50);
        final c = ByteSize(100);
        expect(a >= b, isTrue);
        expect(a >= c, isTrue);
        expect(b >= a, isFalse);
      });
    });

    group('equality', () {
      test('equal byte sizes are equal', () {
        final a = ByteSize(100);
        final b = ByteSize(100);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different byte sizes are not equal', () {
        final a = ByteSize(100);
        final b = ByteSize(50);
        expect(a, isNot(equals(b)));
      });
    });

    group('compareTo', () {
      test('compares correctly', () {
        final a = ByteSize(50);
        final b = ByteSize(100);
        final c = ByteSize(50);

        expect(a.compareTo(b), lessThan(0));
        expect(b.compareTo(a), greaterThan(0));
        expect(a.compareTo(c), 0);
      });
    });
  });
}
