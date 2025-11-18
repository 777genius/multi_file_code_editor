import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/loaded_editor_view.dart';

// Mocks
class MockOnContentChanged extends Mock {
  void call(String content);
}

void main() {
  group('LoadedEditorView Widget Tests', () {
    late FileDocument testFile;

    setUp(() {
      testFile = FileDocument(
        id: 'file-1',
        name: 'test.dart',
        content: 'void main() {}',
        language: 'dart',
        folderId: 'root',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
    });

    Widget createWidget({
      required FileDocument file,
      bool isDirty = false,
      bool isSaving = false,
      ValueChanged<String>? onContentChanged,
      VoidCallback? onSave,
      VoidCallback? onClose,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: LoadedEditorView(
            file: file,
            isDirty: isDirty,
            isSaving: isSaving,
            editorConfig: const EditorConfig(),
            onContentChanged: onContentChanged ?? (_) {},
            onSave: onSave ?? () {},
            onClose: onClose ?? () {},
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should display editor header bar', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.text('test.dart'), findsOneWidget);
      });

      testWidgets('should show dirty indicator when dirty', (tester) async {
        await tester.pumpWidget(
          createWidget(file: testFile, isDirty: true),
        );
        await tester.pumpAndSettle();
        expect(find.text('You have unsaved changes'), findsOneWidget);
      });

      testWidgets('should not show dirty indicator when clean',
          (tester) async {
        await tester.pumpWidget(
          createWidget(file: testFile, isDirty: false),
        );
        expect(find.text('You have unsaved changes'), findsNothing);
      });
    });

    group('Layout', () {
      testWidgets('should arrange items in column', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have divider after header', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.byType(Divider), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Clean file loaded in editor', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile, isDirty: false));

        expect(find.text('test.dart'), findsOneWidget);
        expect(find.text('You have unsaved changes'), findsNothing);
      });

      testWidgets('UC2: Dirty file shows save indicator', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile, isDirty: true));
        await tester.pumpAndSettle();

        expect(find.text('You have unsaved changes'), findsOneWidget);
        expect(find.text('Modified'), findsOneWidget);
      });

      testWidgets('UC3: File being saved shows progress', (tester) async {
        await tester.pumpWidget(
          createWidget(file: testFile, isSaving: true, isDirty: true),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
