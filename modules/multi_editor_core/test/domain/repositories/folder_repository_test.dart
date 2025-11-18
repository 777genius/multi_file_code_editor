import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/src/domain/entities/folder.dart';
import 'package:multi_editor_core/src/domain/failures/domain_failure.dart';
import 'package:multi_editor_core/src/domain/value_objects/file_name.dart';
import 'package:multi_editor_core/src/ports/repositories/folder_repository.dart';

class MockFolderRepository extends Mock implements FolderRepository {}

void main() {
  group('FolderRepository', () {
    late MockFolderRepository repository;
    late DateTime now;

    setUp(() {
      repository = MockFolderRepository();
      now = DateTime.now();
    });

    group('create', () {
      test('should create root folder without parent', () async {
        // Arrange
        final expectedFolder = Folder(
          id: 'folder-1',
          name: 'root',
          parentId: null,
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(name: 'root'))
            .thenAnswer((_) async => Right(expectedFolder));

        // Act
        final result = await repository.create(name: 'root');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('folder-1'));
        expect(result.right.name, equals('root'));
        expect(result.right.parentId, isNull);
        expect(result.right.isRoot, isTrue);
        verify(() => repository.create(name: 'root')).called(1);
      });

      test('should create subfolder with parent', () async {
        // Arrange
        final expectedFolder = Folder(
          id: 'folder-2',
          name: 'src',
          parentId: 'folder-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              name: 'src',
              parentId: 'folder-1',
            )).thenAnswer((_) async => Right(expectedFolder));

        // Act
        final result = await repository.create(
          name: 'src',
          parentId: 'folder-1',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.parentId, equals('folder-1'));
        expect(result.right.isRoot, isFalse);
      });

      test('should create folder with metadata', () async {
        // Arrange
        final metadata = {'color': 'blue', 'icon': 'folder'};
        final expectedFolder = Folder(
          id: 'folder-1',
          name: 'documents',
          parentId: null,
          createdAt: now,
          updatedAt: now,
          metadata: metadata,
        );

        when(() => repository.create(
              name: 'documents',
              metadata: metadata,
            )).thenAnswer((_) async => Right(expectedFolder));

        // Act
        final result = await repository.create(
          name: 'documents',
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
          reason: 'Folder name contains invalid characters',
          value: 'invalid/name',
        );

        when(() => repository.create(name: 'invalid/name'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(name: 'invalid/name');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });

      test('should return already exists error for duplicate name', () async {
        // Arrange
        final failure = DomainFailure.alreadyExists(
          entityType: 'Folder',
          entityId: 'src',
          message: 'Folder with name "src" already exists in this location',
        );

        when(() => repository.create(
              name: 'src',
              parentId: 'folder-1',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(
          name: 'src',
          parentId: 'folder-1',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });

      test('should return not found error for non-existent parent', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
          message: 'Parent folder not found',
        );

        when(() => repository.create(
              name: 'subfolder',
              parentId: 'non-existent',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(
          name: 'subfolder',
          parentId: 'non-existent',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });
    });

    group('load', () {
      test('should load existing folder', () async {
        // Arrange
        final expectedFolder = Folder(
          id: 'folder-1',
          name: 'src',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.load('folder-1'))
            .thenAnswer((_) async => Right(expectedFolder));

        // Act
        final result = await repository.load('folder-1');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('folder-1'));
        expect(result.right.name, equals('src'));
        verify(() => repository.load('folder-1')).called(1);
      });

      test('should return not found error for non-existent folder', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
        );

        when(() => repository.load('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.load('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
        expect(result.left.entityId, equals('non-existent'));
      });
    });

    group('delete', () {
      test('should delete empty folder', () async {
        // Arrange
        when(() => repository.delete('folder-1'))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await repository.delete('folder-1');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => repository.delete('folder-1')).called(1);
      });

      test('should return not found error when deleting non-existent folder',
          () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
        );

        when(() => repository.delete('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });

      test('should return validation error when deleting non-empty folder',
          () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'folder',
          reason: 'Cannot delete folder with contents',
        );

        when(() => repository.delete('folder-1'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('folder-1');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('folder'));
      });

      test('should return permission denied error for protected folder',
          () async {
        // Arrange
        final failure = DomainFailure.permissionDenied(
          operation: 'delete',
          resource: 'root',
          message: 'Cannot delete root folder',
        );

        when(() => repository.delete('root'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('root');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.operation, equals('delete'));
      });
    });

    group('move', () {
      test('should move folder to different parent', () async {
        // Arrange
        final movedFolder = Folder(
          id: 'folder-1',
          name: 'lib',
          parentId: 'folder-2',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.move(
              folderId: 'folder-1',
              targetParentId: 'folder-2',
            )).thenAnswer((_) async => Right(movedFolder));

        // Act
        final result = await repository.move(
          folderId: 'folder-1',
          targetParentId: 'folder-2',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.parentId, equals('folder-2'));
        verify(() => repository.move(
              folderId: 'folder-1',
              targetParentId: 'folder-2',
            )).called(1);
      });

      test('should move folder to root level', () async {
        // Arrange
        final movedFolder = Folder(
          id: 'folder-1',
          name: 'lib',
          parentId: null,
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.move(
              folderId: 'folder-1',
              targetParentId: null,
            )).thenAnswer((_) async => Right(movedFolder));

        // Act
        final result = await repository.move(
          folderId: 'folder-1',
          targetParentId: null,
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.parentId, isNull);
        expect(result.right.isRoot, isTrue);
      });

      test('should return not found error for non-existent folder', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
        );

        when(() => repository.move(
              folderId: 'non-existent',
              targetParentId: 'folder-2',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.move(
          folderId: 'non-existent',
          targetParentId: 'folder-2',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });

      test('should return validation error when moving folder into itself',
          () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'targetParentId',
          reason: 'Cannot move folder into itself',
        );

        when(() => repository.move(
              folderId: 'folder-1',
              targetParentId: 'folder-1',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.move(
          folderId: 'folder-1',
          targetParentId: 'folder-1',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('targetParentId'));
      });

      test('should return validation error when moving folder into descendant',
          () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'targetParentId',
          reason: 'Cannot move folder into its descendant',
        );

        when(() => repository.move(
              folderId: 'folder-1',
              targetParentId: 'folder-1-child',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.move(
          folderId: 'folder-1',
          targetParentId: 'folder-1-child',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('descendant'));
      });
    });

    group('rename', () {
      test('should rename folder successfully', () async {
        // Arrange
        final renamedFolder = Folder(
          id: 'folder-1',
          name: 'new_name',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.rename(
              folderId: 'folder-1',
              newName: 'new_name',
            )).thenAnswer((_) async => Right(renamedFolder));

        // Act
        final result = await repository.rename(
          folderId: 'folder-1',
          newName: 'new_name',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.name, equals('new_name'));
        verify(() => repository.rename(
              folderId: 'folder-1',
              newName: 'new_name',
            )).called(1);
      });

      test('should return validation error for invalid name', () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'Folder name contains invalid characters',
          value: 'invalid/name',
        );

        when(() => repository.rename(
              folderId: 'folder-1',
              newName: 'invalid/name',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.rename(
          folderId: 'folder-1',
          newName: 'invalid/name',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });

      test('should return already exists error for duplicate name', () async {
        // Arrange
        final failure = DomainFailure.alreadyExists(
          entityType: 'Folder',
          entityId: 'existing',
          message: 'Folder with this name already exists',
        );

        when(() => repository.rename(
              folderId: 'folder-1',
              newName: 'existing',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.rename(
          folderId: 'folder-1',
          newName: 'existing',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });

      test('should return not found error for non-existent folder', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
        );

        when(() => repository.rename(
              folderId: 'non-existent',
              newName: 'new_name',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.rename(
          folderId: 'non-existent',
          newName: 'new_name',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityId, equals('non-existent'));
      });
    });

    group('watch', () {
      test('should emit folder updates', () async {
        // Arrange
        final folder1 = Folder(
          id: 'folder-1',
          name: 'src',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        final folder2 = Folder(
          id: 'folder-1',
          name: 'lib',
          parentId: 'root',
          createdAt: now,
          updatedAt: now.add(const Duration(seconds: 1)),
        );

        when(() => repository.watch('folder-1'))
            .thenAnswer((_) => Stream.fromIterable([
                  Right(folder1),
                  Right(folder2),
                ]));

        // Act
        final stream = repository.watch('folder-1');
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, equals(2));
        expect(results[0].isRight, isTrue);
        expect(results[0].right.name, equals('src'));
        expect(results[1].isRight, isTrue);
        expect(results[1].right.name, equals('lib'));
      });

      test('should emit error when folder not found', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'non-existent',
        );

        when(() => repository.watch('non-existent'))
            .thenAnswer((_) => Stream.value(Left(failure)));

        // Act
        final stream = repository.watch('non-existent');
        final result = await stream.first;

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Folder'));
      });
    });

    group('listInFolder', () {
      test('should list all subfolders in parent folder', () async {
        // Arrange
        final folders = [
          Folder(
            id: 'folder-1',
            name: 'src',
            parentId: 'root',
            createdAt: now,
            updatedAt: now,
          ),
          Folder(
            id: 'folder-2',
            name: 'lib',
            parentId: 'root',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.listInFolder('root'))
            .thenAnswer((_) async => Right(folders));

        // Act
        final result = await repository.listInFolder('root');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(2));
        expect(result.right[0].parentId, equals('root'));
        expect(result.right[1].parentId, equals('root'));
      });

      test('should list root folders when parentId is null', () async {
        // Arrange
        final folders = [
          Folder(
            id: 'folder-1',
            name: 'project1',
            parentId: null,
            createdAt: now,
            updatedAt: now,
          ),
          Folder(
            id: 'folder-2',
            name: 'project2',
            parentId: null,
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.listInFolder(null))
            .thenAnswer((_) async => Right(folders));

        // Act
        final result = await repository.listInFolder(null);

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(2));
        expect(result.right.every((f) => f.isRoot), isTrue);
      });

      test('should return empty list for folder with no subfolders', () async {
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

    group('listAll', () {
      test('should list all folders', () async {
        // Arrange
        final folders = [
          Folder(
            id: 'folder-1',
            name: 'root',
            parentId: null,
            createdAt: now,
            updatedAt: now,
          ),
          Folder(
            id: 'folder-2',
            name: 'src',
            parentId: 'folder-1',
            createdAt: now,
            updatedAt: now,
          ),
          Folder(
            id: 'folder-3',
            name: 'lib',
            parentId: 'folder-1',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.listAll())
            .thenAnswer((_) async => Right(folders));

        // Act
        final result = await repository.listAll();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(3));
        verify(() => repository.listAll()).called(1);
      });

      test('should return empty list when no folders exist', () async {
        // Arrange
        when(() => repository.listAll())
            .thenAnswer((_) async => const Right([]));

        // Act
        final result = await repository.listAll();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right, isEmpty);
      });
    });

    group('getRoot', () {
      test('should get root folder', () async {
        // Arrange
        final rootFolder = Folder(
          id: 'root',
          name: 'root',
          parentId: null,
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.getRoot())
            .thenAnswer((_) async => Right(rootFolder));

        // Act
        final result = await repository.getRoot();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.isRoot, isTrue);
        expect(result.right.parentId, isNull);
        verify(() => repository.getRoot()).called(1);
      });

      test('should return not found error when root does not exist', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Folder',
          entityId: 'root',
          message: 'Root folder not found',
        );

        when(() => repository.getRoot())
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.getRoot();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.message, contains('Root folder'));
      });
    });

    group('use cases', () {
      test('should handle complete folder hierarchy creation', () async {
        // Arrange - Create root
        final rootFolder = Folder(
          id: 'root',
          name: 'project',
          parentId: null,
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(name: 'project'))
            .thenAnswer((_) async => Right(rootFolder));

        // Act - Create root
        final rootResult = await repository.create(name: 'project');

        // Assert - Root created
        expect(rootResult.isRight, isTrue);
        expect(rootResult.right.isRoot, isTrue);

        // Arrange - Create subfolder
        final srcFolder = Folder(
          id: 'src',
          name: 'src',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              name: 'src',
              parentId: 'root',
            )).thenAnswer((_) async => Right(srcFolder));

        // Act - Create subfolder
        final srcResult = await repository.create(
          name: 'src',
          parentId: 'root',
        );

        // Assert - Subfolder created
        expect(srcResult.isRight, isTrue);
        expect(srcResult.right.parentId, equals('root'));

        // Arrange - List folders
        when(() => repository.listInFolder('root'))
            .thenAnswer((_) async => Right([srcFolder]));

        // Act - List
        final listResult = await repository.listInFolder('root');

        // Assert - Listed correctly
        expect(listResult.isRight, isTrue);
        expect(listResult.right.length, equals(1));
      });

      test('should handle folder reorganization', () async {
        // Arrange - Initial structure
        final libFolder = Folder(
          id: 'lib',
          name: 'lib',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              name: 'lib',
              parentId: 'root',
            )).thenAnswer((_) async => Right(libFolder));

        // Act - Create folder
        final createResult = await repository.create(
          name: 'lib',
          parentId: 'root',
        );

        // Assert - Created
        expect(createResult.isRight, isTrue);

        // Arrange - Rename folder
        final renamedFolder = libFolder.rename('library');
        when(() => repository.rename(
              folderId: 'lib',
              newName: 'library',
            )).thenAnswer((_) async => Right(renamedFolder));

        // Act - Rename
        final renameResult = await repository.rename(
          folderId: 'lib',
          newName: 'library',
        );

        // Assert - Renamed
        expect(renameResult.isRight, isTrue);
        expect(renameResult.right.name, equals('library'));

        // Arrange - Move folder
        final movedFolder = renamedFolder.move('new-parent');
        when(() => repository.move(
              folderId: 'lib',
              targetParentId: 'new-parent',
            )).thenAnswer((_) async => Right(movedFolder));

        // Act - Move
        final moveResult = await repository.move(
          folderId: 'lib',
          targetParentId: 'new-parent',
        );

        // Assert - Moved
        expect(moveResult.isRight, isTrue);
        expect(moveResult.right.parentId, equals('new-parent'));
      });

      test('should prevent circular folder references', () async {
        // Arrange - Try to move folder into itself
        final failure = DomainFailure.validationError(
          field: 'targetParentId',
          reason: 'Cannot move folder into itself',
        );

        when(() => repository.move(
              folderId: 'folder-1',
              targetParentId: 'folder-1',
            )).thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.move(
          folderId: 'folder-1',
          targetParentId: 'folder-1',
        );

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('itself'));
      });

      test('should handle folder tree navigation', () async {
        // Arrange - Get root
        final rootFolder = Folder(
          id: 'root',
          name: 'project',
          parentId: null,
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.getRoot())
            .thenAnswer((_) async => Right(rootFolder));

        // Act - Get root
        final rootResult = await repository.getRoot();

        // Assert - Root exists
        expect(rootResult.isRight, isTrue);

        // Arrange - List children
        final children = [
          Folder(
            id: 'src',
            name: 'src',
            parentId: 'root',
            createdAt: now,
            updatedAt: now,
          ),
          Folder(
            id: 'test',
            name: 'test',
            parentId: 'root',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.listInFolder('root'))
            .thenAnswer((_) async => Right(children));

        // Act - List children
        final childrenResult = await repository.listInFolder('root');

        // Assert - Children listed
        expect(childrenResult.isRight, isTrue);
        expect(childrenResult.right.length, equals(2));
      });
    });
  });
}

extension on Either<DomainFailure, Folder> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
  Folder get right => fold((_) => throw StateError('Left'), (r) => r);
}

extension on Either<DomainFailure, void> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
}

extension on Either<DomainFailure, List<Folder>> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
  List<Folder> get right => fold((_) => throw StateError('Left'), (r) => r);
}
