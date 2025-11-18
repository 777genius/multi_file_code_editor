import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/error_editor_message.dart';

void main() {
  group('ErrorEditorMessage Widget Tests', () {
    Widget createWidget({
      required String message,
      VoidCallback? onClose,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ErrorEditorMessage(
            message: message,
            onClose: onClose ?? () {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should display error message', (tester) async {
        const errorMsg = 'Failed to load file';
        await tester.pumpWidget(createWidget(message: errorMsg));
        expect(find.text(errorMsg), findsOneWidget);
      });

      testWidgets('should display error title', (tester) async {
        await tester.pumpWidget(createWidget(message: 'Test error'));
        expect(find.text('Error'), findsOneWidget);
      });

      testWidgets('should display error icon', (tester) async {
        await tester.pumpWidget(createWidget(message: 'Test error'));
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should display go back button', (tester) async {
        await tester.pumpWidget(createWidget(message: 'Test error'));
        expect(find.text('Go back'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should call onClose when go back pressed', (tester) async {
        var closeCalled = false;
        await tester.pumpWidget(
          createWidget(
            message: 'Test error',
            onClose: () => closeCalled = true,
          ),
        );

        await tester.tap(find.text('Go back'));
        await tester.pumpAndSettle();

        expect(closeCalled, isTrue);
      });
    });

    group('Visual Design', () {
      testWidgets('should have large error icon', (tester) async {
        await tester.pumpWidget(createWidget(message: 'Test'));
        final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        expect(icon.size, equals(64));
      });

      testWidgets('should center content', (tester) async {
        await tester.pumpWidget(createWidget(message: 'Test'));
        expect(find.byType(Center), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: File loading error displayed', (tester) async {
        const error = 'File not found';
        await tester.pumpWidget(createWidget(message: error));

        expect(find.text('Error'), findsOneWidget);
        expect(find.text(error), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('UC2: User navigates back from error', (tester) async {
        var navigatedBack = false;
        await tester.pumpWidget(
          createWidget(
            message: 'Error',
            onClose: () => navigatedBack = true,
          ),
        );

        await tester.tap(find.text('Go back'));
        expect(navigatedBack, isTrue);
      });
    });
  });
}
