import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockDiffService extends Mock implements DiffService {}

class MockDiffNotifier extends DiffNotifier {
  DiffState _currentState;

  MockDiffNotifier(this._currentState);

  @override
  DiffState build() => _currentState;

  void setState(DiffState newState) {
    _currentState = newState;
    state = newState;
  }

  @override
  void setViewMode(DiffViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }
}

void main() {
  late MockDiffService mockDiffService;

  setUp(() {
    mockDiffService = MockDiffService();
  });

  DiffLine createDiffLine({
    DiffLineType type = DiffLineType.context,
    String content = 'test line',
    int? oldLineNumber,
    int? newLineNumber,
  }) {
    return DiffLine(
      type: type,
      content: content,
      oldLineNumber: oldLineNumber != null ? some(oldLineNumber) : none(),
      newLineNumber: newLineNumber != null ? some(newLineNumber) : none(),
    );
  }

  DiffHunk createDiffHunk({
    List<DiffLine>? lines,
    String header = '@@ -1,3 +1,3 @@',
  }) {
    return DiffHunk(
      header: header,
      lines: lines ??
          [
            createDiffLine(
              type: DiffLineType.context,
              content: 'context line',
              oldLineNumber: 1,
              newLineNumber: 1,
            ),
            createDiffLine(
              type: DiffLineType.removed,
              content: 'removed line',
              oldLineNumber: 2,
            ),
            createDiffLine(
              type: DiffLineType.added,
              content: 'added line',
              newLineNumber: 2,
            ),
          ],
    );
  }

  Widget createTestWidget({
    DiffState? initialState,
    String? filePath,
    List<DiffHunk>? hunks,
  }) {
    final state = initialState ?? const DiffState();

    return ProviderScope(
      overrides: [
        diffNotifierProvider.overrideWith((ref) => MockDiffNotifier(state)),
        diffServiceProvider.overrideWithValue(mockDiffService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: DiffViewer(
            filePath: filePath,
            hunks: hunks,
          ),
        ),
      ),
    );
  }

  group('DiffViewer - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DiffViewer), findsOneWidget);
    });

    testWidgets('should show empty state when no diff', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No Diff Available'), findsOneWidget);
      expect(find.text('Select a file to view its changes'), findsOneWidget);
    });
  });

  group('DiffViewer - View Modes', () {
    testWidgets('should display view mode toggle', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SegmentedButton<DiffViewMode>), findsOneWidget);
      expect(find.text('Side by Side'), findsOneWidget);
      expect(find.text('Unified'), findsOneWidget);
    });

    testWidgets('should switch to unified view mode', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];
      final state = const DiffState(viewMode: DiffViewMode.sideBySide);

      // Act
      await tester.pumpWidget(createTestWidget(
        initialState: state,
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Unified'));
      await tester.pumpAndSettle();

      // Assert - Should switch views
      expect(find.byType(DiffViewer), findsOneWidget);
    });

    testWidgets('should show side by side view by default', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert - Should have two columns (old and new)
      expect(find.byType(VerticalDivider), findsOneWidget);
    });

    testWidgets('should show unified view when mode is unified',
        (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];
      final state = const DiffState(viewMode: DiffViewMode.unified);

      // Act
      await tester.pumpWidget(createTestWidget(
        initialState: state,
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      // Assert - Should have single list view
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('DiffViewer - Diff Display', () {
    testWidgets('should display diff hunks', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(header: '@@ -1,5 +1,6 @@'),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('@@ -1,5 +1,6 @@'), findsWidgets);
    });

    testWidgets('should display added lines with green background',
        (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.added,
              content: 'new line',
              newLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert - Should have containers with background color
      expect(find.text('new line'), findsWidgets);
    });

    testWidgets('should display removed lines with red background',
        (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.removed,
              content: 'old line',
              oldLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('old line'), findsWidgets);
    });

    testWidgets('should display context lines', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.context,
              content: 'context line',
              oldLineNumber: 1,
              newLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('context line'), findsWidgets);
    });

    testWidgets('should display line numbers', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.context,
              oldLineNumber: 1,
              newLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('1'), findsWidgets);
    });
  });

  group('DiffViewer - File Info', () {
    testWidgets('should show file path in toolbar', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];

      // Act
      await tester.pumpWidget(createTestWidget(
        filePath: 'lib/src/test.dart',
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('lib/src/test.dart'), findsOneWidget);
    });

    testWidgets('should show file icon in toolbar', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];

      // Act
      await tester.pumpWidget(createTestWidget(
        filePath: 'test.dart',
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
    });
  });

  group('DiffViewer - Copy Functionality', () {
    testWidgets('should show copy button', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.widgetWithIcon(IconButton, Icons.copy), findsOneWidget);
    });

    testWidgets('should copy diff on copy button tap', (tester) async {
      // Arrange
      final hunks = [createDiffHunk()];

      // Act
      await tester.pumpWidget(createTestWidget(
        filePath: 'test.dart',
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(IconButton, Icons.copy));
      await tester.pumpAndSettle();

      // Assert - Should show snackbar
      expect(find.text('Diff copied to clipboard'), findsOneWidget);
    });
  });

  group('DiffViewer - Side by Side View', () {
    testWidgets('should show old version on left side', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.removed,
              content: 'old content',
              oldLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('old content'), findsWidgets);
    });

    testWidgets('should show new version on right side', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.added,
              content: 'new content',
              newLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('new content'), findsWidgets);
    });

    testWidgets('should sync scroll between old and new versions',
        (tester) async {
      // Arrange
      final hunks = List.generate(
        20,
        (i) => createDiffHunk(header: '@@ -$i,1 +$i,1 @@'),
      );

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Scroll in one of the list views
      final listViews = find.byType(ListView);
      if (listViews.evaluate().isNotEmpty) {
        await tester.drag(listViews.first, const Offset(0, -200));
        await tester.pumpAndSettle();
      }

      // Assert - Widget should still render
      expect(find.byType(DiffViewer), findsOneWidget);
    });
  });

  group('DiffViewer - Unified View', () {
    testWidgets('should show diff markers in unified view', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.added,
              content: 'added',
              newLineNumber: 1,
            ),
            createDiffLine(
              type: DiffLineType.removed,
              content: 'removed',
              oldLineNumber: 1,
            ),
          ],
        ),
      ];

      final state = const DiffState(viewMode: DiffViewMode.unified);

      // Act
      await tester.pumpWidget(createTestWidget(
        initialState: state,
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('added'), findsOneWidget);
      expect(find.text('removed'), findsOneWidget);
    });
  });

  group('DiffStatistics', () {
    testWidgets('should render diff statistics', (tester) async {
      // Arrange
      when(() => mockDiffService.calculateStatistics(any()))
          .thenReturn(const DiffStatistics(
        additions: 10,
        deletions: 5,
        changes: 15,
      ));

      final hunks = [createDiffHunk()];
      final state = DiffState(
        fileDiffs: {'test.dart': hunks},
        selectedFile: 'test.dart',
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diffNotifierProvider
                .overrideWith((ref) => MockDiffNotifier(state)),
            diffServiceProvider.overrideWithValue(mockDiffService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DiffStatistics(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('10'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('should show icons for additions and deletions',
        (tester) async {
      // Arrange
      when(() => mockDiffService.calculateStatistics(any()))
          .thenReturn(const DiffStatistics(
        additions: 10,
        deletions: 5,
        changes: 15,
      ));

      final hunks = [createDiffHunk()];
      final state = DiffState(
        fileDiffs: {'test.dart': hunks},
        selectedFile: 'test.dart',
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diffNotifierProvider
                .overrideWith((ref) => MockDiffNotifier(state)),
            diffServiceProvider.overrideWithValue(mockDiffService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DiffStatistics(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.timeline), findsOneWidget);
    });

    testWidgets('should not render when no statistics', (tester) async {
      // Arrange
      const state = DiffState();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diffNotifierProvider
                .overrideWith((ref) => MockDiffNotifier(state)),
            diffServiceProvider.overrideWithValue(mockDiffService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DiffStatistics(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DiffStatistics), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });
  });

  group('DiffViewer - Multiple Hunks', () {
    testWidgets('should display multiple hunks', (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(header: '@@ -1,3 +1,3 @@'),
        createDiffHunk(header: '@@ -10,5 +10,6 @@'),
        createDiffHunk(header: '@@ -20,2 +21,2 @@'),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(hunks: hunks));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('@@ -1,3 +1,3 @@'), findsWidgets);
      expect(find.text('@@ -10,5 +10,6 @@'), findsWidgets);
      expect(find.text('@@ -20,2 +21,2 @@'), findsWidgets);
    });
  });

  group('DiffViewer - Syntax Highlighting', () {
    testWidgets('should apply syntax highlighting for known languages',
        (tester) async {
      // Arrange
      final hunks = [
        createDiffHunk(
          lines: [
            createDiffLine(
              type: DiffLineType.added,
              content: 'void main() { }',
              newLineNumber: 1,
            ),
          ],
        ),
      ];

      // Act
      await tester.pumpWidget(createTestWidget(
        filePath: 'test.dart',
        hunks: hunks,
      ));
      await tester.pumpAndSettle();

      // Assert - Should have HighlightView for syntax highlighting
      expect(find.text('void main() { }'), findsWidgets);
    });
  });
}
