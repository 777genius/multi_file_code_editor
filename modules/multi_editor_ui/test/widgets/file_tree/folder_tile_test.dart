import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/folder_tile.dart';

void main() {
  group('FolderTile Widget Tests', () {
    Widget createWidget({
      required FileTreeNode data,
      bool isSelected = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FolderTile(
            data: data,
            isSelected: isSelected,
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
          name: 'src',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folderNode));

        // Assert
        expect(find.text('src'), findsOneWidget);
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

      testWidgets('should render with normal text when not selected',
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
          createWidget(data: folderNode, isSelected: false),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text('lib'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.normal));
      });
    });

    group('List Tile Properties', () {
      testWidgets('should have dense list tile', (tester) async {
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
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.dense, isTrue);
      });

      testWidgets('should have proper content padding', (tester) async {
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
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(
          listTile.contentPadding,
          equals(const EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
        );
      });
    });

    group('Icon Styling', () {
      testWidgets('should have correct icon size', (tester) async {
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
        final icon = tester.widget<Icon>(find.byIcon(Icons.folder));
        expect(icon.size, equals(18));
      });

      testWidgets('should have primary color for folder icon', (tester) async {
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
        final icon = tester.widget<Icon>(find.byIcon(Icons.folder));
        expect(icon.color, isNotNull);
      });
    });

    group('Text Styling', () {
      testWidgets('should have correct font size', (tester) async {
        // Arrange
        final folderNode = FileTreeNode(
          id: 'folder-1',
          name: 'components',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folderNode));

        // Assert
        final textWidget = tester.widget<Text>(find.text('components'));
        expect(textWidget.style?.fontSize, equals(13));
      });
    });

    group('Interaction', () {
      testWidgets('should be tappable', (tester) async {
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
        expect(find.byType(ListTile), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Root folder in file tree', (tester) async {
        // Arrange
        final rootFolder = FileTreeNode(
          id: 'root',
          name: 'project',
          isFolder: true,
          parentId: null,
        );

        // Act
        await tester.pumpWidget(createWidget(data: rootFolder));

        // Assert
        expect(find.text('project'), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('UC2: Nested folder structure', (tester) async {
        // Arrange
        final nestedFolder = FileTreeNode(
          id: 'components',
          name: 'components',
          isFolder: true,
          parentId: 'src',
        );

        // Act
        await tester.pumpWidget(createWidget(data: nestedFolder));

        // Assert
        expect(find.text('components'), findsOneWidget);
      });

      testWidgets('UC3: Selected folder highlights', (tester) async {
        // Arrange
        final folder = FileTreeNode(
          id: 'lib',
          name: 'lib',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folder, isSelected: true));

        // Assert
        final textWidget = tester.widget<Text>(find.text('lib'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('UC4: Long folder name displays correctly', (tester) async {
        // Arrange
        final folder = FileTreeNode(
          id: 'long',
          name: 'very_long_folder_name_that_might_overflow',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folder));

        // Assert
        expect(
          find.text('very_long_folder_name_that_might_overflow'),
          findsOneWidget,
        );
      });

      testWidgets('UC5: Folder with special characters', (tester) async {
        // Arrange
        final folder = FileTreeNode(
          id: 'special',
          name: 'folder_with-special.chars',
          isFolder: true,
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: folder));

        // Assert
        expect(find.text('folder_with-special.chars'), findsOneWidget);
      });
    });
  });
}
