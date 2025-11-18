import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/controllers/file_tree_controller.dart';
import 'package:multi_editor_ui/src/state/file_tree_state.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/file_tree_view.dart';

// Mocks
class MockFileTreeController extends Mock implements FileTreeController {}

class MockPluginManager extends Mock implements PluginManager {}

class MockFolderRepository extends Mock implements FolderRepository {}

class MockFileRepository extends Mock implements FileRepository {}

class MockEventBus extends Mock implements EventBus {}

// Fakes
class FakeFileTreeState extends Fake implements FileTreeState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeFileTreeState());
  });

  group('FileTreeView Widget Tests', () {
    late MockFileTreeController mockController;
    late MockPluginManager mockPluginManager;

    setUp(() {
      mockController = MockFileTreeController();
      mockPluginManager = MockPluginManager();
    });

    Widget createWidget({
      FileTreeController? controller,
      ValueChanged<String>? onFileSelected,
      PluginManager? pluginManager,
      double width = 250,
      bool enableDragDrop = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileTreeView(
            controller: controller ?? mockController,
            onFileSelected: onFileSelected,
            pluginManager: pluginManager,
            width: width,
            enableDragDrop: enableDragDrop,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render with default width', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints?.maxWidth, equals(250));
      });

      testWidgets('should render with custom width', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget(width: 350));

        // Assert
        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints?.maxWidth, equals(350));
      });

      testWidgets('should show "Ready" text in initial state', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text('Ready'), findsOneWidget);
      });

      testWidgets('should show loading indicator in loading state',
          (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.loading());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show error message in error state', (tester) async {
        // Arrange
        const errorMessage = 'Failed to load files';
        when(() => mockController.value)
            .thenReturn(const FileTreeState.error(message: errorMessage));
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text('Error: $errorMessage'), findsOneWidget);
      });

      testWidgets('should render file tree header', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text('Files'), findsOneWidget);
        expect(
          find.byIcon(Icons.insert_drive_file),
          findsWidgets,
        ); // New file button
        expect(
          find.byIcon(Icons.create_new_folder),
          findsWidgets,
        ); // New folder button
        expect(find.byIcon(Icons.refresh), findsOneWidget); // Refresh button
      });
    });

    group('Interactions', () {
      testWidgets('should call refresh on refresh button tap', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.refresh()).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createWidget());
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockController.refresh()).called(1);
      });

      testWidgets('should call onFileSelected when file is selected',
          (tester) async {
        // Arrange
        String? selectedFileId;
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

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
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
            onFileSelected: (fileId) => selectedFileId = fileId,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('test.dart'));
        await tester.pumpAndSettle();

        // Assert
        expect(selectedFileId, equals('file-1'));
      });
    });

    group('State Changes', () {
      testWidgets('should update UI when state changes', (tester) async {
        // Arrange
        final controller = MockFileTreeController();
        final notifier = ValueNotifier<FileTreeState>(
          const FileTreeState.initial(),
        );

        when(() => controller.value).thenAnswer((_) => notifier.value);
        when(() => controller.addListener(any())).thenAnswer((invocation) {
          final listener = invocation.positionalArguments[0] as VoidCallback;
          notifier.addListener(listener);
        });
        when(() => controller.removeListener(any())).thenAnswer((invocation) {
          final listener = invocation.positionalArguments[0] as VoidCallback;
          notifier.removeListener(listener);
        });

        // Act
        await tester.pumpWidget(createWidget(controller: controller));
        expect(find.text('Ready'), findsOneWidget);

        // Change state to loading
        notifier.value = const FileTreeState.loading();
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Ready'), findsNothing);
      });
    });

    group('Accessibility', () {
      testWidgets('should have accessible tooltips', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byTooltip('New File'), findsOneWidget);
        expect(find.byTooltip('New Folder'), findsOneWidget);
        expect(find.byTooltip('Refresh'), findsOneWidget);
      });
    });

    group('Plugin Integration', () {
      testWidgets('should pass plugin manager to file tree content',
          (tester) async {
        // Arrange
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [],
        );

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(pluginManager: mockPluginManager),
        );
        await tester.pumpAndSettle();

        // Assert - widget renders without errors
        expect(find.byType(FileTreeView), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User refreshes file tree', (tester) async {
        // Arrange
        when(() => mockController.value)
            .thenReturn(const FileTreeState.initial());
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.refresh()).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createWidget());
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockController.refresh()).called(1);
      });

      testWidgets('UC2: User navigates file tree and selects file',
          (tester) async {
        // Arrange
        String? selectedFileId;
        final rootNode = FileTreeNode(
          id: 'root',
          name: 'root',
          isFolder: true,
          children: [
            FileTreeNode(
              id: 'folder-1',
              name: 'src',
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
          ],
        );

        when(() => mockController.value).thenReturn(
          FileTreeState.loaded(
            rootNode: rootNode,
            selectedNodeId: null,
            expandedFolderIds: const [],
          ),
        );
        when(() => mockController.addListener(any())).thenReturn(null);
        when(() => mockController.removeListener(any())).thenReturn(null);
        when(() => mockController.selectNode(any())).thenReturn(null);
        when(() => mockController.toggleFolder(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createWidget(
            onFileSelected: (fileId) => selectedFileId = fileId,
          ),
        );
        await tester.pumpAndSettle();

        // Tap on file
        await tester.tap(find.text('main.dart'));
        await tester.pumpAndSettle();

        // Assert
        expect(selectedFileId, equals('file-1'));
        verify(() => mockController.selectNode('file-1')).called(1);
      });

      testWidgets('UC3: Error state displays and user can recover',
          (tester) async {
        // Arrange
        final controller = MockFileTreeController();
        final notifier = ValueNotifier<FileTreeState>(
          const FileTreeState.error(message: 'Network error'),
        );

        when(() => controller.value).thenAnswer((_) => notifier.value);
        when(() => controller.addListener(any())).thenAnswer((invocation) {
          final listener = invocation.positionalArguments[0] as VoidCallback;
          notifier.addListener(listener);
        });
        when(() => controller.removeListener(any())).thenAnswer((invocation) {
          final listener = invocation.positionalArguments[0] as VoidCallback;
          notifier.removeListener(listener);
        });
        when(() => controller.refresh()).thenAnswer((_) async {
          notifier.value = const FileTreeState.loading();
        });

        // Act
        await tester.pumpWidget(createWidget(controller: controller));

        // Assert - Error is displayed
        expect(find.text('Error: Network error'), findsOneWidget);

        // Refresh to recover
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();

        // Assert - Loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
