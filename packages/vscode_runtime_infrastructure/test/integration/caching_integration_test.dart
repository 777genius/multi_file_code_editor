import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vscode_runtime_infrastructure/src/services/cache_service.dart';
import 'package:vscode_runtime_infrastructure/src/services/logging_service.dart';
import 'package:vscode_runtime_infrastructure/src/repositories/manifest_repository.dart';
import 'package:vscode_runtime_infrastructure/src/data_sources/manifest_data_source.dart';
import 'package:vscode_runtime_infrastructure/src/models/manifest_dto.dart';

class MockManifestDataSource extends Mock implements ManifestDataSource {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Caching Integration Test', () {
    test('should demonstrate 3-tier caching strategy end-to-end', () async {
      // Arrange - Create real services with mocked dependencies
      final mockDataSource = MockManifestDataSource();
      final mockPrefs = MockSharedPreferences();

      final logger = LoggingService(
        logLevel: Level.warning, // Reduce noise in tests
        enableColors: false,
      );

      final cacheService = CacheService(
        prefs: mockPrefs,
        logger: logger,
        keyPrefix: 'test_',
      );

      final repository = ManifestRepository(
        mockDataSource,
        cacheService: cacheService,
        logger: logger,
      );

      final manifestDto = ManifestDto(
        version: '1.0.0',
        modules: [
          ModuleDto(
            id: 'core',
            name: 'Core Module',
            description: 'Core runtime',
            version: '1.0.0',
            required: true,
            dependencies: [],
            platforms: ['linux', 'windows', 'macos'],
            artifacts: [],
          ),
        ],
      );

      // Mock data source - only called on first fetch
      when(() => mockDataSource.fetchManifest()).thenAnswer(
        (_) async => manifestDto,
      );

      // Mock SharedPreferences
      when(() => mockPrefs.getString(any())).thenReturn(null); // No persistent cache initially
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getKeys()).thenReturn(<String>{});

      // Act - Phase 1: First fetch (network)
      print('\n=== Phase 1: First Fetch (Network) ===');
      final result1 = await repository.fetchManifest();

      // Assert Phase 1
      expect(result1.isRight(), isTrue);
      verify(() => mockDataSource.fetchManifest()).called(1); // Network called
      verify(() => mockPrefs.getString('test_runtime_manifest')).called(1); // Checked persistent cache
      verify(() => mockPrefs.setString('test_runtime_manifest', any())).called(1); // Saved to persistent cache

      // Act - Phase 2: Second fetch (in-memory cache)
      print('\n=== Phase 2: Second Fetch (In-Memory Cache) ===');
      final result2 = await repository.fetchManifest();

      // Assert Phase 2
      expect(result2.isRight(), isTrue);
      verify(() => mockDataSource.fetchManifest()).called(1); // Still only called once!
      // No additional persistent cache calls because in-memory cache hit

      // Act - Phase 3: Clear in-memory, fetch from persistent cache
      print('\n=== Phase 3: Clear In-Memory, Fetch from Persistent ===');

      // Simulate persistent cache having data
      final futureTime = DateTime.now().toUtc().add(const Duration(hours: 1));
      final cachedJson = '{"value":"{\\"version\\":\\"1.0.0\\",\\"modules\\":[]}","expiresAt":"${futureTime.toIso8601String()}"}';

      when(() => mockPrefs.getString('test_runtime_manifest')).thenReturn(cachedJson);

      // Create new repository instance (simulates app restart, loses in-memory cache)
      final newRepository = ManifestRepository(
        mockDataSource,
        cacheService: cacheService,
        logger: logger,
      );

      final result3 = await newRepository.fetchManifest();

      // Assert Phase 3
      expect(result3.isRight(), isTrue);
      verify(() => mockDataSource.fetchManifest()).called(1); // Still only called once from Phase 1!
      verify(() => mockPrefs.getString('test_runtime_manifest')).called(greaterThanOrEqualTo(2)); // Persistent cache checked

      // Act - Phase 4: Clear all caches, force network fetch
      print('\n=== Phase 4: Clear All Caches, Force Network ===');

      when(() => mockPrefs.getString('test_runtime_manifest')).thenReturn(null);
      when(() => mockPrefs.remove('test_runtime_manifest')).thenAnswer((_) async => true);

      await newRepository.clearCache();

      final result4 = await newRepository.fetchManifest();

      // Assert Phase 4
      expect(result4.isRight(), isTrue);
      verify(() => mockDataSource.fetchManifest()).called(2); // Now called twice (Phase 1 and Phase 4)
      verify(() => mockPrefs.remove('test_runtime_manifest')).called(1); // Cache cleared

      print('\n=== Test Complete: 3-Tier Caching Verified ===');
      print('Network fetches: 2 (optimal - only when necessary)');
      print('Persistent cache reads: ${verify(() => mockPrefs.getString('test_runtime_manifest')).callCount}');
      print('In-memory cache hits: Phase 2 (fast path)');
    });

    test('should handle cache expiration correctly', () async {
      // Arrange
      final mockDataSource = MockManifestDataSource();
      final mockPrefs = MockSharedPreferences();
      final logger = LoggingService(logLevel: Level.warning, enableColors: false);
      final cacheService = CacheService(prefs: mockPrefs, logger: logger);
      final repository = ManifestRepository(
        mockDataSource,
        cacheService: cacheService,
        logger: logger,
      );

      final manifestDto = ManifestDto(version: '1.0.0', modules: []);

      // Simulate expired cache
      final expiredTime = DateTime.now().toUtc().subtract(const Duration(hours: 25)); // Expired (> 24h)
      final expiredJson = '{"value":"{\\"version\\":\\"1.0.0\\",\\"modules\\":[]}","expiresAt":"${expiredTime.toIso8601String()}"}';

      when(() => mockPrefs.getString(any())).thenReturn(expiredJson);
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockDataSource.fetchManifest()).thenAnswer((_) async => manifestDto);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Act - Fetch should ignore expired cache and go to network
      final result = await repository.fetchManifest();

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockDataSource.fetchManifest()).called(1); // Network called because cache expired
      verify(() => mockPrefs.remove(any())).called(1); // Expired cache removed
    });

    test('should demonstrate cache statistics tracking', () async {
      // Arrange
      final mockPrefs = MockSharedPreferences();
      final logger = LoggingService(logLevel: Level.warning, enableColors: false);
      final cacheService = CacheService(prefs: mockPrefs, logger: logger, keyPrefix: 'test_');

      final futureTime = DateTime.now().toUtc().add(const Duration(hours: 1));
      final expiredTime = DateTime.now().toUtc().subtract(const Duration(hours: 1));

      final validJson1 = '{"value":"value1","expiresAt":"${futureTime.toIso8601String()}"}';
      final validJson2 = '{"value":"value2","expiresAt":"${futureTime.toIso8601String()}"}';
      final expiredJson = '{"value":"expired","expiresAt":"${expiredTime.toIso8601String()}"}';

      when(() => mockPrefs.getKeys()).thenReturn({
        'test_valid1',
        'test_valid2',
        'test_expired',
        'other_key', // Different prefix, should be ignored
      });
      when(() => mockPrefs.getString('test_valid1')).thenReturn(validJson1);
      when(() => mockPrefs.getString('test_valid2')).thenReturn(validJson2);
      when(() => mockPrefs.getString('test_expired')).thenReturn(expiredJson);

      // Act - Get statistics
      final stats = await cacheService.getStats();

      // Assert
      expect(stats['total'], equals(3)); // Only 'test_' prefixed keys
      expect(stats['valid'], equals(2));
      expect(stats['expired'], equals(1));

      // Act - Remove expired entries
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      final removedCount = await cacheService.removeExpired();

      // Assert
      expect(removedCount, equals(1));
      verify(() => mockPrefs.remove('test_expired')).called(1);
      verifyNever(() => mockPrefs.remove('test_valid1'));
      verifyNever(() => mockPrefs.remove('test_valid2'));
    });
  });
}
