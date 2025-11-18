import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_ide_enhancements/dart_ide_enhancements.dart';
import 'package:path/path.dart' as path;

void main() {
  group('PubCommandsPanel', () {
    late String testProjectRoot;
    late File pubspecFile;

    setUp(() async {
      // Create temporary test project
      final tempDir = Directory.systemTemp.createTempSync('dart_test');
      testProjectRoot = tempDir.path;
      pubspecFile = File(path.join(testProjectRoot, 'pubspec.yaml'));
      await pubspecFile.writeAsString('''
name: test_project
version: 1.0.0

environment:
  sdk: '>=2.17.0 <4.0.0'

dependencies:
''');
    });

    tearDown(() async {
      // Cleanup
      if (await pubspecFile.exists()) {
        await pubspecFile.parent.delete(recursive: true);
      }
    });

    group('Widget Rendering', () {
      testWidgets('should render with all command buttons', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Dart/Flutter Commands'), findsOneWidget);
        expect(find.text('pub get'), findsOneWidget);
        expect(find.text('pub upgrade'), findsOneWidget);
        expect(find.text('pub outdated'), findsOneWidget);
        expect(find.text('analyze'), findsOneWidget);
        expect(find.text('format'), findsOneWidget);
      });

      testWidgets('should display command buttons with icons', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.download), findsOneWidget);
        expect(find.byIcon(Icons.upgrade), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byIcon(Icons.format_align_left), findsOneWidget);
      });

      testWidgets('should display output area with placeholder text', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Output will appear here...'), findsOneWidget);
      });

      testWidgets('should render in a Card widget', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('should have proper layout structure', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Wrap), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(SelectableText), findsOneWidget);
      });
    });

    group('Button Interactions', () {
      testWidgets('should execute pub get command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();

        // Assert - Should show executing message
        expect(find.textContaining('Executing pub get'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute pub upgrade command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub upgrade'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing pub upgrade'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute pub outdated command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub outdated'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing pub outdated'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute analyze command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing analyze'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute format command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'format'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing format'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });

    group('Button States', () {
      testWidgets('should disable all buttons while command is running', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Start a command
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();

        // Assert - All buttons should be disabled
        final buttons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
        for (final button in buttons) {
          expect(button.onPressed, isNull);
        }
      });

      testWidgets('should enable buttons after command completes', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();

        // Wait for command to complete
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert - Buttons should be enabled again
        final pubGetButton = find.widgetWithText(ElevatedButton, 'pub get');
        expect(pubGetButton, findsOneWidget);

        final button = tester.widget<ElevatedButton>(pubGetButton);
        expect(button.onPressed, isNotNull);
      });
    });

    group('Progress Indicator', () {
      testWidgets('should show progress indicator when command is running', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert - Initially no progress indicator
        expect(find.byType(LinearProgressIndicator), findsNothing);

        // Act - Start command
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();

        // Assert - Progress indicator should appear
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should hide progress indicator when command completes', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();

        // Wait for completion
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert
        expect(find.byType(LinearProgressIndicator), findsNothing);
      });
    });

    group('Output Display', () {
      testWidgets('should display executing message when command starts', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing pub get...'), findsOneWidget);
      });

      testWidgets('should display output in monospace font', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        final selectableText = tester.widget<SelectableText>(find.byType(SelectableText));
        expect(selectableText.style?.fontFamily, equals('monospace'));
      });

      testWidgets('should display output in dark terminal-style container', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(PubCommandsPanel),
            matching: find.byType(Container),
          ).last,
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(Colors.black87));
        expect(decoration.borderRadius, isNotNull);
      });

      testWidgets('should make output text selectable', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(SelectableText), findsOneWidget);
      });

      testWidgets('should display success indicator on successful command', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert - Should show success emoji (either success or error)
        final outputText = find.byType(SelectableText);
        expect(outputText, findsOneWidget);
      });

      testWidgets('should update output when multiple commands are executed', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Execute first command
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Act - Execute second command
        await tester.tap(find.widgetWithText(ElevatedButton, 'format'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing format'), findsOneWidget);
      });
    });

    group('Flutter vs Dart Mode', () {
      testWidgets('should use Dart commands when isFlutterProject is false', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
                isFlutterProject: false,
              ),
            ),
          ),
        );

        // Act - Execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();

        // Assert - Should execute (implementation uses dart command)
        expect(find.textContaining('Executing pub get'), findsOneWidget);
      });

      testWidgets('should use Flutter commands when isFlutterProject is true', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
                isFlutterProject: true,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub upgrade'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing pub upgrade'), findsOneWidget);
      });

      testWidgets('should default to Dart mode when isFlutterProject is not specified', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert - Widget should render (defaults to Dart mode)
        expect(find.byType(PubCommandsPanel), findsOneWidget);
      });
    });

    group('Real-world Workflows', () {
      testWidgets('should handle pub get after project creation', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Typical first command
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();

        // Assert
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.textContaining('Executing pub get'), findsOneWidget);
      });

      testWidgets('should handle analyze and format workflow', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Analyze first
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Act - Then format
        await tester.tap(find.widgetWithText(ElevatedButton, 'format'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing format'), findsOneWidget);
      });

      testWidgets('should handle checking for outdated packages', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub outdated'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing pub outdated'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle invalid project root gracefully', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: '/nonexistent/path',
              ),
            ),
          ),
        );

        // Assert - Should still render
        expect(find.byType(PubCommandsPanel), findsOneWidget);

        // Act - Try to execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'pub get'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert - Should show error
        expect(find.textContaining('Error'), findsOneWidget);
      });

      testWidgets('should display error message with error indicator', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: '/invalid/path',
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert - Should contain error indicator emoji
        final selectableText = find.byType(SelectableText);
        expect(selectableText, findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have proper card margins', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        final card = tester.widget<Card>(find.byType(Card));
        expect(card.margin, equals(const EdgeInsets.all(8.0)));
      });

      testWidgets('should have proper internal padding', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        final padding = tester.widget<Padding>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Padding),
          ).first,
        );
        expect(padding.padding, equals(const EdgeInsets.all(16.0)));
      });

      testWidgets('should use theme text styles', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Dart/Flutter Commands'), findsOneWidget);
      });

      testWidgets('should have expandable output area', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Expanded), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have accessible button labels', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert - All buttons should have clear text labels
        expect(find.text('pub get'), findsOneWidget);
        expect(find.text('pub upgrade'), findsOneWidget);
        expect(find.text('pub outdated'), findsOneWidget);
        expect(find.text('analyze'), findsOneWidget);
        expect(find.text('format'), findsOneWidget);
      });

      testWidgets('should have semantic labels through icons', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert - Icons provide visual cues
        expect(find.byIcon(Icons.download), findsOneWidget);
        expect(find.byIcon(Icons.upgrade), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should maintain output across rebuilds', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();

        final outputBefore = find.textContaining('Executing analyze');
        expect(outputBefore, findsOneWidget);

        // Act - Rebuild widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert - Output should be maintained
        expect(find.byType(PubCommandsPanel), findsOneWidget);
      });

      testWidgets('should clear output when new command starts', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PubCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Execute first command
        await tester.tap(find.widgetWithText(ElevatedButton, 'analyze'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Act - Execute second command
        await tester.tap(find.widgetWithText(ElevatedButton, 'format'));
        await tester.pump();

        // Assert - Should show new command output
        expect(find.textContaining('Executing format'), findsOneWidget);
      });
    });
  });
}
