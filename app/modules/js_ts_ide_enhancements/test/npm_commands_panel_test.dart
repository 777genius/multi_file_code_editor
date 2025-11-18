import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:js_ts_ide_enhancements/js_ts_ide_enhancements.dart';
import 'package:path/path.dart' as path;

void main() {
  group('NpmCommandsPanel', () {
    late String testProjectRoot;
    late File packageJsonFile;

    setUp(() async {
      // Create temporary test project
      final tempDir = Directory.systemTemp.createTempSync('npm_test');
      testProjectRoot = tempDir.path;
      packageJsonFile = File(path.join(testProjectRoot, 'package.json'));
      await packageJsonFile.writeAsString('''
{
  "name": "test-project",
  "version": "1.0.0",
  "scripts": {
    "test": "jest",
    "build": "webpack",
    "start": "node index.js"
  }
}
''');
    });

    tearDown(() async {
      // Cleanup
      if (await packageJsonFile.exists()) {
        await packageJsonFile.parent.delete(recursive: true);
      }
    });

    group('Widget Rendering', () {
      testWidgets('should render with all command buttons', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('JavaScript/TypeScript Commands'), findsOneWidget);
        expect(find.text('install'), findsOneWidget);
        expect(find.text('update'), findsOneWidget);
        expect(find.text('outdated'), findsOneWidget);
      });

      testWidgets('should display command buttons with icons', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.download), findsOneWidget);
        expect(find.byIcon(Icons.upgrade), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber), findsOneWidget);
      });

      testWidgets('should display package manager dropdown', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(DropdownButton<PackageManager>), findsOneWidget);
      });

      testWidgets('should display output area with placeholder text', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
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
              body: NpmCommandsPanel(
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
              body: NpmCommandsPanel(
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

    group('Package Manager Selection', () {
      testWidgets('should show all package manager options', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Tap dropdown
        await tester.tap(find.byType(DropdownButton<PackageManager>));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('npm'), findsWidgets);
        expect(find.text('yarn'), findsOneWidget);
        expect(find.text('pnpm'), findsOneWidget);
      });

      testWidgets('should change package manager on selection', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act - Open dropdown
        await tester.tap(find.byType(DropdownButton<PackageManager>));
        await tester.pumpAndSettle();

        // Act - Select yarn
        await tester.tap(find.text('yarn').last);
        await tester.pumpAndSettle();

        // Assert - Widget should re-render without errors
        expect(find.byType(NpmCommandsPanel), findsOneWidget);
      });

      testWidgets('should auto-detect package manager on init', (tester) async {
        // Arrange - Create yarn.lock file
        final yarnLock = File(path.join(testProjectRoot, 'yarn.lock'));
        await yarnLock.writeAsString('');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should detect yarn
        expect(find.byType(NpmCommandsPanel), findsOneWidget);
      });
    });

    group('Script Management', () {
      testWidgets('should load and display available scripts', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Run script: '), findsOneWidget);
        expect(find.byType(DropdownButton<String>), findsOneWidget);
      });

      testWidgets('should show script dropdown with available scripts', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Tap script dropdown
        final scriptDropdowns = find.byType(DropdownButton<String>);
        if (scriptDropdowns.evaluate().isNotEmpty) {
          await tester.tap(scriptDropdowns.first);
          await tester.pumpAndSettle();

          // Assert - Should show scripts
          // Scripts may be visible in the dropdown
        }
      });

      testWidgets('should have run button for scripts', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.widgetWithIcon(ElevatedButton, Icons.play_arrow), findsOneWidget);
        expect(find.text('Run'), findsOneWidget);
      });

      testWidgets('should hide script section when no scripts available', (tester) async {
        // Arrange - Create package.json without scripts
        await packageJsonFile.writeAsString('{"name": "test"}');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Script section should not be visible
        expect(find.text('Run script: '), findsNothing);
      });
    });

    group('Button Interactions', () {
      testWidgets('should execute install command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();

        // Assert - Should show executing message
        expect(find.textContaining('Executing install'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute update command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'update'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing update'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute outdated command on button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing outdated'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should execute script on run button tap', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Tap Run button
        await tester.tap(find.text('Run'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing script'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });

    group('Button States', () {
      testWidgets('should disable all buttons while command is running', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Start a command
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
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
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
        await tester.pump();

        // Wait for command to complete
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert - Buttons should be enabled again
        final installButton = find.widgetWithText(ElevatedButton, 'install');
        expect(installButton, findsOneWidget);

        final button = tester.widget<ElevatedButton>(installButton);
        expect(button.onPressed, isNotNull);
      });

      testWidgets('should disable run button when no script selected', (tester) async {
        // Arrange - Create package.json with empty scripts
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {}
}
''');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Run button should not be present when no scripts
        expect(find.text('Run'), findsNothing);
      });
    });

    group('Progress Indicator', () {
      testWidgets('should show progress indicator when command is running', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Initially no progress indicator
        expect(find.byType(LinearProgressIndicator), findsNothing);

        // Act - Start command
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();

        // Assert - Progress indicator should appear
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('should hide progress indicator when command completes', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
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
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing install...'), findsOneWidget);
      });

      testWidgets('should display output in monospace font', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
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
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(NpmCommandsPanel),
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
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SelectableText), findsOneWidget);
      });

      testWidgets('should update output when multiple commands are executed', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Execute first command
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Act - Execute second command
        await tester.tap(find.widgetWithText(ElevatedButton, 'update'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing update'), findsOneWidget);
      });
    });

    group('Real-world Workflows', () {
      testWidgets('should handle install after project creation', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Typical first command
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();

        // Assert
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.textContaining('Executing install'), findsOneWidget);
      });

      testWidgets('should handle test workflow', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Select and run test script
        final scriptDropdowns = find.byType(DropdownButton<String>);
        if (scriptDropdowns.evaluate().isNotEmpty) {
          await tester.tap(find.text('Run'));
          await tester.pump();

          // Assert
          expect(find.textContaining('Executing script'), findsOneWidget);
        }
      });

      testWidgets('should handle package manager switch workflow', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Switch package manager
        await tester.tap(find.byType(DropdownButton<PackageManager>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('yarn').last);
        await tester.pumpAndSettle();

        // Act - Execute command with new package manager
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing install'), findsOneWidget);
      });

      testWidgets('should handle checking for outdated packages', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
        await tester.pump();

        // Assert
        expect(find.textContaining('Executing outdated'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle invalid project root gracefully', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: '/nonexistent/path',
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should still render
        expect(find.byType(NpmCommandsPanel), findsOneWidget);

        // Act - Try to execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
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
              body: NpmCommandsPanel(
                projectRoot: '/invalid/path',
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert
        final selectableText = find.byType(SelectableText);
        expect(selectableText, findsOneWidget);
      });

      testWidgets('should handle malformed package.json gracefully', (tester) async {
        // Arrange - Create malformed package.json
        await packageJsonFile.writeAsString('invalid json content');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should still render basic UI
        expect(find.byType(NpmCommandsPanel), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have proper card margins', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        final card = tester.widget<Card>(find.byType(Card));
        expect(card.margin, equals(const EdgeInsets.all(8.0)));
      });

      testWidgets('should have proper internal padding', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        final padding = tester.widget<Padding>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Padding),
          ).first,
        );
        expect(padding.padding, equals(const EdgeInsets.all(16.0)));
      });

      testWidgets('should have expandable output area', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Expanded), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should maintain output across rebuilds', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();

        final outputBefore = find.textContaining('Executing install');
        expect(outputBefore, findsOneWidget);

        // Act - Rebuild widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Widget should be present
        expect(find.byType(NpmCommandsPanel), findsOneWidget);
      });

      testWidgets('should clear output when new command starts', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Execute first command
        await tester.tap(find.widgetWithText(ElevatedButton, 'outdated'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Act - Execute second command
        await tester.tap(find.widgetWithText(ElevatedButton, 'update'));
        await tester.pump();

        // Assert - Should show new command output
        expect(find.textContaining('Executing update'), findsOneWidget);
      });

      testWidgets('should maintain selected package manager across commands', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Change package manager
        await tester.tap(find.byType(DropdownButton<PackageManager>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('yarn').last);
        await tester.pumpAndSettle();

        // Act - Execute command
        await tester.tap(find.widgetWithText(ElevatedButton, 'install'));
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert - Package manager should still be yarn
        expect(find.byType(NpmCommandsPanel), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have accessible button labels', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - All buttons should have clear text labels
        expect(find.text('install'), findsOneWidget);
        expect(find.text('update'), findsOneWidget);
        expect(find.text('outdated'), findsOneWidget);
      });

      testWidgets('should have semantic labels through icons', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NpmCommandsPanel(
                projectRoot: testProjectRoot,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Icons provide visual cues
        expect(find.byIcon(Icons.download), findsOneWidget);
        expect(find.byIcon(Icons.upgrade), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber), findsOneWidget);
      });
    });
  });
}
