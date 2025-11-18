import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/src/domain/entities/file_document.dart';
import 'package:multi_editor_core/src/domain/failures/domain_failure.dart';
import 'package:multi_editor_core/src/domain/value_objects/file_name.dart';
import 'package:multi_editor_core/src/ports/repositories/file_repository.dart';

class MockFileRepository extends Mock implements FileRepository {}

void main() {
  group('FileRepository', () {
    late MockFileRepository repository;
    late DateTime now;

    setUp(() {
      repository = MockFileRepository();
      now = DateTime.now();
    });

    group('create', () {
      test('should create file with required parameters', () async {
        // Arrange
        final expectedFile = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'main.dart',
            )).thenAnswer((_) async => Right(expectedFile));

        // Act
        final result = await repository.create(
          folderId: 'folder-1',
          name: 'main.dart',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('file-1'));
        expect(result.right.name, equals('main.dart'));
        expect(result.right.folderId, equals('folder-1'));
        verify(() => repository.create(
              folderId: 'folder-1',
              name: 'main.dart',
            )).called(1);
      });

      test('should create file with initial content', () async {
        // Arrange
        final expectedFile = FileDocument(
          id: 'file-1',
          name: 'config.json',
          folderId: 'folder-1',
          content: '{"key": "value"}',
          language: 'json',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'config.json',
              initialContent: '{"key": "value"}',
              language: 'json',
            )).thenAnswer((_) async => Right(expectedFile));

        // Act
        final result = await repository.create(
          folderId: 'folder-1',
          name: 'config.json',
          initialContent: '{"key": "value"}',
          language: 'json',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.content, equals('{"key": "value"}'));
        expect(result.right.language, equals('json'));
      });

      test('should create file with metadata', () async {
        // Arrange
        final metadata = {'readonly': true, 'version': 1};
        final expectedFile = FileDocument(
          id: 'file-1',
          name: 'locked.txt',
          folderId: 'folder-1',
          content: '',
          language: 'plaintext',
          createdAt: now,
          updatedAt: now,
          metadata: metadata,
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'locked.txt',
              metadata: metadata,
            )).thenAnswer((_) async => Right(expectedFile));

        // Act
        final result = await repository.create(
          folderId: 'folder-1',
          name: 'locked.txt',
          metadata: metadata,
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.metadata, equals(metadata));
      });

      test('should return validation error for invalid name', () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'File name contains invalid characters',
          value: 'invalid/name.txt',
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'invalid/name.txt',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(
          folderId: 'folder-1',
          name: 'invalid/name.txt',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });

      test('should return already exists error for duplicate name', () async {
        // Arrange
        final failure = DomainFailure.alreadyExists(
          entityType: 'FileDocument',
          entityId: 'main.dart',
          message: 'File with name "main.dart" already exists in this folder',
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'main.dart',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(
          folderId: 'folder-1',
          name: 'main.dart',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });

      test('should return not found error for non-existent folder', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
          message: 'Parent folder not found',
        );

        when(() => repository.create(
              folderId: 'non-existent',
              name: 'file.txt',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(
          folderId: 'non-existent',
          name: 'file.txt',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });
    });

    group('load', () {
      test('should load existing file', () async {
        // Arrange
        final expectedFile = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: 'void main() {}',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.load('file-1'))
            .thenAnswer((_) async => Right(expectedFile));

        // Act
        final result = await repository.load('file-1');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('file-1'));
        expect(result.right.name, equals('main.dart'));
        verify(() => repository.load('file-1')).called(1);
      });

      test('should return not found error for non-existent file', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'FileDocument',
          entityId: 'non-existent',
        );

        when(() => repository.load('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.load('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
        expect(result.left.entityId, equals('non-existent'));
      });
    });

    group('save', () {
      test('should save file successfully', () async {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: 'void main() {}',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.save(file))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await repository.save(file);

        // Assert
        expect(result.isRight, isTrue);
        verify(() => repository.save(file)).called(1);
      });

      test('should return not found error when saving non-existent file',
          () async {
        // Arrange
        final file = FileDocument(
          id: 'non-existent',
          name: 'file.txt',
          folderId: 'folder-1',
          content: 'content',
          language: 'plaintext',
          createdAt: now,
          updatedAt: now,
        );

        final failure = DomainFailure.notFound(
          entityType: 'FileDocument',
          entityId: 'non-existent',
        );

        when(() => repository.save(file))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.save(file);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });

      test('should return validation error for invalid file data', () async {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: '',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'File name cannot be empty',
        );

        when(() => repository.save(file))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.save(file);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });
    });

    group('delete', () {
      test('should delete file successfully', () async {
        // Arrange
        when(() => repository.delete('file-1'))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await repository.delete('file-1');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => repository.delete('file-1')).called(1);
      });

      test('should return not found error when deleting non-existent file',
          () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'FileDocument',
          entityId: 'non-existent',
        );

        when(() => repository.delete('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });

      test('should return permission denied error for protected file',
          () async {
        // Arrange
        final failure = DomainFailure.permissionDenied(
          operation: 'delete',
          resource: 'file-1',
          message: 'Cannot delete protected file',
        );

        when(() => repository.delete('file-1'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('file-1');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.operation, equals('delete'));
      });
    });

    group('move', () {
      test('should move file to different folder', () async {
        // Arrange
        final movedFile = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-2',
          content: 'void main() {}',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.move(
              fileId: 'file-1',
              targetFolderId: 'folder-2',
            )).thenAnswer((_) async => Right(movedFile));

        // Act
        final result = await repository.move(
          fileId: 'file-1',
          targetFolderId: 'folder-2',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.folderId, equals('folder-2'));
        verify(() => repository.move(
              fileId: 'file-1',
              targetFolderId: 'folder-2',
            )).called(1);
      });

      test('should return not found error for non-existent file', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'FileDocument',
          entityId: 'non-existent',
        );

        when(() => repository.move(
              fileId: 'non-existent',
              targetFolderId: 'folder-2',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.move(
          fileId: 'non-existent',
          targetFolderId: 'folder-2',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });

      test('should return not found error for non-existent target folder',
          () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
          message: 'Target folder not found',
        );

        when(() => repository.move(
              fileId: 'file-1',
              targetFolderId: 'non-existent',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.move(
          fileId: 'file-1',
          targetFolderId: 'non-existent',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });
    });

    group('rename', () {
      test('should rename file successfully', () async {
        // Arrange
        final renamedFile = FileDocument(
          id: 'file-1',
          name: 'new_name.dart',
          folderId: 'folder-1',
          content: 'void main() {}',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.rename(
              fileId: 'file-1',
              newName: 'new_name.dart',
            )).thenAnswer((_) async => Right(renamedFile));

        // Act
        final result = await repository.rename(
          fileId: 'file-1',
          newName: 'new_name.dart',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.name, equals('new_name.dart'));
        verify(() => repository.rename(
              fileId: 'file-1',
              newName: 'new_name.dart',
            )).called(1);
      });

      test('should return validation error for invalid name', () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'File name contains invalid characters',
          value: 'invalid/name.txt',
        );

        when(() => repository.rename(
              fileId: 'file-1',
              newName: 'invalid/name.txt',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.rename(
          fileId: 'file-1',
          newName: 'invalid/name.txt',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });

      test('should return already exists error for duplicate name', () async {
        // Arrange
        final failure = DomainFailure.alreadyExists(
          entityType: 'FileDocument',
          entityId: 'existing.dart',
          message: 'File with this name already exists',
        );

        when(() => repository.rename(
              fileId: 'file-1',
              newName: 'existing.dart',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.rename(
          fileId: 'file-1',
          newName: 'existing.dart',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });
    });

    group('duplicate', () {
      test('should duplicate file with generated name', () async {
        // Arrange
        final duplicatedFile = FileDocument(
          id: 'file-2',
          name: 'main_copy.dart',
          folderId: 'folder-1',
          content: 'void main() {}',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.duplicate(fileId: 'file-1'))
            .thenAnswer((_) async => Right(duplicatedFile));

        // Act
        final result = await repository.duplicate(fileId: 'file-1');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, isNot(equals('file-1')));
        expect(result.right.name, contains('copy'));
      });

      test('should duplicate file with custom name', () async {
        // Arrange
        final duplicatedFile = FileDocument(
          id: 'file-2',
          name: 'custom_name.dart',
          folderId: 'folder-1',
          content: 'void main() {}',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.duplicate(
              fileId: 'file-1',
              newName: 'custom_name.dart',
            )).thenAnswer((_) async => Right(duplicatedFile));

        // Act
        final result = await repository.duplicate(
          fileId: 'file-1',
          newName: 'custom_name.dart',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.name, equals('custom_name.dart'));
      });

      test('should return not found error for non-existent file', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'FileDocument',
          entityId: 'non-existent',
        );

        when(() => repository.duplicate(fileId: 'non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.duplicate(fileId: 'non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });
    });

    group('watch', () {
      test('should emit file updates', () async {
        // Arrange
        final file1 = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: 'version 1',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final file2 = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: 'version 2',
          language: 'dart',
          createdAt: now,
          updatedAt: now.add(const Duration(seconds: 1)),
        );

        when(() => repository.watch('file-1'))
            .thenAnswer((_) => Stream.fromIterable([
                  Right(file1),
                  Right(file2),
                ]));

        // Act
        final stream = repository.watch('file-1');
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, equals(2));
        expect(results[0].isRight, isTrue);
        expect(results[0].right.content, equals('version 1'));
        expect(results[1].isRight, isTrue);
        expect(results[1].right.content, equals('version 2'));
      });

      test('should emit error when file not found', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'FileDocument',
          entityId: 'non-existent',
        );

        when(() => repository.watch('non-existent'))
            .thenAnswer((_) => Stream.value(Left(failure)));

        // Act
        final stream = repository.watch('non-existent');
        final result = await stream.first;

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('FileDocument'));
      });
    });

    group('listInFolder', () {
      test('should list all files in folder', () async {
        // Arrange
        final files = [
          FileDocument(
            id: 'file-1',
            name: 'main.dart',
            folderId: 'folder-1',
            content: '',
            language: 'dart',
            createdAt: now,
            updatedAt: now,
          ),
          FileDocument(
            id: 'file-2',
            name: 'config.json',
            folderId: 'folder-1',
            content: '{}',
            language: 'json',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.listInFolder('folder-1'))
            .thenAnswer((_) async => Right(files));

        // Act
        final result = await repository.listInFolder('folder-1');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(2));
        expect(result.right[0].folderId, equals('folder-1'));
        expect(result.right[1].folderId, equals('folder-1'));
      });

      test('should return empty list for empty folder', () async {
        // Arrange
        when(() => repository.listInFolder('empty-folder'))
            .thenAnswer((_) async => const Right([]));

        // Act
        final result = await repository.listInFolder('empty-folder');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right, isEmpty);
      });

      test('should return not found error for non-existent folder', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
        );

        when(() => repository.listInFolder('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.listInFolder('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });
    });

    group('search', () {
      test('should search files by query', () async {
        // Arrange
        final files = [
          FileDocument(
            id: 'file-1',
            name: 'main.dart',
            folderId: 'folder-1',
            content: 'void main() {}',
            language: 'dart',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.search(query: 'main'))
            .thenAnswer((_) async => Right(files));

        // Act
        final result = await repository.search(query: 'main');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(1));
        expect(result.right[0].name, contains('main'));
      });

      test('should search files by language', () async {
        // Arrange
        final files = [
          FileDocument(
            id: 'file-1',
            name: 'main.dart',
            folderId: 'folder-1',
            content: '',
            language: 'dart',
            createdAt: now,
            updatedAt: now,
          ),
          FileDocument(
            id: 'file-2',
            name: 'app.dart',
            folderId: 'folder-1',
            content: '',
            language: 'dart',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.search(language: 'dart'))
            .thenAnswer((_) async => Right(files));

        // Act
        final result = await repository.search(language: 'dart');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(2));
        expect(result.right.every((f) => f.language == 'dart'), isTrue);
      });

      test('should search files in specific folder', () async {
        // Arrange
        final files = [
          FileDocument(
            id: 'file-1',
            name: 'test.dart',
            folderId: 'test-folder',
            content: '',
            language: 'dart',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.search(folderId: 'test-folder'))
            .thenAnswer((_) async => Right(files));

        // Act
        final result = await repository.search(folderId: 'test-folder');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.every((f) => f.folderId == 'test-folder'), isTrue);
      });

      test('should return empty list when no files match', () async {
        // Arrange
        when(() => repository.search(query: 'nonexistent'))
            .thenAnswer((_) async => const Right([]));

        // Act
        final result = await repository.search(query: 'nonexistent');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right, isEmpty);
      });
    });

    group('use cases', () {
      test('should handle complete file lifecycle', () async {
        // Arrange - Create file
        final createdFile = FileDocument(
          id: 'file-1',
          name: 'test.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'test.dart',
              language: 'dart',
            )).thenAnswer((_) async => Right(createdFile));

        // Act - Create
        final createResult = await repository.create(
          folderId: 'folder-1',
          name: 'test.dart',
          language: 'dart',
        );

        // Assert - Created
        expect(createResult.isRight, isTrue);

        // Arrange - Update content
        final updatedFile = createdFile.updateContent('void main() {}');
        when(() => repository.save(updatedFile))
            .thenAnswer((_) async => const Right(null));

        // Act - Save
        final saveResult = await repository.save(updatedFile);

        // Assert - Saved
        expect(saveResult.isRight, isTrue);

        // Arrange - Move file
        final movedFile = updatedFile.move('folder-2');
        when(() => repository.move(
              fileId: 'file-1',
              targetFolderId: 'folder-2',
            )).thenAnswer((_) async => Right(movedFile));

        // Act - Move
        final moveResult = await repository.move(
          fileId: 'file-1',
          targetFolderId: 'folder-2',
        );

        // Assert - Moved
        expect(moveResult.isRight, isTrue);
        expect(moveResult.right.folderId, equals('folder-2'));

        // Arrange - Delete
        when(() => repository.delete('file-1'))
            .thenAnswer((_) async => const Right(null));

        // Act - Delete
        final deleteResult = await repository.delete('file-1');

        // Assert - Deleted
        expect(deleteResult.isRight, isTrue);
      });

      test('should handle error cascading', () async {
        // Arrange - Create file with invalid name
        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'Invalid file name',
        );

        when(() => repository.create(
              folderId: 'folder-1',
              name: 'invalid/name',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(
          folderId: 'folder-1',
          name: 'invalid/name',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
        // Should not proceed with invalid data
        verifyNever(() => repository.save(any()));
      });
    });
  });
}

extension on Either<DomainFailure, FileDocument> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
  FileDocument get right => fold((_) => throw StateError('Left'), (r) => r);
}

extension on Either<DomainFailure, void> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
}

extension on Either<DomainFailure, List<FileDocument>> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
  List<FileDocument> get right =>
      fold((_) => throw StateError('Left'), (r) => r);
}
