import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_application/src/handlers/get_available_modules_query_handler.dart';
import 'package:vscode_runtime_application/src/queries/get_available_modules_query.dart';
import 'package:vscode_runtime_application/src/dtos/module_info_dto.dart';
import 'package:vscode_runtime_application/src/exceptions/application_exception.dart';

// Mocks
class MockManifestRepository extends Mock implements IManifestRepository {}
class MockRuntimeRepository extends Mock implements IRuntimeRepository {}
class MockPlatformService extends Mock implements IPlatformService {}

void main() {
  late GetAvailableModulesQueryHandler handler;
  late MockManifestRepository mockManifestRepo;
  late MockRuntimeRepository mockRuntimeRepo;
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockManifestRepo = MockManifestRepository();
    mockRuntimeRepo = MockRuntimeRepository();
    mockPlatformService = MockPlatformService();

    handler = GetAvailableModulesQueryHandler(
      mockManifestRepo,
      mockRuntimeRepo,
      mockPlatformService,
    );
  });

  group('GetAvailableModulesQueryHandler', () {
    final platform = PlatformIdentifier.linux;
    final version = RuntimeVersion(1, 0, 0);

    final criticalModule = RuntimeModule(
      id: ModuleId('critical-module'),
      name: 'Critical Module',
      description: 'A critical module',
      type: ModuleType.runtime,
      version: version,
      supportedPlatforms: [PlatformIdentifier.linux, PlatformIdentifier.windows],
      artifacts: [
        Artifact(
          platform: PlatformIdentifier.linux,
          url: URL.fromString('https://example.com/critical.zip'),
          size: ByteSize.fromMB(10),
          checksum: SHA256Hash.fromString('a' * 64),
        ),
      ],
      dependencies: [],
      isOptional: false,
      isCritical: true,
      metadata: {},
    );

    final optionalModule = RuntimeModule(
      id: ModuleId('optional-module'),
      name: 'Optional Module',
      description: 'An optional module',
      type: ModuleType.extension,
      version: version,
      supportedPlatforms: [PlatformIdentifier.linux],
      artifacts: [
        Artifact(
          platform: PlatformIdentifier.linux,
          url: URL.fromString('https://example.com/optional.zip'),
          size: ByteSize.fromMB(5),
          checksum: SHA256Hash.fromString('b' * 64),
        ),
      ],
      dependencies: [],
      isOptional: true,
      isCritical: false,
      metadata: {},
    );

    final manifest = RuntimeManifest(
      version: version,
      modules: [criticalModule, optionalModule],
      minClientVersion: version,
    );

    group('Basic functionality', () {
      test('should return all modules when no filters applied', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));
        when(() => mockRuntimeRepo.isModuleInstalled(criticalModule.id))
            .thenAnswer((_) async => right(false));
        when(() => mockRuntimeRepo.isModuleInstalled(optionalModule.id))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            expect(dtos.length, equals(2));
            expect(dtos[0].id, equals(criticalModule.id));
            expect(dtos[1].id, equals(optionalModule.id));
            expect(dtos[0].isInstalled, isFalse);
            expect(dtos[1].isInstalled, isFalse);
          },
        );

        verify(() => mockManifestRepo.fetchManifest()).called(1);
      });

      test('should filter by platform when platformOnly is true', () async {
        // Arrange
        final query = GetAvailableModulesQuery(platformOnly: true);

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.getModules(platform))
            .thenAnswer((_) async => right([criticalModule, optionalModule]));
        when(() => mockRuntimeRepo.isModuleInstalled(any()))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockManifestRepo.getModules(platform)).called(1);
        verifyNever(() => mockManifestRepo.fetchManifest());
      });

      test('should exclude optional modules when includeOptional is false', () async {
        // Arrange
        final query = GetAvailableModulesQuery(includeOptional: false);

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));
        when(() => mockRuntimeRepo.isModuleInstalled(criticalModule.id))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            expect(dtos.length, equals(1));
            expect(dtos[0].id, equals(criticalModule.id));
            expect(dtos[0].isOptional, isFalse);
          },
        );
      });

      test('should include both when includeOptional is true', () async {
        // Arrange
        final query = GetAvailableModulesQuery(includeOptional: true);

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));
        when(() => mockRuntimeRepo.isModuleInstalled(any()))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            expect(dtos.length, equals(2));
          },
        );
      });
    });

    group('Installation status', () {
      test('should correctly mark installed modules', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));
        when(() => mockRuntimeRepo.isModuleInstalled(criticalModule.id))
            .thenAnswer((_) async => right(true));
        when(() => mockRuntimeRepo.isModuleInstalled(optionalModule.id))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            expect(dtos[0].isInstalled, isTrue);
            expect(dtos[1].isInstalled, isFalse);
          },
        );
      });

      test('should handle module installation check errors gracefully', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));
        when(() => mockRuntimeRepo.isModuleInstalled(any()))
            .thenAnswer((_) async => left(const NotFoundException('Not found')));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            // Should default to false when check fails
            expect(dtos[0].isInstalled, isFalse);
            expect(dtos[1].isInstalled, isFalse);
          },
        );
      });
    });

    group('DTO conversion', () {
      test('should create DTOs with correct platform information', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => right(manifest));
        when(() => mockRuntimeRepo.isModuleInstalled(any()))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            final dto = dtos[0];
            expect(dto.id, equals(criticalModule.id));
            expect(dto.name, equals(criticalModule.name));
            expect(dto.description, equals(criticalModule.description));
            expect(dto.type, equals(criticalModule.type));
            expect(dto.version, equals(criticalModule.version));
            expect(dto.supportedPlatforms.length, equals(2));
            expect(dto.dependencies, isEmpty);
            expect(dto.isOptional, isFalse);
            expect(dto.sizeForCurrentPlatform, isNotNull);
            expect(dto.sizeForCurrentPlatform!.bytes, equals(10 * 1024 * 1024));
          },
        );
      });
    });

    group('Error handling', () {
      test('should return error when platform detection fails', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => left(const DomainException('Platform detection failed')));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to detect platform'));
          },
          (_) => fail('Should fail'),
        );

        verifyNever(() => mockManifestRepo.fetchManifest());
      });

      test('should return error when manifest fetch fails', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.fetchManifest())
            .thenAnswer((_) async => left(const NetworkException('Network error')));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<NetworkException>());
            expect(error.message, contains('Failed to load modules'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should handle domain exceptions', () async {
        // Arrange
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
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
        final query = GetAvailableModulesQuery();

        when(() => mockPlatformService.getCurrentPlatform())
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to get available modules'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('Combined filters', () {
      test('should apply both platformOnly and includeOptional filters', () async {
        // Arrange
        final query = GetAvailableModulesQuery(
          platformOnly: true,
          includeOptional: false,
        );

        when(() => mockPlatformService.getCurrentPlatform())
            .thenAnswer((_) async => right(platform));
        when(() => mockManifestRepo.getModules(platform))
            .thenAnswer((_) async => right([criticalModule, optionalModule]));
        when(() => mockRuntimeRepo.isModuleInstalled(criticalModule.id))
            .thenAnswer((_) async => right(false));

        // Act
        final result = await handler.handle(query);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (dtos) {
            // Should only return critical module (optionals excluded)
            expect(dtos.length, equals(1));
            expect(dtos[0].id, equals(criticalModule.id));
          },
        );
      });
    });
  });
}
