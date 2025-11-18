import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/file_tree/widgets/empty_file_tree_placeholder.dart';

void main() {
  group('EmptyFileTreePlaceholder Widget Tests', () {
    Widget createWidget({bool isHovered = false}) {
      return MaterialApp(
        home: Scaffold(
          body: EmptyFileTreePlaceholder(isHovered: isHovered),
        ),
      );
    }

    group('Rendering - Not Hovered', () {
      testWidgets('should show closed folder icon when not hovered',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('should show "No files yet" message when not hovered',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert
        expect(find.text('No files yet'), findsOneWidget);
      });

      testWidgets(
          'should show instruction message when not hovered', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert
        expect(
          find.text('Create your first file or folder'),
          findsOneWidget,
        );
      });

      testWidgets('should use muted colors when not hovered', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert - Icon exists with muted opacity
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });
    });

    group('Rendering - Hovered', () {
      testWidgets('should show open folder icon when hovered', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      });

      testWidgets('should show "Drop here to move to root" when hovered',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert
        expect(find.text('Drop here to move to root'), findsOneWidget);
      });

      testWidgets('should not show instruction message when hovered',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert
        expect(find.text('Create your first file or folder'), findsNothing);
      });

      testWidgets('should use primary color when hovered', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert - Icon exists
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should center content', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byType(Center), findsOneWidget);
      });

      testWidgets('should have appropriate padding', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(padding.padding, equals(const EdgeInsets.all(24.0)));
      });

      testWidgets('should arrange items in column', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Icon Properties', () {
      testWidgets('should have large icon size', (tester) async {
        // Act
        await tester.pumpWidget(createWidget());

        // Assert
        final icon = tester.widget<Icon>(find.byIcon(Icons.folder));
        expect(icon.size, equals(64));
      });

      testWidgets('should change icon from folder to folder_open on hover',
          (tester) async {
        // Act - Not hovered
        await tester.pumpWidget(createWidget(isHovered: false));
        expect(find.byIcon(Icons.folder), findsOneWidget);
        expect(find.byIcon(Icons.folder_open), findsNothing);

        // Act - Hovered
        await tester.pumpWidget(createWidget(isHovered: true));
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsNothing);
      });
    });

    group('Accessibility', () {
      testWidgets('should have clear instructional text', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert
        expect(find.text('No files yet'), findsOneWidget);
        expect(find.text('Create your first file or folder'), findsOneWidget);
      });

      testWidgets('should provide drag-drop feedback when hovered',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert
        expect(find.text('Drop here to move to root'), findsOneWidget);
      });
    });

    group('Visual Feedback', () {
      testWidgets('should change appearance when hover state changes',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert - Initial state
        expect(find.byIcon(Icons.folder), findsOneWidget);
        expect(find.text('No files yet'), findsOneWidget);

        // Act - Change to hovered
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert - Hovered state
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
        expect(find.text('Drop here to move to root'), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Empty project shows helpful message', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert
        expect(find.text('No files yet'), findsOneWidget);
        expect(find.text('Create your first file or folder'), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('UC2: User drags file over empty tree', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert
        expect(find.text('Drop here to move to root'), findsOneWidget);
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      });

      testWidgets('UC3: Visual feedback during drag operation',
          (tester) async {
        // Arrange - Start not hovered
        await tester.pumpWidget(createWidget(isHovered: false));
        expect(find.byIcon(Icons.folder), findsOneWidget);

        // Act - Drag enters (hover)
        await tester.pumpWidget(createWidget(isHovered: true));

        // Assert - Visual changes
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
        expect(find.text('Drop here to move to root'), findsOneWidget);

        // Act - Drag leaves (not hovered)
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert - Back to original
        expect(find.byIcon(Icons.folder), findsOneWidget);
        expect(find.text('No files yet'), findsOneWidget);
      });

      testWidgets('UC4: Clear instructions for new users', (tester) async {
        // Act
        await tester.pumpWidget(createWidget(isHovered: false));

        // Assert - All instructional elements present
        expect(find.byIcon(Icons.folder), findsOneWidget);
        expect(find.text('No files yet'), findsOneWidget);
        expect(find.text('Create your first file or folder'), findsOneWidget);

        // Verify proper hierarchy
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
      });
    });
  });
}
