import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_application/src/handlers/check_runtime_updates_command_handler.dart';
import 'package:vscode_runtime_application/src/commands/check_runtime_updates_command.dart';
import 'package:vscode_runtime_application/src/dtos/runtime_status_dto.dart';
import 'package:vscode_runtime_application/src/exceptions/application_exception.dart';

// Mocks
class MockRuntimeRepository extends Mock implements IRuntimeRepository {}
class MockManifestRepository extends Mock implements IManifestRepository {}

void main() {
  late CheckRuntimeUpdatesCommandHandler handler;
  late MockRuntimeRepository mockRuntimeRepo;
  late MockManifestRepository mockManifestRepo;

  setUp(() {
    mockRuntimeRepo = MockRuntimeRepository();
    mockManifestRepo = MockManifestRepository();

    handler = CheckRuntimeUpdatesCommandHandler(
      mockRuntimeRepo,
      mockManifestRepo,
    );
  });

  group('CheckRuntimeUpdatesCommandHandler', () {
    final installedVersion = RuntimeVersion(1, 0, 0);
    final newerVersion = RuntimeVersion(1, 1, 0);
    final moduleId = ModuleId('test-module');

    final installedModule = RuntimeModule(
      id: moduleId,
      name: 'Test Module',
      description: 'Test',
      type: ModuleType.runtime,
      version: installedVersion,
      supportedPlatforms: [PlatformIdentifier.linux],
      artifacts: [
        Artifact(
          platform: PlatformIdentifier.linux,
          url: URL.fromString('https://example.com/test.zip'),
          size: ByteSize.fromMB(10),
          checksum: SHA256Hash.fromString('a' * 64),
        ),
      ],
      dependencies: [],
      isOptional: false,
      isCritical: true,
      metadata: {},
    );

    final newerModule = RuntimeModule(
      id: moduleId,
      name: 'Test Module',
      description: 'Test',
      type: ModuleType.runtime,
      version: newerVersion,
      supportedPlatforms: [PlatformIdentifier.linux],
      artifacts: [
        Artifact(
          platform: PlatformIdentifier.linux,
          url: URL.fromString('https://example.com/test-new.zip'),
          size: ByteSize.fromMB(10),
          checksum: SHA256Hash.fromString('b' * 64),
        ),
      ],
      dependencies: [],
      isOptional: false,
      isCritical: true,
      metadata: {},
    );

    group('When runtime not installed', () {
      test('should return not installed status', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(none()));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.isNotInstalled, isTrue);
            expect(dto.isInstalled, isFalse);
          },
        );

        verifyNever(() => mockManifestRepo.fetchManifest());
      });
    });

    group('When update available', () {
      test('should return update available status', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final manifest = RuntimeManifest(
          version: newerVersion,
          modules: [newerModule],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.isUpdateAvailable, isTrue);
            expect(dto.currentVersion, equals(installedVersion));
            expect(dto.availableVersion, equals(newerVersion));
          },
        );
      });

      test('should detect newer major version', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();
        final majorVersion = RuntimeVersion(2, 0, 0);

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final majorModule = RuntimeModule(
          id: moduleId,
          name: 'Test Module',
          description: 'Test',
          type: ModuleType.runtime,
          version: majorVersion,
          supportedPlatforms: [PlatformIdentifier.linux],
          artifacts: [
            Artifact(
              platform: PlatformIdentifier.linux,
              url: URL.fromString('https://example.com/test.zip'),
              size: ByteSize.fromMB(10),
              checksum: SHA256Hash.fromString('c' * 64),
            ),
          ],
          dependencies: [],
          isOptional: false,
          isCritical: true,
          metadata: {},
        );

        final manifest = RuntimeManifest(
          version: majorVersion,
          modules: [majorModule],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.isUpdateAvailable, isTrue);
            expect(dto.availableVersion?.major, equals(2));
          },
        );
      });

      test('should detect newer minor version', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();
        final minorVersion = RuntimeVersion(1, 2, 0);

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final minorModule = RuntimeModule(
          id: moduleId,
          name: 'Test Module',
          description: 'Test',
          type: ModuleType.runtime,
          version: minorVersion,
          supportedPlatforms: [PlatformIdentifier.linux],
          artifacts: [
            Artifact(
              platform: PlatformIdentifier.linux,
              url: URL.fromString('https://example.com/test.zip'),
              size: ByteSize.fromMB(10),
              checksum: SHA256Hash.fromString('d' * 64),
            ),
          ],
          dependencies: [],
          isOptional: false,
          isCritical: true,
          metadata: {},
        );

        final manifest = RuntimeManifest(
          version: minorVersion,
          modules: [minorModule],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.isUpdateAvailable, isTrue);
            expect(dto.availableVersion?.minor, equals(2));
          },
        );
      });

      test('should detect newer patch version', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();
        final patchVersion = RuntimeVersion(1, 0, 1);

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final patchModule = RuntimeModule(
          id: moduleId,
          name: 'Test Module',
          description: 'Test',
          type: ModuleType.runtime,
          version: patchVersion,
          supportedPlatforms: [PlatformIdentifier.linux],
          artifacts: [
            Artifact(
              platform: PlatformIdentifier.linux,
              url: URL.fromString('https://example.com/test.zip'),
              size: ByteSize.fromMB(10),
              checksum: SHA256Hash.fromString('e' * 64),
            ),
          ],
          dependencies: [],
          isOptional: false,
          isCritical: true,
          metadata: {},
        );

        final manifest = RuntimeManifest(
          version: patchVersion,
          modules: [patchModule],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.isUpdateAvailable, isTrue);
            expect(dto.availableVersion?.patch, equals(1));
          },
        );
      });
    });

    group('When up to date', () {
      test('should return installed status when same version', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final manifest = RuntimeManifest(
          version: installedVersion,
          modules: [installedModule],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.isModuleInstalled(moduleId))
            .thenAnswer((_) async => right(true));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.isInstalled, isTrue);
            expect(dto.isUpdateAvailable, isFalse);
            expect(dto.version, equals(installedVersion));
            expect(dto.installedModules?.length, equals(1));
            expect(dto.installedModules?.first, equals(moduleId));
          },
        );
      });

      test('should collect all installed modules', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();
        final moduleId2 = ModuleId('another-module');

        final module2 = RuntimeModule(
          id: moduleId2,
          name: 'Another Module',
          description: 'Test',
          type: ModuleType.extension,
          version: installedVersion,
          supportedPlatforms: [PlatformIdentifier.linux],
          artifacts: [
            Artifact(
              platform: PlatformIdentifier.linux,
              url: URL.fromString('https://example.com/another.zip'),
              size: ByteSize.fromMB(5),
              checksum: SHA256Hash.fromString('f' * 64),
            ),
          ],
          dependencies: [],
          isOptional: true,
          isCritical: false,
          metadata: {},
        );

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final manifest = RuntimeManifest(
          version: installedVersion,
          modules: [installedModule, module2],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.isModuleInstalled(moduleId))
            .thenAnswer((_) async => right(true));
        when(() => mockRuntimeRepo.isModuleInstalled(moduleId2))
            .thenAnswer((_) async => right(true));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.installedModules?.length, equals(2));
            expect(dto.installedModules, contains(moduleId));
            expect(dto.installedModules, contains(moduleId2));
          },
        );
      });

      test('should handle partially installed modules', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();
        final moduleId2 = ModuleId('not-installed');

        final module2 = RuntimeModule(
          id: moduleId2,
          name: 'Not Installed',
          description: 'Test',
          type: ModuleType.extension,
          version: installedVersion,
          supportedPlatforms: [PlatformIdentifier.linux],
          artifacts: [
            Artifact(
              platform: PlatformIdentifier.linux,
              url: URL.fromString('https://example.com/notinstalled.zip'),
              size: ByteSize.fromMB(5),
              checksum: SHA256Hash.fromString('g' * 64),
            ),
          ],
          dependencies: [],
          isOptional: true,
          isCritical: false,
          metadata: {},
        );

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final manifest = RuntimeManifest(
          version: installedVersion,
          modules: [installedModule, module2],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.isModuleInstalled(moduleId))
            .thenAnswer((_) async => right(true));
        when(() => mockRuntimeRepo.isModuleInstalled(moduleId2))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.installedModules?.length, equals(1));
            expect(dto.installedModules, contains(moduleId));
            expect(dto.installedModules, isNot(contains(moduleId2)));
          },
        );
      });
    });

    group('Error handling', () {
      test('should return error when getting installed version fails', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => left(const FileSystemException('Permission denied')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to get installed version'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should return error when fetching manifest fails', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => left(const NetworkException('Network error')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<NetworkException>());
            expect(error.message, contains('Failed to fetch manifest'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should return error when manifest has no modules', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenAnswer((_) async => right(some(installedVersion)));

        final emptyManifest = RuntimeManifest(
          version: installedVersion,
          modules: [],
          minClientVersion: RuntimeVersion(1, 0, 0),
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(emptyManifest));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('No modules in manifest'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should handle domain exceptions', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenThrow(const DomainException('Domain error'));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Domain error'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should handle unexpected exceptions', () async {
        // Arrange
        final command = CheckRuntimeUpdatesCommand();

        when(() => mockRuntimeRepo.getInstalledVersion())
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to check for updates'));
          },
          (_) => fail('Should fail'),
        );
      });
    });
  });
}
