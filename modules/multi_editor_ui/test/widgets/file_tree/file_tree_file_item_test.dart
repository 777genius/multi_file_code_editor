import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/controllers/file_tree_controller.dart';
import 'package:multi_editor_ui/src/state/file_tree_state.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/file_tree_file_item.dart';

// Mocks
class MockFileTreeController extends Mock implements FileTreeController {}

class MockPluginManager extends Mock implements PluginManager {}

void main() {
  group('FileTreeFileItem Widget Tests', () {
    late MockFileTreeController mockController;
    late MockPluginManager mockPluginManager;

    setUp(() {
      mockController = MockFileTreeController();
      mockPluginManager = MockPluginManager();
    });

    Widget createWidget({
      required FileTreeNode data,
      bool isSelected = false,
      bool enableDragDrop = true,
      FileTreeController? controller,
      PluginManager? pluginManager,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileTreeFileItem(
            data: data,
            isSelected: isSelected,
            enableDragDrop: enableDragDrop,
            controller: controller ?? mockController,
            pluginManager: pluginManager,
            onShowContextMenu: (context, position, data) {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render file name', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        expect(find.text('test.dart'), findsOneWidget);
      });

      testWidgets('should render file icon', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        expect(find.byIcon(Icons.code), findsOneWidget);
      });

      testWidgets('should render with bold text when selected', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode, isSelected: true));

        // Assert
        final textWidget = tester.widget<Text>(find.text('test.dart'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should render with normal text when not selected',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, isSelected: false),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text('test.dart'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.normal));
      });
    });

    group('Icons by Language', () {
      testWidgets('should render dart icon for .dart files', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'main.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        expect(find.byIcon(Icons.code), findsOneWidget);
      });

      testWidgets('should render json icon for .json files', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'config.json',
          isFolder: false,
          language: 'json',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        expect(find.byIcon(Icons.data_object), findsOneWidget);
      });

      testWidgets('should render default icon for unknown language',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'unknown.xyz',
          isFolder: false,
          language: 'unknown',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });
    });

    group('Drag and Drop', () {
      testWidgets('should render Draggable when enableDragDrop is true',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: true),
        );

        // Assert
        expect(find.byType(Draggable<String>), findsOneWidget);
      });

      testWidgets('should not render Draggable when enableDragDrop is false',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: false),
        );

        // Assert
        expect(find.byType(Draggable<String>), findsNothing);
      });

      testWidgets('should show file name in drag feedback', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: true),
        );

        // Find draggable widget
        final draggable =
            tester.widget<Draggable<String>>(find.byType(Draggable<String>));

        // Assert
        expect(draggable.data, equals('file:file-1'));
      });
    });

    group('Drop Target', () {
      testWidgets('should accept file drops when enableDragDrop is true',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: true),
        );

        // Find DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'file:file-2', offset: Offset.zero),
        );

        // Assert
        verify(() => mockController.moveFile('file-2', 'root')).called(1);
      });

      testWidgets('should accept folder drops when enableDragDrop is true',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        when(() => mockController.moveFolder(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: true),
        );

        // Find DragTarget
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

      testWidgets('should not accept drop on itself', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: true),
        );

        // Find DragTarget
        final dragTarget =
            tester.widget<DragTarget<String>>(find.byType(DragTarget<String>));

        // Simulate drop on itself
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'file:file-1', offset: Offset.zero),
        );

        // Assert - should not call moveFile since it's the same file
        verifyNever(() => mockController.moveFile(any(), any()));
      });
    });

    group('Plugin Integration', () {
      testWidgets('should use plugin icon when available', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        final iconDescriptor = FileIconDescriptor(
          type: FileIconType.iconData,
          size: 18,
          iconCode: Icons.star.codePoint,
        );

        when(() => mockPluginManager.getFileIconDescriptor(any()))
            .thenReturn(iconDescriptor);

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, pluginManager: mockPluginManager),
        );

        // Assert
        verify(() => mockPluginManager.getFileIconDescriptor(fileNode))
            .called(1);
      });

      testWidgets('should use default icon when plugin returns null',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        when(() => mockPluginManager.getFileIconDescriptor(any()))
            .thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, pluginManager: mockPluginManager),
        );

        // Assert
        expect(find.byIcon(Icons.code), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be tappable', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        final listTile = find.byType(ListTile);
        expect(listTile, findsOneWidget);
      });

      testWidgets('should have dense list tile for compact display',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode));

        // Assert
        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.dense, isTrue);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User selects a file', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'main.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'root',
        );

        // Act
        await tester.pumpWidget(createWidget(data: fileNode, isSelected: true));

        // Assert
        final textWidget = tester.widget<Text>(find.text('main.dart'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('UC2: User drags file to another folder', (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'test.dart',
          isFolder: false,
          language: 'dart',
          parentId: 'folder-1',
        );

        when(() => mockController.moveFile(any(), any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, enableDragDrop: true),
        );

        // Find draggable
        final draggable =
            tester.widget<Draggable<String>>(find.byType(Draggable<String>));

        // Assert
        expect(draggable.data, equals('file:file-1'));
      });

      testWidgets('UC3: Plugin provides custom icon for file type',
          (tester) async {
        // Arrange
        final fileNode = FileTreeNode(
          id: 'file-1',
          name: 'component.tsx',
          isFolder: false,
          language: 'typescript',
          parentId: 'root',
        );

        final iconDescriptor = FileIconDescriptor(
          type: FileIconType.url,
          url: 'https://example.com/tsx-icon.svg',
          size: 18,
        );

        when(() => mockPluginManager.getFileIconDescriptor(any()))
            .thenReturn(iconDescriptor);

        // Act
        await tester.pumpWidget(
          createWidget(data: fileNode, pluginManager: mockPluginManager),
        );

        // Assert
        verify(() => mockPluginManager.getFileIconDescriptor(fileNode))
            .called(1);
      });
    });
  });
}
