import 'package:test/test.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_application/src/dtos/platform_info_dto.dart';

void main() {
  group('PlatformInfoDto', () {
    test('should create DTO with all required fields', () {
      // Arrange & Act
      final dto = PlatformInfoDto(
        identifier: PlatformIdentifier.linux,
        osName: 'Linux',
        osVersion: '5.15.0',
        architecture: 'x86_64',
        numberOfProcessors: 8,
        availableDiskSpace: ByteSize.fromGB(100),
        hasRequiredPermissions: true,
        isSupported: true,
      );

      // Assert
      expect(dto.identifier, equals(PlatformIdentifier.linux));
      expect(dto.osName, equals('Linux'));
      expect(dto.osVersion, equals('5.15.0'));
      expect(dto.architecture, equals('x86_64'));
      expect(dto.numberOfProcessors, equals(8));
      expect(dto.availableDiskSpace.gb, equals(100));
      expect(dto.hasRequiredPermissions, isTrue);
      expect(dto.isSupported, isTrue);
    });

    group('hasSufficientSpace', () {
      test('should return true when disk space >= 1GB', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.hasSufficientSpace, isTrue);
      });

      test('should return true when disk space exactly 1GB', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(1),
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.hasSufficientSpace, isTrue);
      });

      test('should return false when disk space < 1GB', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromMB(500), // 0.5GB
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.hasSufficientSpace, isFalse);
      });
    });

    group('canInstallRuntime', () {
      test('should return true when all conditions met', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.canInstallRuntime, isTrue);
      });

      test('should return false when platform not supported', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: true,
          isSupported: false, // Not supported
        );

        // Act & Assert
        expect(dto.canInstallRuntime, isFalse);
      });

      test('should return false when insufficient permissions', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: false, // No permissions
          isSupported: true,
        );

        // Act & Assert
        expect(dto.canInstallRuntime, isFalse);
      });

      test('should return false when insufficient disk space', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromMB(500), // < 1GB
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.canInstallRuntime, isFalse);
      });
    });

    group('installationWarning', () {
      test('should return null when installation can proceed', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.installationWarning, isNull);
      });

      test('should return warning when platform not supported', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: true,
          isSupported: false,
        );

        // Act & Assert
        expect(dto.installationWarning, isNotNull);
        expect(dto.installationWarning, contains('not supported'));
      });

      test('should return warning when insufficient permissions', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: false,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.installationWarning, isNotNull);
        expect(dto.installationWarning, contains('permissions'));
      });

      test('should return warning when insufficient disk space', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromMB(500),
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.installationWarning, isNotNull);
        expect(dto.installationWarning, contains('disk space'));
      });

      test('should prioritize platform support warning', () {
        // Arrange - multiple issues, but platform support is first
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromMB(500), // Also insufficient
          hasRequiredPermissions: false, // Also no permissions
          isSupported: false, // Not supported
        );

        // Act & Assert
        expect(dto.installationWarning, contains('not supported'));
      });
    });

    group('displayString', () {
      test('should return display string for platform', () {
        // Arrange
        final dto = PlatformInfoDto(
          identifier: PlatformIdentifier.linux,
          osName: 'Linux',
          osVersion: '5.15.0',
          architecture: 'x86_64',
          numberOfProcessors: 8,
          availableDiskSpace: ByteSize.fromGB(10),
          hasRequiredPermissions: true,
          isSupported: true,
        );

        // Act & Assert
        expect(dto.displayString, isNotNull);
        expect(dto.displayString.isNotEmpty, isTrue);
      });
    });
  });
}
