import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_application/src/handlers/uninstall_runtime_command_handler.dart';
import 'package:vscode_runtime_application/src/commands/uninstall_runtime_command.dart';
import 'package:vscode_runtime_application/src/exceptions/application_exception.dart';
import 'dart:io';

// Mocks
class MockRuntimeRepository extends Mock implements IRuntimeRepository {}
class MockFileSystemService extends Mock implements IFileSystemService {}
class MockEventBus extends Mock implements IEventBus {}
class FakeDomainEvent extends Fake implements DomainEvent {}

void main() {
  late UninstallRuntimeCommandHandler handler;
  late MockRuntimeRepository mockRuntimeRepo;
  late MockFileSystemService mockFileSystem;
  late MockEventBus mockEventBus;

  setUpAll(() {
    registerFallbackValue(FakeDomainEvent());
  });

  setUp(() {
    mockRuntimeRepo = MockRuntimeRepository();
    mockFileSystem = MockFileSystemService();
    mockEventBus = MockEventBus();

    handler = UninstallRuntimeCommandHandler(
      mockRuntimeRepo,
      mockFileSystem,
      mockEventBus,
    );

    // Default event bus behavior
    when(() => mockEventBus.publish(any())).thenAnswer((_) async {});
  });

  group('UninstallRuntimeCommandHandler', () {
    final installDir = Directory('/opt/vscode_runtime');
    final downloadDir = Directory('/tmp/vscode_runtime_downloads');
    final moduleId = ModuleId('test-module');
    final moduleDir = Directory('/opt/vscode_runtime/test-module');

    group('Full uninstall', () {
      test('should delete installation directory and clear state', () async {
        // Arrange
        final command = UninstallRuntimeCommand();

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
            .thenAnswer((_) async => right(unit));
        when(() => mockRuntimeRepo.deleteInstallation())
            .thenAnswer((_) async => right(unit));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (value) => expect(value, equals(unit)),
        );

        verify(() => mockFileSystem.deleteDirectory(installDir)).called(1);
        verify(() => mockRuntimeRepo.deleteInstallation()).called(1);
      });

      test('should delete downloads directory when keepDownloads is false', () async {
        // Arrange
        final command = UninstallRuntimeCommand(keepDownloads: false);

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
            .thenAnswer((_) async => right(unit));
        when(() => mockRuntimeRepo.deleteInstallation())
            .thenAnswer((_) async => right(unit));
        when(() => mockFileSystem.getDownloadDirectory())
            .thenAnswer((_) async => right(downloadDir));
        when(() => mockFileSystem.deleteDirectory(downloadDir))
            .thenAnswer((_) async => right(unit));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockFileSystem.deleteDirectory(downloadDir)).called(1);
      });

      test('should keep downloads directory when keepDownloads is true', () async {
        // Arrange
        final command = UninstallRuntimeCommand(keepDownloads: true);

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
            .thenAnswer((_) async => right(unit));
        when(() => mockRuntimeRepo.deleteInstallation())
            .thenAnswer((_) async => right(unit));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        verifyNever(() => mockFileSystem.getDownloadDirectory());
        verifyNever(() => mockFileSystem.deleteDirectory(downloadDir));
      });

      test('should return error when installation directory deletion fails', () async {
        // Arrange
        final command = UninstallRuntimeCommand();

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
            .thenAnswer((_) async => left(const FileSystemException('Permission denied')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<FileSystemException>());
            expect(error.message, contains('Failed to delete installation directory'));
          },
          (_) => fail('Should fail'),
        );

        verifyNever(() => mockRuntimeRepo.deleteInstallation());
      });
    });

    group('Partial uninstall (specific modules)', () {
      test('should delete only specified module directories', () async {
        // Arrange
        final command = UninstallRuntimeCommand(
          moduleIds: [moduleId],
        );

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.getModuleDirectory(moduleId))
            .thenAnswer((_) async => right(moduleDir));
        when(() => mockFileSystem.deleteDirectory(moduleDir))
            .thenAnswer((_) async => right(unit));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockFileSystem.deleteDirectory(moduleDir)).called(1);
        verifyNever(() => mockFileSystem.deleteDirectory(installDir));
        verifyNever(() => mockRuntimeRepo.deleteInstallation());
      });

      test('should delete multiple module directories', () async {
        // Arrange
        final moduleId2 = ModuleId('another-module');
        final moduleDir2 = Directory('/opt/vscode_runtime/another-module');

        final command = UninstallRuntimeCommand(
          moduleIds: [moduleId, moduleId2],
        );

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.getModuleDirectory(moduleId))
            .thenAnswer((_) async => right(moduleDir));
        when(() => mockFileSystem.getModuleDirectory(moduleId2))
            .thenAnswer((_) async => right(moduleDir2));
        when(() => mockFileSystem.deleteDirectory(moduleDir))
            .thenAnswer((_) async => right(unit));
        when(() => mockFileSystem.deleteDirectory(moduleDir2))
            .thenAnswer((_) async => right(unit));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockFileSystem.deleteDirectory(moduleDir)).called(1);
        verify(() => mockFileSystem.deleteDirectory(moduleDir2)).called(1);
      });

      test('should return error when module directory deletion fails', () async {
        // Arrange
        final command = UninstallRuntimeCommand(
          moduleIds: [moduleId],
        );

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.getModuleDirectory(moduleId))
            .thenAnswer((_) async => right(moduleDir));
        when(() => mockFileSystem.deleteDirectory(moduleDir))
            .thenAnswer((_) async => left(const FileSystemException('Permission denied')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<FileSystemException>());
            expect(error.message, contains('Failed to delete module'));
            expect(error.message, contains(moduleId.value));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should return error when getting module directory fails', () async {
        // Arrange
        final command = UninstallRuntimeCommand(
          moduleIds: [moduleId],
        );

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.getModuleDirectory(moduleId))
            .thenAnswer((_) async => left(const NotFoundException('Module directory not found')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to get module directory'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('Error handling', () {
      test('should return error when getting installation directory fails', () async {
        // Arrange
        final command = UninstallRuntimeCommand();

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => left(const NotFoundException('Installation not found')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to get installation directory'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should handle domain exceptions', () async {
        // Arrange
        final command = UninstallRuntimeCommand();

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
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
        final command = UninstallRuntimeCommand();

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<ApplicationException>());
            expect(error.message, contains('Failed to uninstall runtime'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('Download directory cleanup', () {
      test('should not fail if download directory does not exist', () async {
        // Arrange
        final command = UninstallRuntimeCommand(keepDownloads: false);

        when(() => mockFileSystem.getInstallationDirectory())
            .thenAnswer((_) async => right(installDir));
        when(() => mockFileSystem.deleteDirectory(installDir))
            .thenAnswer((_) async => right(unit));
        when(() => mockRuntimeRepo.deleteInstallation())
            .thenAnswer((_) async => right(unit));
        when(() => mockFileSystem.getDownloadDirectory())
            .thenAnswer((_) async => left(const NotFoundException('Download directory not found')));

        // Act
        final result = await handler.handle(command);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockFileSystem.getDownloadDirectory()).called(1);
        verifyNever(() => mockFileSystem.deleteDirectory(downloadDir));
      });
    });
  });
}
