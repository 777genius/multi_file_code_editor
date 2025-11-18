import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/loading_editor_indicator.dart';

void main() {
  group('LoadingEditorIndicator Widget Tests', () {
    Widget createWidget() {
      return const MaterialApp(
        home: Scaffold(body: LoadingEditorIndicator()),
      );
    }

    group('Rendering', () {
      testWidgets('should display circular progress indicator',
          (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should center indicator', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(Center), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: File loading shows spinner', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
