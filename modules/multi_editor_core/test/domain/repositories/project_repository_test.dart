import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/src/domain/entities/project.dart';
import 'package:multi_editor_core/src/domain/failures/domain_failure.dart';
import 'package:multi_editor_core/src/domain/value_objects/file_name.dart';
import 'package:multi_editor_core/src/ports/repositories/project_repository.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  group('ProjectRepository', () {
    late MockProjectRepository repository;
    late DateTime now;

    setUp(() {
      repository = MockProjectRepository();
      now = DateTime.now();
    });

    group('create', () {
      test('should create project with required parameters', () async {
        // Arrange
        final expectedProject = Project(
          id: 'project-1',
          name: 'My Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(name: 'My Project'))
            .thenAnswer((_) async => Right(expectedProject));

        // Act
        final result = await repository.create(name: 'My Project');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('project-1'));
        expect(result.right.name, equals('My Project'));
        expect(result.right.rootFolderId, isNotEmpty);
        verify(() => repository.create(name: 'My Project')).called(1);
      });

      test('should create project with description', () async {
        // Arrange
        final expectedProject = Project(
          id: 'project-1',
          name: 'Web App',
          description: 'A modern web application',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              name: 'Web App',
              description: 'A modern web application',
            )).thenAnswer((_) async => Right(expectedProject));

        // Act
        final result = await repository.create(
          name: 'Web App',
          description: 'A modern web application',
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.description, equals('A modern web application'));
      });

      test('should create project with settings', () async {
        // Arrange
        final settings = {
          'theme': 'dark',
          'autoSave': true,
          'tabSize': 2,
        };

        final expectedProject = Project(
          id: 'project-1',
          name: 'Configured Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          settings: settings,
        );

        when(() => repository.create(
              name: 'Configured Project',
              settings: settings,
            )).thenAnswer((_) async => Right(expectedProject));

        // Act
        final result = await repository.create(
          name: 'Configured Project',
          settings: settings,
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.settings, equals(settings));
        expect(result.right.settings['theme'], equals('dark'));
      });

      test('should create project with metadata', () async {
        // Arrange
        final metadata = {
          'tags': ['flutter', 'mobile'],
          'version': '1.0.0',
          'author': 'John Doe',
        };

        final expectedProject = Project(
          id: 'project-1',
          name: 'Tagged Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          metadata: metadata,
        );

        when(() => repository.create(
              name: 'Tagged Project',
              metadata: metadata,
            )).thenAnswer((_) async => Right(expectedProject));

        // Act
        final result = await repository.create(
          name: 'Tagged Project',
          metadata: metadata,
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.metadata, equals(metadata));
        expect(result.right.metadata['tags'], contains('flutter'));
      });

      test('should return validation error for invalid name', () async {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'Project name cannot be empty',
          value: '',
        );

        when(() => repository.create(name: ''))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(name: '');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });

      test('should return already exists error for duplicate name', () async {
        // Arrange
        final failure = DomainFailure.alreadyExists(
          entityType: 'Project',
          entityId: 'My Project',
          message: 'Project with name "My Project" already exists',
        );

        when(() => repository.create(name: 'My Project'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(name: 'My Project');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Project'));
      });
    });

    group('load', () {
      test('should load existing project', () async {
        // Arrange
        final expectedProject = Project(
          id: 'project-1',
          name: 'My Project',
          description: 'A test project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.load('project-1'))
            .thenAnswer((_) async => Right(expectedProject));

        // Act
        final result = await repository.load('project-1');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('project-1'));
        expect(result.right.name, equals('My Project'));
        verify(() => repository.load('project-1')).called(1);
      });

      test('should load project with all properties', () async {
        // Arrange
        final settings = {'theme': 'dark'};
        final metadata = {'version': '1.0.0'};

        final expectedProject = Project(
          id: 'project-1',
          name: 'Full Project',
          description: 'Complete project data',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          settings: settings,
          metadata: metadata,
        );

        when(() => repository.load('project-1'))
            .thenAnswer((_) async => Right(expectedProject));

        // Act
        final result = await repository.load('project-1');

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.settings, isNotEmpty);
        expect(result.right.metadata, isNotEmpty);
      });

      test('should return not found error for non-existent project', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Project',
          entityId: 'non-existent',
        );

        when(() => repository.load('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.load('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Project'));
        expect(result.left.entityId, equals('non-existent'));
      });
    });

    group('save', () {
      test('should save project successfully', () async {
        // Arrange
        final project = Project(
          id: 'project-1',
          name: 'My Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.save(project))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await repository.save(project);

        // Assert
        expect(result.isRight, isTrue);
        verify(() => repository.save(project)).called(1);
      });

      test('should save project with updated settings', () async {
        // Arrange
        final project = Project(
          id: 'project-1',
          name: 'My Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          settings: {'theme': 'light', 'fontSize': 14},
        );

        when(() => repository.save(project))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await repository.save(project);

        // Assert
        expect(result.isRight, isTrue);
        verify(() => repository.save(project)).called(1);
      });

      test('should return not found error when saving non-existent project',
          () async {
        // Arrange
        final project = Project(
          id: 'non-existent',
          name: 'Ghost Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        final failure = DomainFailure.notFound(
          entityType: 'Project',
          entityId: 'non-existent',
        );

        when(() => repository.save(project))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.save(project);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Project'));
      });

      test('should return validation error for invalid project data',
          () async {
        // Arrange
        final project = Project(
          id: 'project-1',
          name: '',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'Project name cannot be empty',
        );

        when(() => repository.save(project))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.save(project);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));
      });
    });

    group('delete', () {
      test('should delete project successfully', () async {
        // Arrange
        when(() => repository.delete('project-1'))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await repository.delete('project-1');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => repository.delete('project-1')).called(1);
      });

      test('should return not found error when deleting non-existent project',
          () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Project',
          entityId: 'non-existent',
        );

        when(() => repository.delete('non-existent'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('non-existent');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Project'));
      });

      test('should return permission denied error for protected project',
          () async {
        // Arrange
        final failure = DomainFailure.permissionDenied(
          operation: 'delete',
          resource: 'project-1',
          message: 'Cannot delete default project',
        );

        when(() => repository.delete('project-1'))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.delete('project-1');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.operation, equals('delete'));
      });
    });

    group('watch', () {
      test('should emit project updates', () async {
        // Arrange
        final project1 = Project(
          id: 'project-1',
          name: 'My Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        final project2 = Project(
          id: 'project-1',
          name: 'Updated Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now.add(const Duration(seconds: 1)),
        );

        when(() => repository.watch('project-1'))
            .thenAnswer((_) => Stream.fromIterable([
                  Right(project1),
                  Right(project2),
                ]));

        // Act
        final stream = repository.watch('project-1');
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, equals(2));
        expect(results[0].isRight, isTrue);
        expect(results[0].right.name, equals('My Project'));
        expect(results[1].isRight, isTrue);
        expect(results[1].right.name, equals('Updated Project'));
      });

      test('should emit settings updates', () async {
        // Arrange
        final project1 = Project(
          id: 'project-1',
          name: 'My Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          settings: {'theme': 'light'},
        );

        final project2 = Project(
          id: 'project-1',
          name: 'My Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now.add(const Duration(seconds: 1)),
          settings: {'theme': 'dark'},
        );

        when(() => repository.watch('project-1'))
            .thenAnswer((_) => Stream.fromIterable([
                  Right(project1),
                  Right(project2),
                ]));

        // Act
        final stream = repository.watch('project-1');
        final results = await stream.take(2).toList();

        // Assert
        expect(results[0].right.settings['theme'], equals('light'));
        expect(results[1].right.settings['theme'], equals('dark'));
      });

      test('should emit error when project not found', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Project',
          entityId: 'non-existent',
        );

        when(() => repository.watch('non-existent'))
            .thenAnswer((_) => Stream.value(Left(failure)));

        // Act
        final stream = repository.watch('non-existent');
        final result = await stream.first;

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.entityType, equals('Project'));
      });
    });

    group('listAll', () {
      test('should list all projects', () async {
        // Arrange
        final projects = [
          Project(
            id: 'project-1',
            name: 'Project 1',
            rootFolderId: 'root-1',
            createdAt: now,
            updatedAt: now,
          ),
          Project(
            id: 'project-2',
            name: 'Project 2',
            rootFolderId: 'root-2',
            createdAt: now,
            updatedAt: now,
          ),
          Project(
            id: 'project-3',
            name: 'Project 3',
            rootFolderId: 'root-3',
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => repository.listAll())
            .thenAnswer((_) async => Right(projects));

        // Act
        final result = await repository.listAll();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.length, equals(3));
        expect(result.right[0].name, equals('Project 1'));
        expect(result.right[1].name, equals('Project 2'));
        expect(result.right[2].name, equals('Project 3'));
        verify(() => repository.listAll()).called(1);
      });

      test('should return empty list when no projects exist', () async {
        // Arrange
        when(() => repository.listAll())
            .thenAnswer((_) async => const Right([]));

        // Act
        final result = await repository.listAll();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right, isEmpty);
      });

      test('should list projects with different configurations', () async {
        // Arrange
        final projects = [
          Project(
            id: 'project-1',
            name: 'Basic Project',
            rootFolderId: 'root-1',
            createdAt: now,
            updatedAt: now,
          ),
          Project(
            id: 'project-2',
            name: 'Configured Project',
            description: 'A well configured project',
            rootFolderId: 'root-2',
            createdAt: now,
            updatedAt: now,
            settings: {'theme': 'dark'},
            metadata: {'version': '1.0.0'},
          ),
        ];

        when(() => repository.listAll())
            .thenAnswer((_) async => Right(projects));

        // Act
        final result = await repository.listAll();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right[0].description, isNull);
        expect(result.right[1].description, isNotNull);
        expect(result.right[1].settings, isNotEmpty);
      });
    });

    group('getCurrent', () {
      test('should get current active project', () async {
        // Arrange
        final currentProject = Project(
          id: 'project-1',
          name: 'Active Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.getCurrent())
            .thenAnswer((_) async => Right(currentProject));

        // Act
        final result = await repository.getCurrent();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.id, equals('project-1'));
        expect(result.right.name, equals('Active Project'));
        verify(() => repository.getCurrent()).called(1);
      });

      test('should return not found error when no current project', () async {
        // Arrange
        final failure = DomainFailure.notFound(
          entityType: 'Project',
          entityId: 'current',
          message: 'No active project',
        );

        when(() => repository.getCurrent())
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.getCurrent();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.message, contains('No active project'));
      });
    });

    group('use cases', () {
      test('should handle complete project lifecycle', () async {
        // Arrange - Create project
        final createdProject = Project(
          id: 'project-1',
          name: 'New Project',
          description: 'A new project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(
              name: 'New Project',
              description: 'A new project',
            )).thenAnswer((_) async => Right(createdProject));

        // Act - Create
        final createResult = await repository.create(
          name: 'New Project',
          description: 'A new project',
        );

        // Assert - Created
        expect(createResult.isRight, isTrue);

        // Arrange - Update name
        final updatedProject = createdProject.updateName('Renamed Project');
        when(() => repository.save(updatedProject))
            .thenAnswer((_) async => const Right(null));

        // Act - Save with new name
        final saveResult = await repository.save(updatedProject);

        // Assert - Saved
        expect(saveResult.isRight, isTrue);

        // Arrange - Update settings
        final configuredProject = updatedProject.updateSettings({
          'theme': 'dark',
          'autoSave': true,
        });
        when(() => repository.save(configuredProject))
            .thenAnswer((_) async => const Right(null));

        // Act - Save with settings
        final settingsResult = await repository.save(configuredProject);

        // Assert - Settings saved
        expect(settingsResult.isRight, isTrue);

        // Arrange - Delete
        when(() => repository.delete('project-1'))
            .thenAnswer((_) async => const Right(null));

        // Act - Delete
        final deleteResult = await repository.delete('project-1');

        // Assert - Deleted
        expect(deleteResult.isRight, isTrue);
      });

      test('should handle project configuration management', () async {
        // Arrange - Create project with initial settings
        final project = Project(
          id: 'project-1',
          name: 'Configured Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          settings: {
            'theme': 'light',
            'fontSize': 12,
            'autoSave': false,
          },
        );

        when(() => repository.create(
              name: 'Configured Project',
              settings: project.settings,
            )).thenAnswer((_) async => Right(project));

        // Act - Create
        final createResult = await repository.create(
          name: 'Configured Project',
          settings: project.settings,
        );

        // Assert - Created with settings
        expect(createResult.isRight, isTrue);
        expect(createResult.right.settings['theme'], equals('light'));

        // Arrange - Update settings
        final newSettings = {
          'theme': 'dark',
          'fontSize': 14,
          'autoSave': true,
        };
        final updatedProject = project.updateSettings(newSettings);

        when(() => repository.save(updatedProject))
            .thenAnswer((_) async => const Right(null));

        // Act - Save updated settings
        final saveResult = await repository.save(updatedProject);

        // Assert - Settings updated
        expect(saveResult.isRight, isTrue);
      });

      test('should handle multi-project management', () async {
        // Arrange - Create multiple projects
        final project1 = Project(
          id: 'project-1',
          name: 'Web App',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
        );

        final project2 = Project(
          id: 'project-2',
          name: 'Mobile App',
          rootFolderId: 'root-2',
          createdAt: now,
          updatedAt: now,
        );

        when(() => repository.create(name: 'Web App'))
            .thenAnswer((_) async => Right(project1));

        when(() => repository.create(name: 'Mobile App'))
            .thenAnswer((_) async => Right(project2));

        // Act - Create projects
        final result1 = await repository.create(name: 'Web App');
        final result2 = await repository.create(name: 'Mobile App');

        // Assert - Both created
        expect(result1.isRight, isTrue);
        expect(result2.isRight, isTrue);

        // Arrange - List all projects
        when(() => repository.listAll())
            .thenAnswer((_) async => Right([project1, project2]));

        // Act - List
        final listResult = await repository.listAll();

        // Assert - Both listed
        expect(listResult.isRight, isTrue);
        expect(listResult.right.length, equals(2));

        // Arrange - Set current project
        when(() => repository.getCurrent())
            .thenAnswer((_) async => Right(project1));

        // Act - Get current
        final currentResult = await repository.getCurrent();

        // Assert - Current project retrieved
        expect(currentResult.isRight, isTrue);
        expect(currentResult.right.id, equals('project-1'));
      });

      test('should validate project data consistency', () async {
        // Arrange - Try to create project with empty name
        final failure = DomainFailure.validationError(
          field: 'name',
          reason: 'Project name cannot be empty',
        );

        when(() => repository.create(name: ''))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await repository.create(name: '');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('name'));

        // Should not proceed with invalid data
        verifyNever(() => repository.save(any()));
      });

      test('should track project metadata', () async {
        // Arrange - Create project with metadata
        final metadata = {
          'version': '1.0.0',
          'author': 'John Doe',
          'tags': ['flutter', 'web'],
          'created_by': 'editor',
        };

        final project = Project(
          id: 'project-1',
          name: 'Tagged Project',
          rootFolderId: 'root-1',
          createdAt: now,
          updatedAt: now,
          metadata: metadata,
        );

        when(() => repository.create(
              name: 'Tagged Project',
              metadata: metadata,
            )).thenAnswer((_) async => Right(project));

        // Act
        final result = await repository.create(
          name: 'Tagged Project',
          metadata: metadata,
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right.metadata['version'], equals('1.0.0'));
        expect(result.right.metadata['tags'], isA<List>());
        expect(result.right.metadata['tags'], contains('flutter'));
      });
    });
  });
}

extension on Either<DomainFailure, Project> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
  Project get right => fold((_) => throw StateError('Left'), (r) => r);
}

extension on Either<DomainFailure, void> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
}

extension on Either<DomainFailure, List<Project>> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
  List<Project> get right => fold((_) => throw StateError('Left'), (r) => r);
}
