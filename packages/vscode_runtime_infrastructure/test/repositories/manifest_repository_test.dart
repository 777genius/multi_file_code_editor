import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_infrastructure/src/repositories/manifest_repository.dart';
import 'package:vscode_runtime_infrastructure/src/data_sources/manifest_data_source.dart';
import 'package:vscode_runtime_infrastructure/src/services/cache_service.dart';
import 'package:vscode_runtime_infrastructure/src/services/logging_service.dart';
import 'package:vscode_runtime_infrastructure/src/models/manifest_dto.dart';

class MockManifestDataSource extends Mock implements ManifestDataSource {}
class MockCacheService extends Mock implements CacheService {}
class MockLoggingService extends Mock implements LoggingService {}

void main() {
  late ManifestRepository repository;
  late MockManifestDataSource mockDataSource;
  late MockCacheService mockCacheService;
  late MockLoggingService mockLogger;

  setUp(() {
    mockDataSource = MockManifestDataSource();
    mockCacheService = MockCacheService();
    mockLogger = MockLoggingService();

    repository = ManifestRepository(
      mockDataSource,
      cacheService: mockCacheService,
      logger: mockLogger,
    );

    when(() => mockLogger.debug(any())).thenReturn(null);
    when(() => mockLogger.info(any())).thenReturn(null);
    when(() => mockLogger.error(any(), any(), any())).thenReturn(null);
  });

  group('ManifestRepository', () {
    group('fetchManifest - 3-tier caching', () {
      test('should return from in-memory cache first', () async {
        // Arrange
        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [],
        );

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);
        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);

        // First call - fetches from network
        await repository.fetchManifest();

        // Act - Second call should use in-memory cache
        final result = await repository.fetchManifest();

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockDataSource.fetchManifest()).called(1); // Only called once
        verify(() => mockLogger.debug('Returning manifest from in-memory cache')).called(1);
      });

      test('should return from persistent cache when no in-memory cache', () async {
        // Arrange
        final manifest = RuntimeManifest(
          version: RuntimeVersion(1, 0, 0),
          modules: [],
        );

        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => manifest);

        // Act
        final result = await repository.fetchManifest();

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCacheService.get<RuntimeManifest>(
          'runtime_manifest',
          deserializer: any(named: 'deserializer'),
        )).called(1);
        verify(() => mockLogger.info('Returning manifest from persistent cache')).called(1);
        verifyNever(() => mockDataSource.fetchManifest()); // Should not fetch from network
      });

      test('should fetch from network when no cache available', () async {
        // Arrange
        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [],
        );

        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => null);

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);

        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);

        // Act
        final result = await repository.fetchManifest();

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockDataSource.fetchManifest()).called(1);
        verify(() => mockLogger.info('Fetching fresh manifest from network')).called(1);
        verify(() => mockCacheService.set<RuntimeManifest>(
          'runtime_manifest',
          any(),
          serializer: any(named: 'serializer'),
          ttl: const Duration(hours: 24),
        )).called(1);
      });

      test('should update both caches after network fetch', () async {
        // Arrange
        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [],
        );

        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => null);

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);

        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);

        // Act
        await repository.fetchManifest();

        // Second call should use in-memory cache
        final result = await repository.fetchManifest();

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockDataSource.fetchManifest()).called(1); // Only once
        verify(() => mockLogger.debug('Returning manifest from in-memory cache')).called(1);
      });

      test('should return error when network fetch fails', () async {
        // Arrange
        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => null);

        when(() => mockDataSource.fetchManifest()).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.fetchManifest();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<DomainException>());
            expect(error.message, contains('Failed to fetch manifest'));
          },
          (_) => fail('Should return error'),
        );
        verify(() => mockLogger.error('Failed to fetch manifest', any(), any())).called(1);
      });
    });

    group('getCachedManifest', () {
      test('should return in-memory cache if available', () async {
        // Arrange
        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [],
        );

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);
        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);

        // Populate in-memory cache
        await repository.fetchManifest();

        // Act
        final result = await repository.getCachedManifest();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return manifest'),
          (option) => expect(option.isSome(), isTrue),
        );
      });

      test('should return persistent cache if no in-memory cache', () async {
        // Arrange
        final manifest = RuntimeManifest(
          version: RuntimeVersion(1, 0, 0),
          modules: [],
        );

        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => manifest);

        // Act
        final result = await repository.getCachedManifest();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return manifest'),
          (option) => expect(option.isSome(), isTrue),
        );
      });

      test('should return none when no cache available', () async {
        // Arrange
        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCachedManifest();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return none option'),
          (option) => expect(option.isNone(), isTrue),
        );
      });
    });

    group('getModules', () {
      test('should return all modules when no platform specified', () async {
        // Arrange
        final module1 = RuntimeModule(
          id: ModuleId('module1'),
          name: 'Module 1',
          description: 'Test module 1',
          version: RuntimeVersion(1, 0, 0),
          isRequired: true,
          isCritical: true,
          dependencies: [],
          supportedPlatforms: [PlatformIdentifier.linux],
          artifacts: [],
        );

        final module2 = RuntimeModule(
          id: ModuleId('module2'),
          name: 'Module 2',
          description: 'Test module 2',
          version: RuntimeVersion(1, 0, 0),
          isRequired: false,
          isCritical: false,
          dependencies: [],
          supportedPlatforms: [PlatformIdentifier.windows],
          artifacts: [],
        );

        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [
            ModuleDto(
              id: 'module1',
              name: 'Module 1',
              description: 'Test module 1',
              version: '1.0.0',
              required: true,
              dependencies: [],
              platforms: ['linux'],
              artifacts: [],
            ),
            ModuleDto(
              id: 'module2',
              name: 'Module 2',
              description: 'Test module 2',
              version: '1.0.0',
              required: false,
              dependencies: [],
              platforms: ['windows'],
              artifacts: [],
            ),
          ],
        );

        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => null);

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);

        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);

        // Act
        final result = await repository.getModules();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return modules'),
          (modules) => expect(modules.length, equals(2)),
        );
      });

      test('should filter modules by platform', () async {
        // Arrange
        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [
            ModuleDto(
              id: 'module1',
              name: 'Module 1',
              description: 'Linux module',
              version: '1.0.0',
              required: true,
              dependencies: [],
              platforms: ['linux'],
              artifacts: [],
            ),
            ModuleDto(
              id: 'module2',
              name: 'Module 2',
              description: 'Windows module',
              version: '1.0.0',
              required: false,
              dependencies: [],
              platforms: ['windows'],
              artifacts: [],
            ),
          ],
        );

        when(() => mockCacheService.get<RuntimeManifest>(
          any(),
          deserializer: any(named: 'deserializer'),
        )).thenAnswer((_) async => null);

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);

        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);

        // Act
        final result = await repository.getModules(PlatformIdentifier.linux);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should return filtered modules'),
          (modules) {
            expect(modules.length, equals(1));
            expect(modules.first.id.value, equals('module1'));
          },
        );
      });
    });

    group('clearCache', () {
      test('should clear both in-memory and persistent cache', () async {
        // Arrange
        final manifestDto = ManifestDto(
          version: '1.0.0',
          modules: [],
        );

        when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);
        when(() => mockCacheService.set<RuntimeManifest>(
          any(),
          any(),
          serializer: any(named: 'serializer'),
          ttl: any(named: 'ttl'),
        )).thenAnswer((_) async => true);
        when(() => mockCacheService.remove(any())).thenAnswer((_) async => true);

        // Populate cache
        await repository.fetchManifest();

        // Act
        await repository.clearCache();

        // Assert
        verify(() => mockCacheService.remove('runtime_manifest')).called(1);
        verify(() => mockLogger.info('Manifest cache cleared')).called(1);

        // Next fetch should go to network
        final result = await repository.fetchManifest();
        expect(result.isRight(), isTrue);
        verify(() => mockDataSource.fetchManifest()).called(2); // Once before clear, once after
      });
    });
  });
}
