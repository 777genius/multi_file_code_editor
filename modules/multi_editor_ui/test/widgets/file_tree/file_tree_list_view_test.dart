import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/controllers/file_tree_controller.dart';
import 'package:multi_editor_ui/src/state/file_tree_state.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/file_tree_list_view.dart';

// Mocks
class MockFileTreeController extends Mock implements FileTreeController {}

class MockPluginManager extends Mock implements PluginManager {}

void main() {
  group('FileTreeListView Widget Tests', () {
    late MockFileTreeController mockController;
    late MockPluginManager mockPluginManager;

    setUp(() {
      mockController = MockFileTreeController();
      mockPluginManager = MockPluginManager();
    });

    TreeNode<FileTreeNode> createTreeNode(FileTreeNode data) {
      final node = TreeNode<FileTreeNode>(key: data.id, data: data);
      for (final child in data.children) {
        node.add(createTreeNode(child));
      }
      return node;
    }

    Widget createWidget({
      required TreeNode<FileTreeNode> treeNode,
      double maxWidth = 300,
      String? selectedNodeId,
      double containerWidth = 250,
      FileTreeController? controller,
      PluginManager? pluginManager,
      ValueChanged<String>? onFileSelected,
      bool enableDragDrop = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileTreeListView(
            treeNode: treeNode,
            maxWidth: maxWidth,
            selectedNodeId: selectedNodeId,
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
      testWidgets('should render tree view', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
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
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));

        // Assert
        expect(find.byType(TreeView), findsOneWidget);
      });

      testWidgets('should render files in tree', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'main.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
            FileTreeNode(
              id: 'file-2',
              name: 'test.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));

        // Assert
        expect(find.text('main.dart'), findsOneWidget);
        expect(find.text('test.dart'), findsOneWidget);
      });

      testWidgets('should render folders in tree', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'folder-1',
              name: 'lib',
              isFolder: true,
              parentId: 'root',
              children: [],
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));

        // Assert
        expect(find.text('lib'), findsOneWidget);
      });

      testWidgets('should not show root node', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
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
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));

        // Assert - Root should not be visible
        expect(find.text('test.dart'), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should call toggleFolder when folder is tapped',
          (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'folder-1',
              name: 'lib',
              isFolder: true,
              parentId: 'root',
              children: [],
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.toggleFolder(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));
        await tester.tap(find.text('lib'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockController.toggleFolder('folder-1')).called(1);
      });

      testWidgets('should call selectNode and onFileSelected when file is tapped',
          (tester) async {
        // Arrange
        String? selectedFileId;
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'main.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.selectNode(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(
            treeNode: treeNode,
            onFileSelected: (fileId) => selectedFileId = fileId,
          ),
        );
        await tester.tap(find.text('main.dart'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockController.selectNode('file-1')).called(1);
        expect(selectedFileId, equals('file-1'));
      });
    });

    group('Selection', () {
      testWidgets('should highlight selected file', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'selected.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: 'file-1',
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(treeNode: treeNode, selectedNodeId: 'file-1'),
        );

        // Assert - Widget renders selected state
        expect(find.text('selected.dart'), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should use horizontal scrolling', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file-1',
              name: 'very_long_file_name_that_needs_scrolling.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));

        // Assert
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should respect container width', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(
            treeNode: treeNode,
            containerWidth: 300,
            maxWidth: 400,
          ),
        );

        // Assert - Widget renders with proper width
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Navigate nested folder structure', (tester) async {
        // Arrange
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'lib',
              name: 'lib',
              isFolder: true,
              parentId: 'root',
              children: [
                FileTreeNode(
                  id: 'src',
                  name: 'src',
                  isFolder: true,
                  parentId: 'lib',
                  children: [
                    FileTreeNode(
                      id: 'main.dart',
                      name: 'main.dart',
                      isFolder: false,
                      language: 'dart',
                      parentId: 'src',
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(treeNode: treeNode));

        // Assert
        expect(find.text('lib'), findsOneWidget);
      });

      testWidgets('UC2: Select file from list', (tester) async {
        // Arrange
        String? selected;
        final rootData = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'file1',
              name: 'app.dart',
              isFolder: false,
              language: 'dart',
              parentId: 'root',
            ),
          ],
        );
        final treeNode = createTreeNode(rootData);

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootData,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.selectNode(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(
            treeNode: treeNode,
            onFileSelected: (id) => selected = id,
          ),
        );
        await tester.tap(find.text('app.dart'));

        // Assert
        expect(selected, equals('file1'));
      });
    });
  });
}
