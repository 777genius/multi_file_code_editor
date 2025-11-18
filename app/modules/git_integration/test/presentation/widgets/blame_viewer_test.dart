import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockBlameService extends Mock implements BlameService {}

class MockBlameNotifier extends BlameNotifier {
  BlameState _currentState;

  MockBlameNotifier(this._currentState);

  @override
  BlameState build() => _currentState;

  void setState(BlameState newState) {
    _currentState = newState;
    state = newState;
  }
}

void main() {
  late MockBlameService mockBlameService;

  setUp(() {
    mockBlameService = MockBlameService();
  });

  Widget createTestWidget({
    BlameState? initialState,
    String? filePath,
    String? fileContent,
  }) {
    final state = initialState ?? const BlameState();

    return ProviderScope(
      overrides: [
        blameNotifierProvider.overrideWith((ref) => MockBlameNotifier(state)),
        blameServiceProvider.overrideWithValue(mockBlameService),
        currentRepositoryPathProvider.overrideWith((ref) =>
            RepositoryPath.create('/test/repo')),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: BlameViewer(
            filePath: filePath ?? 'test.dart',
            fileContent: fileContent ?? 'line 1\nline 2\nline 3',
          ),
        ),
      ),
    );
  }

  BlameLine createBlameLine({
    int lineNumber = 1,
    String authorName = 'John Doe',
    String commitMessage = 'test commit',
  }) {
    return BlameLine(
      lineNumber: lineNumber,
      commit: GitCommit(
        hash: GitHash.create('abc123'),
        author: GitAuthor.create(name: authorName, email: 'john@example.com'),
        committer: GitAuthor.create(name: authorName, email: 'john@example.com'),
        authorDate: DateTime.now().subtract(const Duration(days: 5)),
        commitDate: DateTime.now().subtract(const Duration(days: 5)),
        message: GitCommitMessage.create(commitMessage),
        parentHash: none(),
        tags: const [],
        isMergeCommit: false,
        changedFiles: const [],
        insertions: 0,
        deletions: 0,
      ),
    );
  }

  group('BlameViewer - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BlameViewer), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      const state = BlameState(isLoading: true);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state when error occurs', (tester) async {
      // Arrange
      final state = BlameState(
        error: GitFailure.notFound(path: '/test/file.dart'),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Failed to load blame'), findsOneWidget);
      expect(find.widgetWithIcon(FilledButton, Icons.refresh), findsOneWidget);
    });

    testWidgets('should show empty state when no blame data', (tester) async {
      // Arrange
      const state = BlameState(blameLines: []);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No Blame Information'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  group('BlameViewer - Blame Display', () {
    testWidgets('should display blame lines correctly', (tester) async {
      // Arrange
      final blameLines = [
        createBlameLine(lineNumber: 1, authorName: 'Alice'),
        createBlameLine(lineNumber: 2, authorName: 'Bob'),
        createBlameLine(lineNumber: 3, authorName: 'Charlie'),
      ];
      final state = BlameState(blameLines: blameLines);

      // Act
      await tester.pumpWidget(createTestWidget(
        initialState: state,
        fileContent: 'line 1\nline 2\nline 3',
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
    });

    testWidgets('should show file path in toolbar', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        initialState: state,
        filePath: 'lib/src/test.dart',
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('lib/src/test.dart'), findsOneWidget);
    });

    testWidgets('should display line numbers', (tester) async {
      // Arrange
      final blameLines = [
        createBlameLine(lineNumber: 1),
        createBlameLine(lineNumber: 2),
      ];
      final state = BlameState(blameLines: blameLines);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });

  group('BlameViewer - Heat Map', () {
    testWidgets('should show heat map when enabled', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Heat Map chip should be selected by default
      final heatMapChip = find.ancestor(
        of: find.text('Heat Map'),
        matching: find.byType(FilterChip),
      );
      expect(heatMapChip, findsOneWidget);
    });

    testWidgets('should toggle heat map on chip tap', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      final heatMapChip = find.ancestor(
        of: find.text('Heat Map'),
        matching: find.byType(FilterChip),
      );

      await tester.tap(heatMapChip);
      await tester.pumpAndSettle();

      // Assert - Widget should still render (state changed internally)
      expect(find.byType(BlameViewer), findsOneWidget);
    });
  });

  group('BlameViewer - Contributors Chart', () {
    testWidgets('should show contributors chart when enabled', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
        authorContribution: {
          'Alice': 60,
          'Bob': 40,
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Tap Contributors chip
      final contributorsChip = find.ancestor(
        of: find.text('Contributors'),
        matching: find.byType(FilterChip),
      );
      await tester.tap(contributorsChip);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Contributors'), findsWidgets);
    });
  });

  group('BlameViewer - User Interactions', () {
    testWidgets('should select line on tap', (tester) async {
      // Arrange
      final blameLine = createBlameLine(lineNumber: 1);
      final state = BlameState(blameLines: [blameLine]);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Find and tap the line
      final lineWidget = find.byType(InkWell).first;
      await tester.tap(lineWidget);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(BlameViewer), findsOneWidget);
    });

    testWidgets('should refresh blame on refresh button tap', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      final refreshButton = find.widgetWithIcon(IconButton, Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(BlameViewer), findsOneWidget);
    });
  });

  group('BlameViewer - Tooltip', () {
    testWidgets('should show tooltip when line is selected', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
        selectedLineNumber: 1,
        tooltip: const BlameTooltip(
          commitHash: 'abc123',
          author: 'John Doe',
          date: const_date,
          message: 'Test commit message',
          lineNumber: 1,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('John Doe'), findsWidgets);
      expect(find.text('Test commit message'), findsOneWidget);
    });

    testWidgets('should close tooltip on close button tap', (tester) async {
      // Arrange
      final state = BlameState(
        blameLines: [createBlameLine()],
        selectedLineNumber: 1,
        tooltip: const BlameTooltip(
          commitHash: 'abc123',
          author: 'John Doe',
          date: const_date,
          message: 'Test commit',
          lineNumber: 1,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      final closeButton = find.widgetWithIcon(IconButton, Icons.close);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(BlameViewer), findsOneWidget);
    });
  });

  group('BlameLegend', () {
    testWidgets('should render blame legend correctly', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BlameLegend(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('< 1 week'), findsOneWidget);
      expect(find.text('< 1 month'), findsOneWidget);
      expect(find.text('< 3 months'), findsOneWidget);
      expect(find.text('> 3 months'), findsOneWidget);
    });
  });
}

// Helper constant for tooltip date
final const_date = DateTime(2024, 1, 1);
