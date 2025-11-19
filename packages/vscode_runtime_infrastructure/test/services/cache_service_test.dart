import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vscode_runtime_infrastructure/src/services/cache_service.dart';
import 'package:vscode_runtime_infrastructure/src/services/logging_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockLoggingService extends Mock implements LoggingService {}

void main() {
  late CacheService cacheService;
  late MockSharedPreferences mockPrefs;
  late MockLoggingService mockLogger;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockLogger = MockLoggingService();
    cacheService = CacheService(
      prefs: mockPrefs,
      logger: mockLogger,
      keyPrefix: 'test_',
    );
  });

  group('CacheService', () {
    group('get', () {
      test('should return null when key does not exist', () async {
        // Arrange
        when(() => mockPrefs.getString('test_mykey')).thenReturn(null);
        when(() => mockLogger.debug(any())).thenReturn(null);

        // Act
        final result = await cacheService.get<String>(
          'mykey',
          deserializer: (s) => s,
        );

        // Assert
        expect(result, isNull);
        verify(() => mockPrefs.getString('test_mykey')).called(1);
        verify(() => mockLogger.debug('Cache miss: mykey')).called(1);
      });

      test('should return null and remove when entry is expired', () async {
        // Arrange
        final expiredTime = DateTime.now().toUtc().subtract(const Duration(hours: 1));
        final jsonString = '{"value":"testvalue","expiresAt":"${expiredTime.toIso8601String()}"}';

        when(() => mockPrefs.getString('test_mykey')).thenReturn(jsonString);
        when(() => mockPrefs.remove('test_mykey')).thenAnswer((_) async => true);
        when(() => mockLogger.debug(any())).thenReturn(null);

        // Act
        final result = await cacheService.get<String>(
          'mykey',
          deserializer: (s) => s,
        );

        // Assert
        expect(result, isNull);
        verify(() => mockPrefs.getString('test_mykey')).called(1);
        verify(() => mockPrefs.remove('test_mykey')).called(1);
        verify(() => mockLogger.debug(any())).called(2); // miss + expired
      });

      test('should return value when entry is valid', () async {
        // Arrange
        final futureTime = DateTime.now().toUtc().add(const Duration(hours: 1));
        final jsonString = '{"value":"testvalue","expiresAt":"${futureTime.toIso8601String()}"}';

        when(() => mockPrefs.getString('test_mykey')).thenReturn(jsonString);
        when(() => mockLogger.debug(any())).thenReturn(null);

        // Act
        final result = await cacheService.get<String>(
          'mykey',
          deserializer: (s) => s,
        );

        // Assert
        expect(result, equals('testvalue'));
        verify(() => mockPrefs.getString('test_mykey')).called(1);
        verify(() => mockLogger.debug('Cache hit: mykey')).called(1);
      });
    });

    group('set', () {
      test('should store value with TTL', () async {
        // Arrange
        when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
        when(() => mockLogger.debug(any())).thenReturn(null);

        // Act
        final result = await cacheService.set<String>(
          'mykey',
          'myvalue',
          serializer: (s) => s,
          ttl: const Duration(hours: 24),
        );

        // Assert
        expect(result, isTrue);
        verify(() => mockPrefs.setString('test_mykey', any())).called(1);
        verify(() => mockLogger.debug(any())).called(1);
      });

      test('should return false when storage fails', () async {
        // Arrange
        when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => false);
        when(() => mockLogger.warning(any())).thenReturn(null);

        // Act
        final result = await cacheService.set<String>(
          'mykey',
          'myvalue',
          serializer: (s) => s,
        );

        // Assert
        expect(result, isFalse);
        verify(() => mockLogger.warning('Failed to cache: mykey')).called(1);
      });
    });

    group('remove', () {
      test('should remove value from cache', () async {
        // Arrange
        when(() => mockPrefs.remove('test_mykey')).thenAnswer((_) async => true);
        when(() => mockLogger.debug(any())).thenReturn(null);

        // Act
        final result = await cacheService.remove('mykey');

        // Assert
        expect(result, isTrue);
        verify(() => mockPrefs.remove('test_mykey')).called(1);
        verify(() => mockLogger.debug('Removed from cache: mykey')).called(1);
      });
    });

    group('clearAll', () {
      test('should clear all entries with prefix', () async {
        // Arrange
        when(() => mockPrefs.getKeys()).thenReturn({
          'test_key1',
          'test_key2',
          'other_key',
        });
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
        when(() => mockLogger.info(any())).thenReturn(null);

        // Act
        final result = await cacheService.clearAll();

        // Assert
        expect(result, isTrue);
        verify(() => mockPrefs.remove('test_key1')).called(1);
        verify(() => mockPrefs.remove('test_key2')).called(1);
        verifyNever(() => mockPrefs.remove('other_key')); // Should not remove different prefix
        verify(() => mockLogger.info('Cleared all cache entries (2 items)')).called(1);
      });
    });

    group('removeExpired', () {
      test('should remove only expired entries', () async {
        // Arrange
        final expiredTime = DateTime.now().toUtc().subtract(const Duration(hours: 1));
        final validTime = DateTime.now().toUtc().add(const Duration(hours: 1));

        final expiredJson = '{"value":"expired","expiresAt":"${expiredTime.toIso8601String()}"}';
        final validJson = '{"value":"valid","expiresAt":"${validTime.toIso8601String()}"}';

        when(() => mockPrefs.getKeys()).thenReturn({'test_expired', 'test_valid'});
        when(() => mockPrefs.getString('test_expired')).thenReturn(expiredJson);
        when(() => mockPrefs.getString('test_valid')).thenReturn(validJson);
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
        when(() => mockLogger.info(any())).thenReturn(null);

        // Act
        final result = await cacheService.removeExpired();

        // Assert
        expect(result, equals(1)); // Only 1 expired
        verify(() => mockPrefs.remove('test_expired')).called(1);
        verifyNever(() => mockPrefs.remove('test_valid')); // Should not remove valid entry
        verify(() => mockLogger.info('Removed 1 expired cache entries')).called(1);
      });
    });

    group('getStats', () {
      test('should return cache statistics', () async {
        // Arrange
        final expiredTime = DateTime.now().toUtc().subtract(const Duration(hours: 1));
        final validTime = DateTime.now().toUtc().add(const Duration(hours: 1));

        final expiredJson = '{"value":"expired","expiresAt":"${expiredTime.toIso8601String()}"}';
        final validJson1 = '{"value":"valid1","expiresAt":"${validTime.toIso8601String()}"}';
        final validJson2 = '{"value":"valid2","expiresAt":"${validTime.toIso8601String()}"}';

        when(() => mockPrefs.getKeys()).thenReturn({
          'test_expired',
          'test_valid1',
          'test_valid2',
        });
        when(() => mockPrefs.getString('test_expired')).thenReturn(expiredJson);
        when(() => mockPrefs.getString('test_valid1')).thenReturn(validJson1);
        when(() => mockPrefs.getString('test_valid2')).thenReturn(validJson2);

        // Act
        final stats = await cacheService.getStats();

        // Assert
        expect(stats['total'], equals(3));
        expect(stats['valid'], equals(2));
        expect(stats['expired'], equals(1));
      });
    });
  });
}
