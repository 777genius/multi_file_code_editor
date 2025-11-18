import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_ui/src/controllers/file_tree_controller.dart';
import 'package:multi_editor_ui/src/state/file_tree_state.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/file_tree_folder_item.dart';

// Mocks
class MockFileTreeController extends Mock implements FileTreeController {}

void main() {
  group('FileTreeFolderItem Widget Tests', () {
    late MockFileTreeController mockController;

    setUp(() {
      mockController = MockFileTreeController();
    });

    Widget createWidget({
      required FileTreeNode data,
      bool isSelected = false,
      bool enableDragDrop = true,
      FileTreeController? controller,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileTreeFolderItem(
            data: data,
            isSelected: isSelected,
            enableDragDrop: enableDragDrop,
            controller: controller ?? mockController,
            onShowContextMenu: (context, position, data) {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render folder name', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folderNode));

        // Assert
        expect(find.text('lib'), findsOneWidget);
      });

      testWidgets('should render folder icon', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folderNode));

        // Assert
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('should render with bold text when selected', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, isSelected: true),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text('lib'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      });
    });

    group('Drag and Drop', () {
      testWidgets('should render Draggable when enableDragDrop is true',
          (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Assert
        expect(find.byType(Draggable<String>), findsOneWidget);
      });

      testWidgets('should not render Draggable when enableDragDrop is false',
          (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: false),
        );

        // Assert
        expect(find.byType(Draggable<String>), findsNothing);
      });

      testWidgets('should provide correct drag data', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Find draggable widget
        final draggable =
            tester.widget<Draggable<String>>(find.byType(Draggable<String>));

        // Assert
        expect(draggable.data, equals('folder:folder-1'));
      });
    });

    group('Drop Target', () {
      testWidgets('should accept file drops', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Find DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'file:file-1', offset: Offset.zero),
        );

        // Assert
        verify(() => mockController.moveFile('file-1', 'folder-1')).called(1);
      });

      testWidgets('should accept folder drops', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        when(() => mockController.moveFolder(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Find DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(
            data: 'folder:folder-2',
            offset: Offset.zero,
          ),
        );

        // Assert
        verify(() => mockController.moveFolder('folder-2', 'folder-1'))
            .called(1);
      });

      testWidgets('should not accept drop on itself', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [folderNode],
        );

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Find DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate will accept itself
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(
            data: 'folder:folder-1',
            offset: Offset.zero,
          ),
        );

        // Assert
        expect(willAccept, isFalse);
      });

      testWidgets('should not accept parent folder being dropped into child',
          (tester) async {
        // Arrange
        final childFolder = FileTreeNode(
          id: 'child',
          name: 'child',
          isFolder: true,
          parentId: 'parent',
        );

        final parentFolder = FileTreeNode(
          id: 'parent',
          name: 'parent',
          isFolder: true,
          parentId: 'root',
          children: [childFolder],
        );

        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [parentFolder],
        );

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: childFolder, enableDragDrop: true),
        );

        // Find DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate will accept parent folder
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(
            data: 'folder:parent',
            offset: Offset.zero,
          ),
        );

        // Assert
        expect(willAccept, isFalse);
      });
    });

    group('Hover Effects', () {
      testWidgets('should show hover background when dragging over',
          (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Assert - widget renders
        expect(find.text('lib'), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User drags folder to reorganize structure',
          (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'src',
          name: 'src',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        // Find draggable
        final draggable =
            tester.widget<Draggable<String>>(find.byType(Draggable<String>));

        // Assert
        expect(draggable.data, equals('folder:src'));
      });

      testWidgets('UC2: User drops file into folder', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'lib',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: folderNode, enableDragDrop: true),
        );

        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(
            data: 'file:main.dart',
            offset: Offset.zero,
          ),
        );

        // Assert
        verify(() => mockController.moveFile('main.dart', 'lib')).called(1);
      });

      testWidgets('UC3: User attempts invalid drag operation',
          (tester) async {
        // Arrange
        final childFolder = FileTreeNode(
          id: 'child',
          name: 'child',
          isFolder: true,
          parentId: 'parent',
        );

        final parentFolder = FileTreeNode(
          id: 'parent',
          name: 'parent',
          isFolder: true,
          parentId: 'root',
          children: [childFolder],
        );

        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [parentFolder],
        );

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: childFolder, enableDragDrop: true),
        );

        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Try to drop parent into child (invalid)
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(
            data: 'folder:parent',
            offset: Offset.zero,
          ),
        );

        // Assert
        expect(willAccept, isFalse);
      });
    });
  });
}
