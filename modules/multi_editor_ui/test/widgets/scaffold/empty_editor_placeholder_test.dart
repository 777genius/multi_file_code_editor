import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/empty_editor_placeholder.dart';

void main() {
  group('EmptyEditorPlaceholder Widget Tests', () {
    Widget createWidget() {
      return const MaterialApp(
        home: Scaffold(body: EmptyEditorPlaceholder()),
      );
    }

    group('Rendering', () {
      testWidgets('should display "No file selected" message',
          (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.text('No file selected'), findsOneWidget);
      });

      testWidgets('should display instruction text', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(
          find.text('Select a file from the tree to start editing'),
          findsOneWidget,
        );
      });

      testWidgets('should display code icon', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byIcon(Icons.code), findsOneWidget);
      });

      testWidgets('should center content', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(Center), findsOneWidget);
      });

      testWidgets('should arrange items in column', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Visual Design', () {
      testWidgets('should have large icon', (tester) async {
        await tester.pumpWidget(createWidget());
        final icon = tester.widget<Icon>(find.byIcon(Icons.code));
        expect(icon.size, equals(64));
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User opens app and sees empty editor', (tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byIcon(Icons.code), findsOneWidget);
        expect(find.text('No file selected'), findsOneWidget);
        expect(
          find.text('Select a file from the tree to start editing'),
          findsOneWidget,
        );
      });
    });
  });
}
