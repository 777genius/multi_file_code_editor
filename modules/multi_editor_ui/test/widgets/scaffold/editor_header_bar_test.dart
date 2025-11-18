import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/multi_editor_core.dart';
import 'package:multi_editor_plugins/multi_editor_plugins.dart';
import 'package:multi_editor_ui/src/widgets/scaffold/widgets/editor_header_bar.dart';

// Mocks
class MockPluginUIService extends Mock implements PluginUIService {}

class MockPluginManager extends Mock implements PluginManager {}

void main() {
  group('EditorHeaderBar Widget Tests', () {
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
      VoidCallback? onSave,
      VoidCallback? onClose,
      PluginUIService? pluginUIService,
      PluginManager? pluginManager,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: EditorHeaderBar(
            file: file,
            isDirty: isDirty,
            isSaving: isSaving,
            onSave: onSave ?? () {},
            onClose: onClose ?? () {},
            pluginUIService: pluginUIService,
            pluginManager: pluginManager,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should display file name', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.text('test.dart'), findsOneWidget);
      });

      testWidgets('should show save button when dirty', (tester) async {
        await tester.pumpWidget(
          createWidget(file: testFile, isDirty: true),
        );
        expect(find.byIcon(Icons.save), findsOneWidget);
        expect(find.text('Modified'), findsOneWidget);
      });

      testWidgets('should show progress when saving', (tester) async {
        await tester.pumpWidget(
          createWidget(file: testFile, isSaving: true, isDirty: true),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byIcon(Icons.save), findsNothing);
      });

      testWidgets('should always show close button', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('should show file icon', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should call onSave when save button tapped',
          (tester) async {
        var saveCalled = false;
        await tester.pumpWidget(
          createWidget(
            file: testFile,
            isDirty: true,
            onSave: () => saveCalled = true,
          ),
        );

        await tester.tap(find.byIcon(Icons.save));
        expect(saveCalled, isTrue);
      });

      testWidgets('should call onClose when close button tapped',
          (tester) async {
        var closeCalled = false;
        await tester.pumpWidget(
          createWidget(file: testFile, onClose: () => closeCalled = true),
        );

        await tester.tap(find.byIcon(Icons.close));
        expect(closeCalled, isTrue);
      });
    });

    group('Plugin Integration', () {
      testWidgets('should show plugin buttons when service provided',
          (tester) async {
        final mockService = MockPluginUIService();
        when(() => mockService.getRegisteredUIs()).thenReturn([]);

        await tester.pumpWidget(
          createWidget(file: testFile, pluginUIService: mockService),
        );

        verify(() => mockService.getRegisteredUIs()).called(1);
      });
    });

    group('Accessibility', () {
      testWidgets('should have save tooltip', (tester) async {
        await tester.pumpWidget(
          createWidget(file: testFile, isDirty: true),
        );
        expect(find.byTooltip('Save (Ctrl+S)'), findsOneWidget);
      });

      testWidgets('should have close tooltip', (tester) async {
        await tester.pumpWidget(createWidget(file: testFile));
        expect(find.byTooltip('Close'), findsOneWidget);
      });
    });
  });
}
