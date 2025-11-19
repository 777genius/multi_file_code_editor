import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:vscode_runtime_infrastructure/src/services/circuit_breaker_interceptor.dart';
import 'package:vscode_runtime_infrastructure/src/services/logging_service.dart';

class MockLoggingService extends Mock implements LoggingService {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}
class FakeRequestOptions extends Fake implements RequestOptions {}
class FakeResponse extends Fake implements Response {}
class FakeDioException extends Fake implements DioException {}

void main() {
  late CircuitBreakerInterceptor interceptor;
  late MockLoggingService mockLogger;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeResponse());
    registerFallbackValue(FakeDioException());
  });

  setUp(() {
    mockLogger = MockLoggingService();
    interceptor = CircuitBreakerInterceptor(
      failureThreshold: 3,
      openDuration: const Duration(milliseconds: 100),
      halfOpenTimeout: const Duration(milliseconds: 50),
      logger: mockLogger,
    );

    when(() => mockLogger.info(any())).thenReturn(null);
    when(() => mockLogger.warning(any())).thenReturn(null);
    when(() => mockLogger.error(any())).thenReturn(null);
  });

  group('CircuitBreakerInterceptor', () {
    group('Closed State', () {
      test('should allow requests in closed state', () {
        // Arrange
        final options = RequestOptions(path: '/test');
        final handler = MockRequestInterceptorHandler();

        when(() => handler.next(any())).thenReturn(null);

        // Act
        interceptor.onRequest(options, handler);

        // Assert
        verify(() => handler.next(options)).called(1);
        final status = interceptor.getStatus();
        expect(status['state'], equals('closed'));
      });

      test('should transition to open after threshold failures', () {
        // Arrange
        final handler = MockErrorInterceptorHandler();

        when(() => handler.next(any())).thenReturn(null);

        // Act - trigger 3 failures (threshold)
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, handler);
        }

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('open'));
        verify(() => mockLogger.error(any())).called(1);
      });

      test('should not count 4xx errors towards threshold', () {
        // Arrange
        final handler = MockErrorInterceptorHandler();

        when(() => handler.next(any())).thenReturn(null);

        // Act - trigger 4xx errors (should not count)
        for (var i = 0; i < 5; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 404,
            ),
          );
          interceptor.onError(error, handler);
        }

        // Assert - should still be closed
        final status = interceptor.getStatus();
        expect(status['state'], equals('closed'));
        expect(status['failureCount'], equals(0));
      });

      test('should count 5xx errors towards threshold', () {
        // Arrange
        final handler = MockErrorInterceptorHandler();

        when(() => handler.next(any())).thenReturn(null);

        // Act
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 503,
            ),
          );
          interceptor.onError(error, handler);
        }

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('open'));
      });

      test('should reset failure count on success', () {
        // Arrange
        final errorHandler = MockErrorInterceptorHandler();
        final responseHandler = MockResponseInterceptorHandler();

        when(() => errorHandler.next(any())).thenReturn(null);
        when(() => responseHandler.next(any())).thenReturn(null);

        // Act - 2 failures, then 1 success
        for (var i = 0; i < 2; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, errorHandler);
        }

        final options = RequestOptions(path: '/test');
        final response = Response(requestOptions: options, statusCode: 200);
        interceptor.onResponse(response, responseHandler);

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('closed'));
        expect(status['failureCount'], equals(0));
      });
    });

    group('Open State', () {
      test('should reject requests in open state', () {
        // Arrange
        final errorHandler = MockErrorInterceptorHandler();
        final requestHandler = MockRequestInterceptorHandler();

        when(() => errorHandler.next(any())).thenReturn(null);
        when(() => requestHandler.reject(any())).thenReturn(null);

        // Trigger circuit to open
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, errorHandler);
        }

        // Act - try to make request
        final options = RequestOptions(path: '/test');
        interceptor.onRequest(options, requestHandler);

        // Assert
        verify(() => requestHandler.reject(any())).called(1);
      });

      test('should transition to half-open after timeout', () async {
        // Arrange
        final errorHandler = MockErrorInterceptorHandler();

        when(() => errorHandler.next(any())).thenReturn(null);

        // Trigger circuit to open
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, errorHandler);
        }

        // Act - wait for timeout
        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('halfOpen'));
      });
    });

    group('Half-Open State', () {
      test('should transition to closed after successful requests', () async {
        // Arrange
        final errorHandler = MockErrorInterceptorHandler();
        final responseHandler = MockResponseInterceptorHandler();

        when(() => errorHandler.next(any())).thenReturn(null);
        when(() => responseHandler.next(any())).thenReturn(null);

        // Trigger circuit to open
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, errorHandler);
        }

        // Wait for half-open
        await Future.delayed(const Duration(milliseconds: 150));

        // Act - 3 successful responses
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final response = Response(requestOptions: options, statusCode: 200);
          interceptor.onResponse(response, responseHandler);
        }

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('closed'));
        verify(() => mockLogger.info(any())).called(greaterThanOrEqualTo(2));
      });

      test('should transition back to open on failure in half-open', () async {
        // Arrange
        final errorHandler = MockErrorInterceptorHandler();

        when(() => errorHandler.next(any())).thenReturn(null);

        // Trigger circuit to open
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, errorHandler);
        }

        // Wait for half-open
        await Future.delayed(const Duration(milliseconds: 150));

        // Act - failure in half-open
        final options = RequestOptions(path: '/test');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        );
        interceptor.onError(error, errorHandler);

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('open'));
      });
    });

    group('Manual Reset', () {
      test('should manually reset circuit breaker', () {
        // Arrange
        final errorHandler = MockErrorInterceptorHandler();

        when(() => errorHandler.next(any())).thenReturn(null);

        // Trigger circuit to open
        for (var i = 0; i < 3; i++) {
          final options = RequestOptions(path: '/test');
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
          interceptor.onError(error, errorHandler);
        }

        // Act
        interceptor.reset();

        // Assert
        final status = interceptor.getStatus();
        expect(status['state'], equals('closed'));
        expect(status['failureCount'], equals(0));
        expect(status['successCount'], equals(0));
      });
    });

    group('Status', () {
      test('should return current status', () {
        // Act
        final status = interceptor.getStatus();

        // Assert
        expect(status, isA<Map<String, dynamic>>());
        expect(status.containsKey('state'), isTrue);
        expect(status.containsKey('failureCount'), isTrue);
        expect(status.containsKey('successCount'), isTrue);
        expect(status.containsKey('failureThreshold'), isTrue);
      });
    });
  });
}
