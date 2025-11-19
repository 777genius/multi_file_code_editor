import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_application/src/handlers/get_platform_info_query_handler.dart';
import 'package:vscode_runtime_application/src/queries/get_platform_info_query.dart';
import 'package:vscode_runtime_application/src/exceptions/application_exception.dart';

class MockPlatformService extends Mock implements IPlatformService {}

void main() {
  late GetPlatformInfoQueryHandler handler;
  late MockPlatformService mockPlatformService;

  setUp(() {
    mockPlatformService = MockPlatformService();
    handler = GetPlatformInfoQueryHandler(mockPlatformService);
  });

  group('GetPlatformInfoQueryHandler', () {
    test('should return platform info DTO with all data', () async {
      // Arrange
      final query = GetPlatformInfoQuery();

      final platformInfo = PlatformInfo(
        identifier: PlatformIdentifier.linux,
        osName: 'Linux',
        osVersion: '5.15.0',
        architecture: 'x86_64',
        numberOfProcessors: 8,
      );

      when(() => mockPlatformService.getPlatformInfo()).thenAnswer(
        (_) async => right(platformInfo),
      );

      when(() => mockPlatformService.getAvailableDiskSpace()).thenAnswer(
        (_) async => right(500000000000), // 500GB
      );

      when(() => mockPlatformService.hasRequiredPermissions()).thenAnswer(
        (_) async => right(true),
      );

      when(() => mockPlatformService.isPlatformSupported(any())).thenAnswer(
        (_) async => right(true),
      );

      // Act
      final result = await handler.handle(query);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should return DTO'),
        (dto) {
          expect(dto.identifier, equals(PlatformIdentifier.linux));
          expect(dto.osName, equals('Linux'));
          expect(dto.osVersion, equals('5.15.0'));
          expect(dto.architecture, equals('x86_64'));
          expect(dto.numberOfProcessors, equals(8));
          expect(dto.availableDiskSpace.bytes, equals(500000000000));
          expect(dto.hasRequiredPermissions, isTrue);
          expect(dto.isSupported, isTrue);
        },
      );

      verify(() => mockPlatformService.getPlatformInfo()).called(1);
      verify(() => mockPlatformService.getAvailableDiskSpace()).called(1);
      verify(() => mockPlatformService.hasRequiredPermissions()).called(1);
      verify(() => mockPlatformService.isPlatformSupported(PlatformIdentifier.linux)).called(1);
    });

    test('should return error when platform info fetch fails', () async {
      // Arrange
      final query = GetPlatformInfoQuery();

      when(() => mockPlatformService.getPlatformInfo()).thenAnswer(
        (_) async => left(const DomainException('Failed to detect platform')),
      );

      // Act
      final result = await handler.handle(query);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<ApplicationException>());
          expect(error.message, contains('Failed to get platform info'));
        },
        (_) => fail('Should return error'),
      );

      verify(() => mockPlatformService.getPlatformInfo()).called(1);
    });

    test('should use fallback when disk space fetch fails', () async {
      // Arrange
      final query = GetPlatformInfoQuery();

      final platformInfo = PlatformInfo(
        identifier: PlatformIdentifier.linux,
        osName: 'Linux',
        osVersion: '5.15.0',
        architecture: 'x86_64',
        numberOfProcessors: 8,
      );

      when(() => mockPlatformService.getPlatformInfo()).thenAnswer(
        (_) async => right(platformInfo),
      );

      when(() => mockPlatformService.getAvailableDiskSpace()).thenAnswer(
        (_) async => left(const DomainException('Disk space unavailable')),
      );

      when(() => mockPlatformService.hasRequiredPermissions()).thenAnswer(
        (_) async => right(true),
      );

      when(() => mockPlatformService.isPlatformSupported(any())).thenAnswer(
        (_) async => right(true),
      );

      // Act
      final result = await handler.handle(query);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should return DTO with fallback'),
        (dto) {
          // Should use 100GB fallback
          expect(dto.availableDiskSpace.gb, equals(100));
        },
      );
    });

    test('should set hasRequiredPermissions to false when check fails', () async {
      // Arrange
      final query = GetPlatformInfoQuery();

      final platformInfo = PlatformInfo(
        identifier: PlatformIdentifier.linux,
        osName: 'Linux',
        osVersion: '5.15.0',
        architecture: 'x86_64',
        numberOfProcessors: 8,
      );

      when(() => mockPlatformService.getPlatformInfo()).thenAnswer(
        (_) async => right(platformInfo),
      );

      when(() => mockPlatformService.getAvailableDiskSpace()).thenAnswer(
        (_) async => right(500000000000),
      );

      when(() => mockPlatformService.hasRequiredPermissions()).thenAnswer(
        (_) async => left(const DomainException('Permission check failed')),
      );

      when(() => mockPlatformService.isPlatformSupported(any())).thenAnswer(
        (_) async => right(true),
      );

      // Act
      final result = await handler.handle(query);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should return DTO with false permissions'),
        (dto) {
          expect(dto.hasRequiredPermissions, isFalse);
        },
      );
    });

    test('should set isSupported to false when support check fails', () async {
      // Arrange
      final query = GetPlatformInfoQuery();

      final platformInfo = PlatformInfo(
        identifier: PlatformIdentifier.linux,
        osName: 'Linux',
        osVersion: '5.15.0',
        architecture: 'x86_64',
        numberOfProcessors: 8,
      );

      when(() => mockPlatformService.getPlatformInfo()).thenAnswer(
        (_) async => right(platformInfo),
      );

      when(() => mockPlatformService.getAvailableDiskSpace()).thenAnswer(
        (_) async => right(500000000000),
      );

      when(() => mockPlatformService.hasRequiredPermissions()).thenAnswer(
        (_) async => right(true),
      );

      when(() => mockPlatformService.isPlatformSupported(any())).thenAnswer(
        (_) async => left(const DomainException('Support check failed')),
      );

      // Act
      final result = await handler.handle(query);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should return DTO with unsupported platform'),
        (dto) {
          expect(dto.isSupported, isFalse);
        },
      );
    });

    test('should handle generic exceptions', () async {
      // Arrange
      final query = GetPlatformInfoQuery();

      when(() => mockPlatformService.getPlatformInfo()).thenThrow(
        Exception('Unexpected error'),
      );

      // Act
      final result = await handler.handle(query);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<ApplicationException>());
          expect(error.message, contains('Failed to get platform info'));
          expect(error.innerException, isA<Exception>());
        },
        (_) => fail('Should return error'),
      );
    });
  });
}
