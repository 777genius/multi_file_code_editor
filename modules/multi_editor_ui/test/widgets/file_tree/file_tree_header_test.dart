import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/file_tree_header.dart';

void main() {
  group('FileTreeHeader Widget Tests', () {
    Widget createWidget({
      VoidCallback? onNewFile,
      VoidCallback? onNewFolder,
      VoidCallback? onRefresh,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FileTreeHeader(
            onNewFile: onNewFile ?? () {},
            onNewFolder: onNewFolder ?? () {},
            onRefresh: onRefresh ?? () {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render "Files" title', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.text('Files'), findsOneWidget);
      });

      testWidgets('should render new file button', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });

      testWidgets('should render new folder button', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byIcon(Icons.create_new_folder), findsOneWidget);
      });

      testWidgets('should render refresh button', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should call onNewFile when new file button is tapped',
          (tester) async {
        // Arrange
        var callbackCalled = false;

        // Act
        await tester.pumpWidget(
          createWidget(onNewFile: () => callbackCalled = true),
        );
        await tester.tap(find.byIcon(Icons.insert_drive_file));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackCalled, isTrue);
      });

      testWidgets('should call onNewFolder when new folder button is tapped',
          (tester) async {
        // Arrange
        var callbackCalled = false;

        // Act
        await tester.pumpWidget(
          createWidget(onNewFolder: () => callbackCalled = true),
        );
        await tester.tap(find.byIcon(Icons.create_new_folder));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackCalled, isTrue);
      });

      testWidgets('should call onRefresh when refresh button is tapped',
          (tester) async {
        // Arrange
        var callbackCalled = false;

        // Act
        await tester.pumpWidget(
          createWidget(onRefresh: () => callbackCalled = true),
        );
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackCalled, isTrue);
      });
    });

    group('Accessibility', () {
      testWidgets('should have tooltips for all buttons', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byTooltip('New File'), findsOneWidget);
        expect(find.byTooltip('New Folder'), findsOneWidget);
        expect(find.byTooltip('Refresh'), findsOneWidget);
      });

      testWidgets('should have proper icon sizes', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        final icons = tester.widgetList<Icon>(find.byType(Icon));
        for (final icon in icons) {
          expect(icon.size, equals(18));
        }
      });
    });

    group('Layout', () {
      testWidgets('should have title on the left and buttons on the right',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, greaterThan(3));

        // Find spacer
        expect(
          row.children.any((child) => child is Spacer),
          isTrue,
        );
      });

      testWidgets('should have appropriate padding', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(padding.padding, equals(const EdgeInsets.all(8.0)));
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User creates a new file', (tester) async {
        // Arrange
        var newFileClicked = false;

        // Act
        await tester.pumpWidget(
          createWidget(onNewFile: () => newFileClicked = true),
        );
        await tester.tap(find.byTooltip('New File'));
        await tester.pumpAndSettle();

        // Assert
        expect(newFileClicked, isTrue);
      });

      testWidgets('UC2: User creates a new folder', (tester) async {
        // Arrange
        var newFolderClicked = false;

        // Act
        await tester.pumpWidget(
          createWidget(onNewFolder: () => newFolderClicked = true),
        );
        await tester.tap(find.byTooltip('New Folder'));
        await tester.pumpAndSettle();

        // Assert
        expect(newFolderClicked, isTrue);
      });

      testWidgets('UC3: User refreshes the file tree', (tester) async {
        // Arrange
        var refreshClicked = false;

        // Act
        await tester.pumpWidget(
          createWidget(onRefresh: () => refreshClicked = true),
        );
        await tester.tap(find.byTooltip('Refresh'));
        await tester.pumpAndSettle();

        // Assert
        expect(refreshClicked, isTrue);
      });

      testWidgets('UC4: All header actions work sequentially',
          (tester) async {
        // Arrange
        var newFileClicked = false;
        var newFolderClicked = false;
        var refreshClicked = false;

        // Act
        await tester.pumpWidget(
          createWidget(
            onNewFile: () => newFileClicked = true,
            onNewFolder: () => newFolderClicked = true,
            onRefresh: () => refreshClicked = true,
          ),
        );

        await tester.tap(find.byTooltip('New File'));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('New Folder'));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Refresh'));
        await tester.pumpAndSettle();

        // Assert
        expect(newFileClicked, isTrue);
        expect(newFolderClicked, isTrue);
        expect(refreshClicked, isTrue);
      });
    });
  });
}
