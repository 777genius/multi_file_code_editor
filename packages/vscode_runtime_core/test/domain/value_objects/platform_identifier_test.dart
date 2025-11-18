import 'package:test/test.dart';
import 'package:vscode_runtime_core/src/domain/value_objects/platform_identifier.dart';
import 'package:vscode_runtime_core/src/domain/exceptions/domain_exception.dart';

void main() {
  group('PlatformIdentifier', () {
    group('well-known platforms', () {
      test('windowsX64 has correct os and arch', () {
        expect(PlatformIdentifier.windowsX64.os, 'windows');
        expect(PlatformIdentifier.windowsX64.architecture, 'x64');
      });

      test('linuxX64 has correct os and arch', () {
        expect(PlatformIdentifier.linuxX64.os, 'linux');
        expect(PlatformIdentifier.linuxX64.architecture, 'x64');
      });

      test('macosX64 has correct os and arch', () {
        expect(PlatformIdentifier.macosX64.os, 'macos');
        expect(PlatformIdentifier.macosX64.architecture, 'x64');
      });

      test('macosArm64 has correct os and arch', () {
        expect(PlatformIdentifier.macosArm64.os, 'macos');
        expect(PlatformIdentifier.macosArm64.architecture, 'arm64');
      });
    });

    group('constructor', () {
      test('creates valid platform identifier', () {
        final platform = PlatformIdentifier(os: 'linux', architecture: 'x64');
        expect(platform.os, 'linux');
        expect(platform.architecture, 'x64');
      });

      test('creates platform with valid os names', () {
        final validOsList = ['windows', 'linux', 'macos', 'freebsd'];
        for (final os in validOsList) {
          final platform = PlatformIdentifier(os: os, architecture: 'x64');
          expect(platform.os, os);
        }
      });

      test('creates platform with valid architectures', () {
        final validArchList = ['x64', 'arm64', 'x86', 'arm'];
        for (final arch in validArchList) {
          final platform = PlatformIdentifier(os: 'linux', architecture: arch);
          expect(platform.architecture, arch);
        }
      });

      test('throws on empty os', () {
        expect(
          () => PlatformIdentifier(os: '', architecture: 'x64'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on empty architecture', () {
        expect(
          () => PlatformIdentifier(os: 'linux', architecture: ''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on invalid os with spaces', () {
        expect(
          () => PlatformIdentifier(os: 'linux os', architecture: 'x64'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on invalid architecture with spaces', () {
        expect(
          () => PlatformIdentifier(os: 'linux', architecture: 'x 64'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on os with uppercase', () {
        expect(
          () => PlatformIdentifier(os: 'Linux', architecture: 'x64'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on architecture with uppercase', () {
        expect(
          () => PlatformIdentifier(os: 'linux', architecture: 'X64'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on os with special characters', () {
        expect(
          () => PlatformIdentifier(os: 'linux@', architecture: 'x64'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on architecture with special characters', () {
        expect(
          () => PlatformIdentifier(os: 'linux', architecture: 'x64!'),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('toDisplayString', () {
      test('formats display string', () {
        final platform = PlatformIdentifier(os: 'linux', architecture: 'x64');
        expect(platform.toDisplayString(), 'Linux (x64)');
      });

      test('formats windows correctly', () {
        expect(
          PlatformIdentifier.windowsX64.toDisplayString(),
          'Windows (x64)',
        );
      });

      test('formats macos correctly', () {
        expect(
          PlatformIdentifier.macosArm64.toDisplayString(),
          'macOS (arm64)',
        );
      });

      test('formats linux correctly', () {
        expect(
          PlatformIdentifier.linuxX64.toDisplayString(),
          'Linux (x64)',
        );
      });

      test('capitalizes first letter of os', () {
        final platform = PlatformIdentifier(os: 'freebsd', architecture: 'x64');
        expect(platform.toDisplayString(), 'Freebsd (x64)');
      });
    });

    group('toString', () {
      test('formats as os-architecture', () {
        final platform = PlatformIdentifier(os: 'linux', architecture: 'x64');
        expect(platform.toString(), 'linux-x64');
      });

      test('formats well-known platforms correctly', () {
        expect(PlatformIdentifier.windowsX64.toString(), 'windows-x64');
        expect(PlatformIdentifier.linuxX64.toString(), 'linux-x64');
        expect(PlatformIdentifier.macosX64.toString(), 'macos-x64');
        expect(PlatformIdentifier.macosArm64.toString(), 'macos-arm64');
      });
    });

    group('equality', () {
      test('equal platforms are equal', () {
        final p1 = PlatformIdentifier(os: 'linux', architecture: 'x64');
        final p2 = PlatformIdentifier(os: 'linux', architecture: 'x64');
        expect(p1, equals(p2));
        expect(p1.hashCode, equals(p2.hashCode));
      });

      test('different platforms are not equal', () {
        final p1 = PlatformIdentifier(os: 'linux', architecture: 'x64');
        final p2 = PlatformIdentifier(os: 'windows', architecture: 'x64');
        expect(p1, isNot(equals(p2)));
      });

      test('same os different arch are not equal', () {
        final p1 = PlatformIdentifier(os: 'macos', architecture: 'x64');
        final p2 = PlatformIdentifier(os: 'macos', architecture: 'arm64');
        expect(p1, isNot(equals(p2)));
      });

      test('well-known platforms work with equality', () {
        final p = PlatformIdentifier(os: 'linux', architecture: 'x64');
        expect(p, equals(PlatformIdentifier.linuxX64));
      });
    });

    group('copyWith', () {
      test('creates copy with new os', () {
        final p1 = PlatformIdentifier(os: 'linux', architecture: 'x64');
        final p2 = p1.copyWith(os: 'windows');
        expect(p2.os, 'windows');
        expect(p2.architecture, 'x64');
        expect(p1.os, 'linux');
      });

      test('creates copy with new architecture', () {
        final p1 = PlatformIdentifier(os: 'macos', architecture: 'x64');
        final p2 = p1.copyWith(architecture: 'arm64');
        expect(p2.os, 'macos');
        expect(p2.architecture, 'arm64');
        expect(p1.architecture, 'x64');
      });

      test('creates copy with both new os and architecture', () {
        final p1 = PlatformIdentifier(os: 'linux', architecture: 'x64');
        final p2 = p1.copyWith(os: 'windows', architecture: 'arm64');
        expect(p2.os, 'windows');
        expect(p2.architecture, 'arm64');
      });
    });

    group('validation edge cases', () {
      test('accepts os with numbers', () {
        final platform = PlatformIdentifier(os: 'os2', architecture: 'x64');
        expect(platform.os, 'os2');
      });

      test('accepts architecture with numbers', () {
        final platform = PlatformIdentifier(os: 'linux', architecture: 'arm64');
        expect(platform.architecture, 'arm64');
      });

      test('accepts os with hyphens', () {
        final platform = PlatformIdentifier(os: 'my-os', architecture: 'x64');
        expect(platform.os, 'my-os');
      });

      test('accepts architecture with hyphens', () {
        final platform = PlatformIdentifier(os: 'linux', architecture: 'arm-64');
        expect(platform.architecture, 'arm-64');
      });
    });
  });
}
