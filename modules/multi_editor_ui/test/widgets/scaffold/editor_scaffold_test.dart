import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/controllers/editor_controller.dart';
import 'package:multi_editor_ui/src/controllers/file_tree_controller.dart';
import 'package:multi_editor_ui/src/state/editor_state.dart';
import 'package:multi_editor_ui/src/state/file_tree_state.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/editor_scaffold.dart';

// Mocks
class MockFileTreeController extends Mock implements FileTreeController {}

class MockEditorController extends Mock implements EditorController {}

class MockPluginManager extends Mock implements PluginManager {}

class MockPluginUIService extends Mock implements PluginUIService {}

void main() {
  group('EditorScaffold Widget Tests', () {
    late MockFileTreeController mockFileTreeController;
    late MockEditorController mockEditorController;
    late MockPluginManager mockPluginManager;
    late MockPluginUIService mockPluginUIService;

    setUp(() {
      mockFileTreeController = MockFileTreeController();
      mockEditorController = MockEditorController();
      mockPluginManager = MockPluginManager();
      mockPluginUIService = MockPluginUIService();

      when(() => mockPluginManager.plugins).thenReturn([]);
    });

    Widget createWidget({
      FileTreeController? fileTreeController,
      EditorController? editorController,
      PluginManager? pluginManager,
      PluginUIService? pluginUIService,
      double treeWidth = 250,
      Widget? customHeader,
      Widget? customFooter,
    }) {
      return MaterialApp(
        home: EditorScaffold(
          fileTreeController: fileTreeController ?? mockFileTreeController,
          editorController: editorController ?? mockEditorController,
          pluginManager: pluginManager,
          pluginUIService: pluginUIService,
          treeWidth: treeWidth,
          customHeader: customHeader,
          customFooter: customFooter,
        ),
      );
    }

    group('Initialization', () {
      testWidgets('should call load on file tree controller',
          (tester) async {
        // Arrange
        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        verify(() => mockFileTreeController.load()).called(1);
      });

      testWidgets('should render scaffold', (tester) async {
        // Arrange
        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should have file tree and editor in row', (tester) async {
        // Arrange
        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('should render custom header when provided',
          (tester) async {
        // Arrange
        final customHeader = Container(
          key: const Key('custom-header'),
          child: const Text('Custom Header'),
        );

        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(customHeader: customHeader));

        // Assert
        expect(find.byKey(const Key('custom-header')), findsOneWidget);
        expect(find.text('Custom Header'), findsOneWidget);
      });

      testWidgets('should render custom footer when provided',
          (tester) async {
        // Arrange
        final customFooter = Container(
          key: const Key('custom-footer'),
          child: const Text('Custom Footer'),
        );

        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(customFooter: customFooter));

        // Assert
        expect(find.byKey(const Key('custom-footer')), findsOneWidget);
        expect(find.text('Custom Footer'), findsOneWidget);
      });
    });

    group('Editor States', () {
      testWidgets('should show empty placeholder in initial state',
          (tester) async {
        // Arrange
        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text('No file selected'), findsOneWidget);
      });

      testWidgets('should show loading indicator in loading state',
          (tester) async {
        // Arrange
        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.loading());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show error message in error state', (tester) async {
        // Arrange
        const errorMessage = 'Failed to load file';

        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.error(message: errorMessage));
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text(errorMessage), findsOneWidget);
      });
    });

    group('File Selection', () {
      testWidgets('should load file when selected from tree', (tester) async {
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

        when(() => mockFileTreeController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});
        when(() => mockFileTreeController.selectNode(any())).thenReturn(null);

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);
        when(() => mockEditorController.loadFile(any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('test.dart'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockEditorController.loadFile('file-1')).called(1);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User opens editor and sees empty state',
          (tester) async {
        // Arrange
        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text('No file selected'), findsOneWidget);
        expect(
          find.text('Select a file from the tree to start editing'),
          findsOneWidget,
        );
      });

      testWidgets('UC2: User selects file and editor loads', (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
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

        when(() => mockFileTreeController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});
        when(() => mockFileTreeController.selectNode(any())).thenReturn(null);

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);
        when(() => mockEditorController.loadFile(any()))
            .thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('main.dart'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockEditorController.loadFile('file-1')).called(1);
      });

      testWidgets('UC3: Custom header and footer are displayed',
          (tester) async {
        // Arrange
        final header = Container(child: const Text('App Bar'));
        final footer = Container(child: const Text('Status Bar'));

        when(() => mockFileTreeController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockFileTreeController.addListener(any())).thenReturn(null);
        when(() => mockFileTreeController.removeListener(any()))
            .thenReturn(null);
        when(() => mockFileTreeController.load()).thenAnswer((_) async {});

        when(() => mockEditorController.value)
            .thenReturn(const EditorState.initial());
        when(() => mockEditorController.addListener(any())).thenReturn(null);
        when(() => mockEditorController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(customHeader: header, customFooter: footer),
        );

        // Assert
        expect(find.text('App Bar'), findsOneWidget);
        expect(find.text('Status Bar'), findsOneWidget);
      });
    });
  });
}
