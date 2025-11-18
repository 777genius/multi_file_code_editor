import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/dirty_changes_indicator.dart';

void main() {
  group('DirtyChangesIndicator Widget Tests', () {
    Widget createWidget({VoidCallback? onSave}) {
      return MaterialApp(
        home: Scaffold(
          body: DirtyChangesIndicator(onSave: onSave ?? () {}),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should display unsaved changes message', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.text('You have unsaved changes'), findsOneWidget);
      });

      testWidgets('should display save button', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('should display info icon', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should call onSave when save button pressed',
          (tester) async {
        var saveCalled = false;
        await tester.pumpWidget(
          createWidget(onSave: () => saveCalled = true),
        );

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(saveCalled, isTrue);
      });
    });

    group('Visual Design', () {
      testWidgets('should have primary container background', (tester) async {
        await tester.pumpWidget(createWidget());
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.decoration, isNotNull);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: User sees unsaved changes warning', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.text('You have unsaved changes'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('UC2: User clicks save from indicator', (tester) async {
        var saved = false;
        await tester.pumpWidget(createWidget(onSave: () => saved = true));

        await tester.tap(find.text('Save'));
        expect(saved, isTrue);
      });
    });
  });
}
