import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/src/domain/entities/file_document.dart';
import 'package:multi_editor_core/src/domain/entities/folder.dart';
import 'package:multi_editor_core/src/ports/events/editor_event.dart';
import 'package:multi_editor_core/src/ports/events/event_bus.dart';

class MockEventBus extends Mock implements EventBus {}

class FakeEditorEvent extends Fake implements EditorEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeEditorEvent());
  });

  group('EventBus', () {
    late MockEventBus eventBus;
    late DateTime now;

    setUp(() {
      eventBus = MockEventBus();
      now = DateTime.now();
    });

    tearDown(() {
      // Cleanup
      reset(eventBus);
    });

    group('publish', () {
      test('should publish file opened event', () {
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

        final event = EditorEvent.fileOpened(file: file);

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file closed event', () {
        // Arrange
        final event = const EditorEvent.fileClosed(fileId: 'file-1');

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file content changed event', () {
        // Arrange
        final event = const EditorEvent.fileContentChanged(
          fileId: 'file-1',
          content: 'new content',
        );

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file saved event', () {
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

        final event = EditorEvent.fileSaved(file: file);

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file created event', () {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: 'new_file.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final event = EditorEvent.fileCreated(file: file);

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file deleted event', () {
        // Arrange
        final event = const EditorEvent.fileDeleted(fileId: 'file-1');

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file renamed event', () {
        // Arrange
        final event = const EditorEvent.fileRenamed(
          fileId: 'file-1',
          oldName: 'old_name.dart',
          newName: 'new_name.dart',
        );

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish file moved event', () {
        // Arrange
        final event = const EditorEvent.fileMoved(
          fileId: 'file-1',
          oldFolderId: 'folder-1',
          newFolderId: 'folder-2',
        );

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish folder created event', () {
        // Arrange
        final folder = Folder(
          id: 'folder-1',
          name: 'src',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        final event = EditorEvent.folderCreated(folder: folder);

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish folder deleted event', () {
        // Arrange
        final event = const EditorEvent.folderDeleted(folderId: 'folder-1');

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish folder renamed event', () {
        // Arrange
        final event = const EditorEvent.folderRenamed(
          folderId: 'folder-1',
          oldName: 'old_name',
          newName: 'new_name',
        );

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish folder moved event', () {
        // Arrange
        final event = const EditorEvent.folderMoved(
          folderId: 'folder-1',
          oldParentId: 'parent-1',
          newParentId: 'parent-2',
        );

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish project changed event', () {
        // Arrange
        final event =
            const EditorEvent.projectChanged(projectId: 'project-1');

        when(() => eventBus.publish(event)).thenReturn(null);

        // Act
        eventBus.publish(event);

        // Assert
        verify(() => eventBus.publish(event)).called(1);
      });

      test('should publish multiple events in sequence', () {
        // Arrange
        final event1 = const EditorEvent.fileClosed(fileId: 'file-1');
        final event2 = const EditorEvent.fileClosed(fileId: 'file-2');
        final event3 = const EditorEvent.fileClosed(fileId: 'file-3');

        when(() => eventBus.publish(any())).thenReturn(null);

        // Act
        eventBus.publish(event1);
        eventBus.publish(event2);
        eventBus.publish(event3);

        // Assert
        verify(() => eventBus.publish(event1)).called(1);
        verify(() => eventBus.publish(event2)).called(1);
        verify(() => eventBus.publish(event3)).called(1);
      });
    });

    group('stream', () {
      test('should provide stream of all events', () {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final events = [
          EditorEvent.fileOpened(file: file),
          const EditorEvent.fileClosed(fileId: 'file-1'),
          const EditorEvent.projectChanged(projectId: 'project-1'),
        ];

        when(() => eventBus.stream)
            .thenAnswer((_) => Stream.fromIterable(events));

        // Act
        final stream = eventBus.stream;

        // Assert
        expect(stream, emitsInOrder(events));
      });

      test('should emit events in order', () async {
        // Arrange
        final controller = StreamController<EditorEvent>();

        when(() => eventBus.stream).thenAnswer((_) => controller.stream);

        final file = FileDocument(
          id: 'file-1',
          name: 'test.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final event1 = EditorEvent.fileCreated(file: file);
        final event2 = EditorEvent.fileOpened(file: file);
        final event3 = EditorEvent.fileSaved(file: file);

        // Act
        final stream = eventBus.stream;
        final future = stream.take(3).toList();

        controller.add(event1);
        controller.add(event2);
        controller.add(event3);

        final results = await future;

        // Assert
        expect(results.length, equals(3));
        expect(results[0], equals(event1));
        expect(results[1], equals(event2));
        expect(results[2], equals(event3));

        await controller.close();
      });

      test('should handle empty stream', () {
        // Arrange
        when(() => eventBus.stream)
            .thenAnswer((_) => const Stream<EditorEvent>.empty());

        // Act
        final stream = eventBus.stream;

        // Assert
        expect(stream, emitsDone);
      });
    });

    group('on<T>', () {
      test('should filter file opened events', () {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final events = [
          EditorEvent.fileOpened(file: file),
          EditorEvent.fileOpened(file: file.copyWith(id: 'file-2')),
        ];

        when(() => eventBus.on<FileOpened>())
            .thenAnswer((_) => Stream.fromIterable(events.cast<FileOpened>()));

        // Act
        final stream = eventBus.on<FileOpened>();

        // Assert
        expect(stream, emitsInOrder(events.cast<FileOpened>()));
      });

      test('should filter file closed events', () {
        // Arrange
        final events = [
          const EditorEvent.fileClosed(fileId: 'file-1'),
          const EditorEvent.fileClosed(fileId: 'file-2'),
        ];

        when(() => eventBus.on<FileClosed>())
            .thenAnswer((_) => Stream.fromIterable(events.cast<FileClosed>()));

        // Act
        final stream = eventBus.on<FileClosed>();

        // Assert
        expect(stream, emitsInOrder(events.cast<FileClosed>()));
      });

      test('should filter file content changed events', () {
        // Arrange
        final events = [
          const EditorEvent.fileContentChanged(
            fileId: 'file-1',
            content: 'content 1',
          ),
          const EditorEvent.fileContentChanged(
            fileId: 'file-1',
            content: 'content 2',
          ),
        ];

        when(() => eventBus.on<FileContentChanged>()).thenAnswer(
            (_) => Stream.fromIterable(events.cast<FileContentChanged>()));

        // Act
        final stream = eventBus.on<FileContentChanged>();

        // Assert
        expect(stream, emitsInOrder(events.cast<FileContentChanged>()));
      });

      test('should filter file saved events', () {
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

        final events = [
          EditorEvent.fileSaved(file: file),
          EditorEvent.fileSaved(
              file: file.updateContent('void main() { print("hello"); }')),
        ];

        when(() => eventBus.on<FileSaved>())
            .thenAnswer((_) => Stream.fromIterable(events.cast<FileSaved>()));

        // Act
        final stream = eventBus.on<FileSaved>();

        // Assert
        expect(stream, emitsInOrder(events.cast<FileSaved>()));
      });

      test('should filter folder events', () {
        // Arrange
        final folder = Folder(
          id: 'folder-1',
          name: 'src',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        final events = [
          EditorEvent.folderCreated(folder: folder),
        ];

        when(() => eventBus.on<FolderCreated>()).thenAnswer(
            (_) => Stream.fromIterable(events.cast<FolderCreated>()));

        // Act
        final stream = eventBus.on<FolderCreated>();

        // Assert
        expect(stream, emitsInOrder(events.cast<FolderCreated>()));
      });

      test('should filter project changed events', () {
        // Arrange
        final events = [
          const EditorEvent.projectChanged(projectId: 'project-1'),
          const EditorEvent.projectChanged(projectId: 'project-2'),
        ];

        when(() => eventBus.on<ProjectChanged>()).thenAnswer(
            (_) => Stream.fromIterable(events.cast<ProjectChanged>()));

        // Act
        final stream = eventBus.on<ProjectChanged>();

        // Assert
        expect(stream, emitsInOrder(events.cast<ProjectChanged>()));
      });

      test('should return empty stream for unmatched event type', () {
        // Arrange
        when(() => eventBus.on<FileOpened>())
            .thenAnswer((_) => const Stream<FileOpened>.empty());

        // Act
        final stream = eventBus.on<FileOpened>();

        // Assert
        expect(stream, emitsDone);
      });
    });

    group('dispose', () {
      test('should dispose event bus', () {
        // Arrange
        when(() => eventBus.dispose()).thenReturn(null);

        // Act
        eventBus.dispose();

        // Assert
        verify(() => eventBus.dispose()).called(1);
      });

      test('should not emit events after dispose', () {
        // Arrange
        final controller = StreamController<EditorEvent>();

        when(() => eventBus.stream).thenAnswer((_) => controller.stream);
        when(() => eventBus.dispose()).thenAnswer((_) {
          controller.close();
          return null;
        });

        // Act
        eventBus.dispose();

        // Assert
        verify(() => eventBus.dispose()).called(1);
        expect(controller.isClosed, isTrue);
      });
    });

    group('use cases', () {
      test('should handle file editing workflow', () async {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final controller = StreamController<EditorEvent>();

        when(() => eventBus.stream).thenAnswer((_) => controller.stream);
        when(() => eventBus.publish(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments[0] as EditorEvent;
          controller.add(event);
          return null;
        });

        // Act - File workflow
        final streamFuture = eventBus.stream.take(5).toList();

        // Create file
        eventBus.publish(EditorEvent.fileCreated(file: file));

        // Open file
        eventBus.publish(EditorEvent.fileOpened(file: file));

        // Edit content
        eventBus.publish(const EditorEvent.fileContentChanged(
          fileId: 'file-1',
          content: 'void main() {}',
        ));

        // Save file
        final updatedFile = file.updateContent('void main() {}');
        eventBus.publish(EditorEvent.fileSaved(file: updatedFile));

        // Close file
        eventBus.publish(const EditorEvent.fileClosed(fileId: 'file-1'));

        final events = await streamFuture;

        // Assert
        expect(events.length, equals(5));
        expect(events[0], isA<FileCreated>());
        expect(events[1], isA<FileOpened>());
        expect(events[2], isA<FileContentChanged>());
        expect(events[3], isA<FileSaved>());
        expect(events[4], isA<FileClosed>());

        await controller.close();
      });

      test('should handle folder operations', () async {
        // Arrange
        final folder = Folder(
          id: 'folder-1',
          name: 'src',
          parentId: 'root',
          createdAt: now,
          updatedAt: now,
        );

        final controller = StreamController<EditorEvent>();

        when(() => eventBus.stream).thenAnswer((_) => controller.stream);
        when(() => eventBus.publish(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments[0] as EditorEvent;
          controller.add(event);
          return null;
        });

        // Act
        final streamFuture = eventBus.stream.take(3).toList();

        eventBus.publish(EditorEvent.folderCreated(folder: folder));
        eventBus.publish(const EditorEvent.folderRenamed(
          folderId: 'folder-1',
          oldName: 'src',
          newName: 'lib',
        ));
        eventBus.publish(const EditorEvent.folderDeleted(folderId: 'folder-1'));

        final events = await streamFuture;

        // Assert
        expect(events.length, equals(3));
        expect(events[0], isA<FolderCreated>());
        expect(events[1], isA<FolderRenamed>());
        expect(events[2], isA<FolderDeleted>());

        await controller.close();
      });

      test('should handle multiple listeners', () async {
        // Arrange
        final file = FileDocument(
          id: 'file-1',
          name: 'main.dart',
          folderId: 'folder-1',
          content: '',
          language: 'dart',
          createdAt: now,
          updatedAt: now,
        );

        final controller = StreamController<EditorEvent>.broadcast();

        when(() => eventBus.stream).thenAnswer((_) => controller.stream);
        when(() => eventBus.on<FileOpened>()).thenAnswer(
            (_) => controller.stream.where((e) => e is FileOpened).cast());
        when(() => eventBus.on<FileSaved>()).thenAnswer(
            (_) => controller.stream.where((e) => e is FileSaved).cast());

        // Act
        final openedFuture = eventBus.on<FileOpened>().first;
        final savedFuture = eventBus.on<FileSaved>().first;

        controller.add(EditorEvent.fileOpened(file: file));
        controller.add(EditorEvent.fileSaved(file: file));

        final openedEvent = await openedFuture;
        final savedEvent = await savedFuture;

        // Assert
        expect(openedEvent, isA<FileOpened>());
        expect(savedEvent, isA<FileSaved>());

        await controller.close();
      });

      test('should handle project switching', () async {
        // Arrange
        final controller = StreamController<EditorEvent>();

        when(() => eventBus.stream).thenAnswer((_) => controller.stream);
        when(() => eventBus.publish(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments[0] as EditorEvent;
          controller.add(event);
          return null;
        });

        // Act
        final streamFuture = eventBus.stream.take(2).toList();

        eventBus
            .publish(const EditorEvent.projectChanged(projectId: 'project-1'));
        eventBus
            .publish(const EditorEvent.projectChanged(projectId: 'project-2'));

        final events = await streamFuture;

        // Assert
        expect(events.length, equals(2));
        expect(events[0], isA<ProjectChanged>());
        expect(events[1], isA<ProjectChanged>());

        await controller.close();
      });
    });
  });
}
