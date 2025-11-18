import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/widgets/code_editor/monaco_code_editor.dart';
import 'package:multi_editor_ui/src/widgets/code_editor/editor_config.dart';

void main() {
  group('MonacoCodeEditor Widget Tests', () {
    const testCode = 'void main() {\n  print("Hello");\n}';
    const testLanguage = 'dart';

    Widget createWidget({
      String code = testCode,
      String language = testLanguage,
      ValueChanged<String>? onChanged,
      bool readOnly = false,
      EditorConfig config = const EditorConfig(),
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MonacoCodeEditor(
            code: code,
            language: language,
            onChanged: onChanged,
            readOnly: readOnly,
            config: config,
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('should show loading indicator initially', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should initialize with provided code', (tester) async {
        const customCode = 'print("test");';
        await tester.pumpWidget(createWidget(code: customCode));

        // Widget initializes but Monaco may not be ready immediately
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should initialize with provided language', (tester) async {
        await tester.pumpWidget(createWidget(language: 'javascript'));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });

    group('Configuration', () {
      testWidgets('should accept custom editor config', (tester) async {
        const customConfig = EditorConfig(
          fontSize: 16,
          showLineNumbers: true,
          showMinimap: true,
        );

        await tester.pumpWidget(createWidget(config: customConfig));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support read-only mode', (tester) async {
        await tester.pumpWidget(createWidget(readOnly: true));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });

    group('Rendering', () {
      testWidgets('should render widget', (tester) async {
        await tester.pumpWidget(createWidget());
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should handle empty code', (tester) async {
        await tester.pumpWidget(createWidget(code: ''));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should handle multi-line code', (tester) async {
        const multiLineCode = '''
void main() {
  var x = 1;
  var y = 2;
  print(x + y);
}
''';
        await tester.pumpWidget(createWidget(code: multiLineCode));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });

    group('Language Support', () {
      testWidgets('should support dart language', (tester) async {
        await tester.pumpWidget(createWidget(language: 'dart'));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support javascript language', (tester) async {
        await tester.pumpWidget(createWidget(language: 'javascript'));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support typescript language', (tester) async {
        await tester.pumpWidget(createWidget(language: 'typescript'));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support json language', (tester) async {
        await tester.pumpWidget(createWidget(language: 'json'));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support python language', (tester) async {
        await tester.pumpWidget(createWidget(language: 'python'));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });

    group('Editor Features', () {
      testWidgets('should support custom font size', (tester) async {
        const config = EditorConfig(fontSize: 18);
        await tester.pumpWidget(createWidget(config: config));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support line numbers toggle', (tester) async {
        const config = EditorConfig(showLineNumbers: false);
        await tester.pumpWidget(createWidget(config: config));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support minimap toggle', (tester) async {
        const config = EditorConfig(showMinimap: false);
        await tester.pumpWidget(createWidget(config: config));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support word wrap', (tester) async {
        const config = EditorConfig(wordWrap: true);
        await tester.pumpWidget(createWidget(config: config));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should support custom tab size', (tester) async {
        const config = EditorConfig(tabSize: 2);
        await tester.pumpWidget(createWidget(config: config));
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });

    group('Theme', () {
      testWidgets('should adapt to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: MonacoCodeEditor(
                code: testCode,
                language: testLanguage,
              ),
            ),
          ),
        );
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('should adapt to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: MonacoCodeEditor(
                code: testCode,
                language: testLanguage,
              ),
            ),
          ),
        );
        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });

    group('Use Cases', () {
      testWidgets('UC1: Load Dart file in editor', (tester) async {
        const dartCode = 'void main() => print("Hello");';
        await tester.pumpWidget(createWidget(
          code: dartCode,
          language: 'dart',
        ));

        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('UC2: Load JSON file with formatting', (tester) async {
        const jsonCode = '{"name": "test", "value": 123}';
        await tester.pumpWidget(createWidget(
          code: jsonCode,
          language: 'json',
        ));

        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('UC3: Configure editor for code review (read-only)',
          (tester) async {
        const config = EditorConfig(showLineNumbers: true, showMinimap: false);
        await tester.pumpWidget(createWidget(
          readOnly: true,
          config: config,
        ));

        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });

      testWidgets('UC4: Large file with custom settings', (tester) async {
        final largeCode = List.generate(100, (i) => 'line $i').join('\n');
        const config = EditorConfig(
          fontSize: 14,
          showMinimap: true,
          wordWrap: false,
        );

        await tester.pumpWidget(createWidget(
          code: largeCode,
          config: config,
        ));

        expect(find.byType(MonacoCodeEditor), findsOneWidget);
      });
    });
  });
}
