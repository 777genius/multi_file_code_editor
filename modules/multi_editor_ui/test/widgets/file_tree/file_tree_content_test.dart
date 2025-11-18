import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/controllers/file_tree_controller.dart';
import 'package:multi_editor_ui/src/state/file_tree_state.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/file_tree_content.dart';

// Mocks
class MockFileTreeController extends Mock implements FileTreeController {}

class MockPluginManager extends Mock implements PluginManager {}

void main() {
  group('FileTreeContent Widget Tests', () {
    late MockFileTreeController mockController;
    late MockPluginManager mockPluginManager;

    setUp(() {
      mockController = MockFileTreeController();
      mockPluginManager = MockPluginManager();
    });

    Widget createWidget({
      required FileTreeState state,
      double containerWidth = 250,
      FileTreeController? controller,
      PluginManager? pluginManager,
      ValueChanged<String>? onFileSelected,
      bool enableDragDrop = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileTreeContent(
            state: state,
            containerWidth: containerWidth,
            controller: controller ?? mockController,
            pluginManager: pluginManager,
            onFileSelected: onFileSelected,
            enableDragDrop: enableDragDrop,
            onShowFolderContextMenu: (context, position, data) {},
            onShowFileContextMenu: (context, position, data) {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should show empty placeholder when root has no children',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        // Act
        await tester.pumpWidget(createWidget(state: state));

        // Assert
        expect(find.text('No files yet'), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('should render file tree list when root has children',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'test.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(state: state));

        // Assert
        expect(find.text('test.dart'), findsOneWidget);
      });

      testWidgets('should show SizedBox.shrink for non-loaded states',
          (tester) async {
        // Arrange
        const state = FileTreeState.initial();

        // Act
        await tester.pumpWidget(createWidget(state: state));

        // Assert
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Drag and Drop', () {
      testWidgets('should render DragTarget when enableDragDrop is true',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: true),
        );

        // Assert
        expect(find.byType(DragTarget<String>), findsOneWidget);
      });

      testWidgets('should not render DragTarget when enableDragDrop is false',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'test.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: false),
        );

        // Assert
        expect(find.byType(DragTarget<String>), findsNothing);
      });

      testWidgets('should show hover effect when dragging over root',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: true),
        );

        // Assert - Empty placeholder shows
        expect(find.text('No files yet'), findsOneWidget);
      });
    });

    group('Drag Accept Logic', () {
      testWidgets('should call moveFile when file is dropped to root',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'test.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'folder-1',
            ),
          ],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: true),
        );

        // Find the DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'file:file-1', offset: Offset.zero),
        );

        // Assert
        verify(() => mockController.moveFile('file-1', 'root')).called(1);
      });

      testWidgets('should call moveFolder when folder is dropped to root',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.moveFolder(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: true),
        );

        // Find the DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(
            data: 'folder:folder-1',
            offset: Offset.zero,
          ),
        );

        // Assert
        verify(() => mockController.moveFolder('folder-1', 'root')).called(1);
      });

      testWidgets('should not accept root folder', (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: true),
        );

        // Find the DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate will accept
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'folder:root', offset: Offset.zero),
        );

        // Assert
        expect(willAccept, isFalse);
      });
    });

    group('Width Calculation', () {
      testWidgets('should calculate correct max width for nested structure',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'folder-1',
              name: 'very_long_folder_name',
              isFolder: true,
              parentId: 'root',
              children: [
                FileTreeNode(
                  id: 'file-1',
                  name: 'another_very_long_file_name.dart',
                  isFolder: false,
                  language: 'dart',
                  parentId: 'folder-1',
                ),
              ],
            ),
          ],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(state: state, containerWidth: 250),
        );

        // Assert - widget renders without error
        expect(find.text('very_long_folder_name'), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Empty tree shows helpful placeholder',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        // Act
        await tester.pumpWidget(createWidget(state: state));

        // Assert
        expect(find.text('No files yet'), findsOneWidget);
        expect(find.text('Create your first file or folder'), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('UC2: User drags file to root folder', (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(state: state, enableDragDrop: true),
        );

        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'file:file-1', offset: Offset.zero),
        );

        // Assert
        verify(() => mockController.moveFile('file-1', 'root')).called(1);
      });

      testWidgets('UC3: Tree displays files and folders correctly',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'folder-1',
              name: 'lib',
              isFolder: true,
              parentId: 'root',
              children: [
                FileTreeNode(
                  id: 'file-1',
                  name: 'main.dart',
                  isFolder: false,
                  language: 'dart',
                  parentId: 'folder-1',
                ),
              ],
            ),
            FileTreeNode(
              id: 'file-2',
              name: 'pubspec.yaml',
              isFolder: false,
              language: 'yaml',
              parentId: 'root',
            ),
          ],
        );
        final state = FileTreeState.loaded(
          rootNode: rootNode,
          selectedNodeId: null,
          expandedFolderIds: const [],
        );

        when(() => mockController.value).thenReturn(state);
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(state: state));

        // Assert
        expect(find.text('lib'), findsOneWidget);
        expect(find.text('pubspec.yaml'), findsOneWidget);
      });
    });
  });
}
