import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_application/src/handlers/get_installation_progress_query_handler.dart';
import 'package:vscode_runtime_application/src/queries/get_installation_progress_query.dart';
import 'package:vscode_runtime_application/src/dtos/installation_progress_dto.dart';
import 'package:vscode_runtime_application/src/exceptions/application_exception.dart';

// Mocks
class MockRuntimeRepository extends Mock implements IRuntimeRepository {}
class MockManifestRepository extends Mock implements IManifestRepository {}

void main() {
  late GetInstallationProgressQueryHandler handler;
  late MockRuntimeRepository mockRuntimeRepo;
  late MockManifestRepository mockManifestRepo;

  setUp(() {
    mockRuntimeRepo = MockRuntimeRepository();
    mockManifestRepo = MockManifestRepository();

    handler = GetInstallationProgressQueryHandler(
      mockRuntimeRepo,
      mockManifestRepo,
    );
  });

  group('GetInstallationProgressQueryHandler', () {
    final installationId = InstallationId.generate();
    final version = RuntimeVersion(1, 0, 0);
    final moduleId1 = ModuleId('module1');
    final moduleId2 = ModuleId('module2');

    final module1 = RuntimeModule(
      id: moduleId1,
      name: 'Module 1',
      description: 'First module',
      type: ModuleType.runtime,
      version: version,
      supportedPlatforms: [PlatformIdentifier.linux],
      artifacts: [
        Artifact(
          platform: PlatformIdentifier.linux,
          url: URL.fromString('https://example.com/module1.zip'),
          size: ByteSize.fromMB(10),
          checksum: SHA256Hash.fromString('a' * 64),
        ),
      ],
      dependencies: [],
      isOptional: false,
      isCritical: true,
      metadata: {},
    );

    final module2 = RuntimeModule(
      id: moduleId2,
      name: 'Module 2',
      description: 'Second module',
      type: ModuleType.extension,
      version: version,
      supportedPlatforms: [PlatformIdentifier.linux],
      artifacts: [
        Artifact(
          platform: PlatformIdentifier.linux,
          url: URL.fromString('https://example.com/module2.zip'),
          size: ByteSize.fromMB(5),
          checksum: SHA256Hash.fromString('b' * 64),
        ),
      ],
      dependencies: [],
      isOptional: true,
      isCritical: false,
      metadata: {},
    );

    final modules = [module1, module2];

    final manifest = RuntimeManifest(
      version: version,
      modules: modules,
      minClientVersion: version,
    );

    group('Successful retrieval', () {
      test('should return installation progress for pending installation', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.installationId, equals(installationId));
            expect(dto.status, equals(InstallationStatus.pending));
            expect(dto.totalModules, equals(2));
            expect(dto.installedModules, equals(0));
            expect(dto.remainingModules.length, equals(2));
            expect(dto.overallProgress, equals(0.0));
            expect(dto.currentModule, isNull);
            expect(dto.errorMessage, isNull);
          },
        );
      });

      test('should return progress for in-progress installation', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        // Start installation
        installation.start();
        installation.startModule(moduleId1);
        installation.updateProgress(moduleId1, 0.5);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.status, equals(InstallationStatus.inProgress));
            expect(dto.currentModule, equals(moduleId1));
            expect(dto.currentModuleProgress, equals(0.5));
            expect(dto.installedModules, equals(0));
            expect(dto.remainingModules.length, equals(2));
            expect(dto.overallProgress, greaterThan(0.0));
            expect(dto.overallProgress, lessThan(1.0));
          },
        );
      });

      test('should return progress for partially completed installation', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        // Complete first module
        installation.start();
        installation.startModule(moduleId1);
        installation.completeModule(moduleId1);

        // Start second module
        installation.startModule(moduleId2);
        installation.updateProgress(moduleId2, 0.3);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.status, equals(InstallationStatus.inProgress));
            expect(dto.currentModule, equals(moduleId2));
            expect(dto.currentModuleProgress, equals(0.3));
            expect(dto.installedModules, equals(1));
            expect(dto.remainingModules.length, equals(1));
            expect(dto.remainingModules.first, equals(moduleId2));
            expect(dto.overallProgress, greaterThan(0.5));
          },
        );
      });

      test('should return progress for completed installation', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        // Complete all modules
        installation.start();
        installation.startModule(moduleId1);
        installation.completeModule(moduleId1);
        installation.startModule(moduleId2);
        installation.completeModule(moduleId2);
        installation.complete();

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.status, equals(InstallationStatus.completed));
            expect(dto.isCompleted, isTrue);
            expect(dto.hasFailed, isFalse);
            expect(dto.isInProgress, isFalse);
            expect(dto.installedModules, equals(2));
            expect(dto.remainingModules, isEmpty);
            expect(dto.overallProgress, equals(1.0));
            expect(dto.completedAt, isNotNull);
          },
        );
      });

      test('should return progress for failed installation', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        // Start and fail
        installation.start();
        installation.startModule(moduleId1);
        installation.fail('Download error');

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.status, equals(InstallationStatus.failed));
            expect(dto.hasFailed, isTrue);
            expect(dto.isCompleted, isFalse);
            expect(dto.errorMessage, equals('Download error'));
            expect(dto.completedAt, isNotNull);
          },
        );
      });

      test('should return progress for cancelled installation', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        // Start and cancel
        installation.start();
        installation.startModule(moduleId1);
        installation.cancel();

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.status, equals(InstallationStatus.cancelled));
            expect(dto.hasFailed, isFalse);
            expect(dto.isCompleted, isFalse);
            expect(dto.isInProgress, isFalse);
          },
        );
      });
    });

    group('Error handling', () {
      test('should return error when installation not found', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(none()));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<NotFoundException>());
            expect(error.message, contains('Installation not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should return error when manifest fetch fails', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => left(const NetworkException('Network error')));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to load manifest'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should return error when loading installation fails', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => left(const FileSystemException('Read error')));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to load installation'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should handle domain exceptions', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        when(() => mockManifestRepo.fetchManifest())
            .thenThrow(const DomainException('Domain error'));

        // Act
        final result = await handler.handle(query);

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
        final query = GetInstallationProgressQuery(installationId);

        when(() => mockManifestRepo.fetchManifest())
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to get installation progress'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('DTO conversion', () {
      test('should correctly convert installation to DTO', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.automatic,
        );

        installation.start();
        installation.startModule(moduleId1);
        installation.updateProgress(moduleId1, 0.75);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            // Verify all fields are mapped correctly
            expect(dto.installationId, equals(installation.id));
            expect(dto.status, equals(installation.status));
            expect(dto.totalModules, equals(installation.modules.length));
            expect(dto.installedModules, equals(installation.installedModules.length));
            expect(dto.currentModule, equals(installation.currentModule));
            expect(dto.currentModuleProgress, equals(installation.progress));
            expect(dto.startedAt, equals(installation.createdAt));
          },
        );
      });

      test('should include status message', () async {
        // Arrange
        final query = GetInstallationProgressQuery(installationId);

        final installation = RuntimeInstallation.create(
          id: installationId,
          modules: modules,
          version: version,
          trigger: InstallationTrigger.manual,
        );

        installation.start();
        installation.startModule(moduleId1);

        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));

        when(() => mockRuntimeRepo.loadInstallation(installationId, modules))
            .thenAnswer((_) async => right(some(installation)));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dto) {
            expect(dto.statusMessage, isNotEmpty);
            expect(dto.statusMessage, contains(moduleId1.value));
          },
        );
      });
    });
  });
}
