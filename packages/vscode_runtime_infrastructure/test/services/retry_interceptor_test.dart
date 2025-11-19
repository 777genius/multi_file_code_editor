import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:vscode_runtime_infrastructure/src/services/retry_interceptor.dart';
import 'package:vscode_runtime_infrastructure/src/services/logging_service.dart';

class MockLoggingService extends Mock implements LoggingService {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}
class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late RetryInterceptor interceptor;
  late MockLoggingService mockLogger;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockLogger = MockLoggingService();
    interceptor = RetryInterceptor(
      maxRetries: 3,
      initialDelay: const Duration(milliseconds: 100),
      backoffMultiplier: 2.0,
      logger: mockLogger,
    );
  });

  group('RetryInterceptor', () {
    test('should not retry if max retries exceeded', () {
      // Arrange
      final options = RequestOptions(
        path: '/test',
        extra: {'retry_count': 3},
      );
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.warning(any())).thenReturn(null);
      when(() => handler.next(any())).thenReturn(null);

      // Act
      interceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
      verify(() => mockLogger.warning(any())).called(1);
    });

    test('should not retry on cancel', () {
      // Arrange
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.warning(any())).thenReturn(null);
      when(() => handler.next(any())).thenReturn(null);

      // Act
      interceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
      verify(() => mockLogger.warning(any())).called(1);
    });

    test('should not retry on 4xx client errors', () {
      // Arrange
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 404,
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.warning(any())).thenReturn(null);
      when(() => handler.next(any())).thenReturn(null);

      // Act
      interceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
      verify(() => mockLogger.warning(any())).called(1);
    });

    test('should retry on connection timeout', () async {
      // Arrange
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.info(any())).thenReturn(null);
      when(() => mockLogger.warning(any())).thenReturn(null);

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verify(() => mockLogger.info(any())).called(1);
      // Note: Full retry execution would require mocking Dio.fetch
    });

    test('should retry on 5xx server errors', () async {
      // Arrange
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 503,
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.info(any())).thenReturn(null);

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verify(() => mockLogger.info(any())).called(1);
    });

    test('should retry on 429 rate limit', () async {
      // Arrange
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 429,
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.info(any())).thenReturn(null);

      // Act
      await interceptor.onError(error, handler);

      // Assert
      verify(() => mockLogger.info(any())).called(1);
    });

    test('should increment retry count', () async {
      // Arrange
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockLogger.info(any())).thenReturn(null);

      // Act
      await interceptor.onError(error, handler);

      // Assert
      expect(options.extra['retry_count'], equals(1));
    });
  });
}
