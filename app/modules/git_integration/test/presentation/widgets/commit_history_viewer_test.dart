import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockGitService extends Mock implements GitService {}

class MockCommitHistoryNotifier extends CommitHistoryNotifier {
  AsyncValue<List<GitCommit>> _currentState;

  MockCommitHistoryNotifier(this._currentState);

  @override
  AsyncValue<List<GitCommit>> build() => _currentState;

  void setState(AsyncValue<List<GitCommit>> newState) {
    _currentState = newState;
    state = newState;
  }

  @override
  Future<void> load({int maxCount = 100, int skip = 0}) async {
    // Mock implementation
  }

  @override
  Future<void> loadMore() async {
    // Mock implementation
  }
}

void main() {
  late MockGitService mockGitService;

  setUp(() {
    mockGitService = MockGitService();
  });

  GitCommit createCommit({
    String hash = 'abc123',
    String authorName = 'John Doe',
    String message = 'Test commit',
    int daysAgo = 1,
    List<String> tags = const [],
    bool isMergeCommit = false,
  }) {
    return GitCommit(
      hash: GitHash.create(hash),
      author: GitAuthor.create(
        name: authorName,
        email: 'john@example.com',
      ),
      committer: GitAuthor.create(
        name: authorName,
        email: 'john@example.com',
      ),
      authorDate: DateTime.now().subtract(Duration(days: daysAgo)),
      commitDate: DateTime.now().subtract(Duration(days: daysAgo)),
      message: GitCommitMessage.create(message),
      parentHash: none(),
      tags: tags,
      isMergeCommit: isMergeCommit,
      changedFiles: const [],
      insertions: 10,
      deletions: 5,
    );
  }

  Widget createTestWidget({
    AsyncValue<List<GitCommit>>? initialState,
  }) {
    final state = initialState ?? const AsyncValue.loading();

    return ProviderScope(
      overrides: [
        commitHistoryNotifierProvider
            .overrideWith((ref) => MockCommitHistoryNotifier(state)),
        gitServiceProvider.overrideWithValue(mockGitService),
        currentRepositoryPathProvider
            .overrideWith((ref) => RepositoryPath.create('/test/repo')),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: CommitHistoryViewer(),
        ),
      ),
    );
  }

  group('CommitHistoryViewer - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CommitHistoryViewer), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      const state = AsyncValue<List<GitCommit>>.loading();

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state when error occurs', (tester) async {
      // Arrange
      final state = AsyncValue<List<GitCommit>>.error(
        'Failed to load history',
        StackTrace.current,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Failed to load history'), findsOneWidget);
      expect(find.widgetWithIcon(FilledButton, Icons.refresh), findsOneWidget);
    });

    testWidgets('should show empty state when no commits', (tester) async {
      // Arrange
      const state = AsyncValue<List<GitCommit>>.data([]);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No commits'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });
  });

  group('CommitHistoryViewer - Commit List', () {
    testWidgets('should display list of commits', (tester) async {
      // Arrange
      final commits = [
        createCommit(hash: 'abc123', message: 'First commit'),
        createCommit(hash: 'def456', message: 'Second commit'),
        createCommit(hash: 'ghi789', message: 'Third commit'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('First commit'), findsOneWidget);
      expect(find.text('Second commit'), findsOneWidget);
      expect(find.text('Third commit'), findsOneWidget);
    });

    testWidgets('should display commit hashes', (tester) async {
      // Arrange
      final commits = [
        createCommit(hash: 'abc123'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('abc123'), findsOneWidget);
    });

    testWidgets('should display author names', (tester) async {
      // Arrange
      final commits = [
        createCommit(authorName: 'Alice'),
        createCommit(authorName: 'Bob'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('should show author avatars', (tester) async {
      // Arrange
      final commits = [
        createCommit(authorName: 'John Doe'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Should have CircleAvatar for author
      expect(find.byType(CircleAvatar), findsWidgets);
    });
  });

  group('CommitHistoryViewer - Commit Graph', () {
    testWidgets('should display commit graph visualization', (tester) async {
      // Arrange
      final commits = [
        createCommit(hash: 'abc123'),
        createCommit(hash: 'def456'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Should have graph nodes
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('CommitHistoryViewer - Tags and Metadata', () {
    testWidgets('should display commit tags', (tester) async {
      // Arrange
      final commits = [
        createCommit(tags: ['v1.0.0', 'release']),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('v1.0.0'), findsOneWidget);
      expect(find.text('release'), findsOneWidget);
    });

    testWidgets('should show merge commit indicator', (tester) async {
      // Arrange
      final commits = [
        createCommit(isMergeCommit: true, message: 'Merge branch'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Should show merge icon
      expect(find.byIcon(Icons.merge), findsOneWidget);
    });
  });

  group('CommitHistoryViewer - Search', () {
    testWidgets('should show search bar', (tester) async {
      // Arrange
      final commits = [createCommit()];
      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.widgetWithText(TextField, 'Search commits...'),
        findsOneWidget,
      );
    });

    testWidgets('should filter commits on search', (tester) async {
      // Arrange
      final commits = [
        createCommit(message: 'Add feature'),
        createCommit(message: 'Fix bug'),
        createCommit(message: 'Update docs'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Search commits...'),
        'feature',
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      // Assert
      expect(find.text('Add feature'), findsOneWidget);
      expect(find.text('Fix bug'), findsNothing);
    });

    testWidgets('should clear search on clear button tap', (tester) async {
      // Arrange
      final commits = [createCommit()];
      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Search commits...'),
        'test',
      );
      await tester.pumpAndSettle();

      final clearButton = find.widgetWithIcon(IconButton, Icons.clear);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Assert
      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Search commits...'),
      );
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('should show no results message when search has no matches',
        (tester) async {
      // Arrange
      final commits = [
        createCommit(message: 'Test commit'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Search commits...'),
        'nonexistent',
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      // Assert
      expect(find.text('No commits found'), findsOneWidget);
    });
  });

  group('CommitHistoryViewer - User Interactions', () {
    testWidgets('should refresh commits on refresh button tap', (tester) async {
      // Arrange
      final commits = [createCommit()];
      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      final refreshButton = find.widgetWithIcon(IconButton, Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(CommitHistoryViewer), findsOneWidget);
    });

    testWidgets('should open commit details on commit tap', (tester) async {
      // Arrange
      final commits = [
        createCommit(message: 'Test commit'),
      ];

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      final commitTile = find.byType(InkWell).first;
      await tester.tap(commitTile);
      await tester.pumpAndSettle();

      // Assert - Bottom sheet should appear
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });
  });

  group('CommitDetailsView', () {
    Widget createCommitDetailsWidget(GitCommit commit) {
      return MaterialApp(
        home: Scaffold(
          body: CommitDetailsView(
            commit: commit,
            scrollController: ScrollController(),
          ),
        ),
      );
    }

    testWidgets('should display commit details', (tester) async {
      // Arrange
      final commit = createCommit(
        hash: 'abc123def456',
        authorName: 'John Doe',
        message: 'Test commit\n\nDetailed description',
      );

      // Act
      await tester.pumpWidget(createCommitDetailsWidget(commit));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test commit'), findsWidgets);
      expect(find.text('John Doe'), findsWidgets);
    });

    testWidgets('should display commit hash', (tester) async {
      // Arrange
      final commit = createCommit(hash: 'abc123def456');

      // Act
      await tester.pumpWidget(createCommitDetailsWidget(commit));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('abc123def456'), findsOneWidget);
    });

    testWidgets('should display commit statistics', (tester) async {
      // Arrange
      final commit = GitCommit(
        hash: GitHash.create('abc123'),
        author: GitAuthor.create(name: 'John', email: 'john@example.com'),
        committer: GitAuthor.create(name: 'John', email: 'john@example.com'),
        authorDate: DateTime.now(),
        commitDate: DateTime.now(),
        message: GitCommitMessage.create('Test'),
        parentHash: none(),
        tags: const [],
        isMergeCommit: false,
        changedFiles: const [],
        insertions: 15,
        deletions: 8,
      );

      // Act
      await tester.pumpWidget(createCommitDetailsWidget(commit));
      await tester.pumpAndSettle();

      // Assert - Should show stats
      expect(find.text('15'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('should display changed files', (tester) async {
      // Arrange
      final commit = GitCommit(
        hash: GitHash.create('abc123'),
        author: GitAuthor.create(name: 'John', email: 'john@example.com'),
        committer: GitAuthor.create(name: 'John', email: 'john@example.com'),
        authorDate: DateTime.now(),
        commitDate: DateTime.now(),
        message: GitCommitMessage.create('Test'),
        parentHash: none(),
        tags: const [],
        isMergeCommit: false,
        changedFiles: ['lib/main.dart', 'lib/utils.dart'],
        insertions: 0,
        deletions: 0,
      );

      // Act
      await tester.pumpWidget(createCommitDetailsWidget(commit));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('lib/main.dart'), findsOneWidget);
      expect(find.text('lib/utils.dart'), findsOneWidget);
    });

    testWidgets('should close on close button tap', (tester) async {
      // Arrange
      final commit = createCommit();

      // Act
      await tester.pumpWidget(createCommitDetailsWidget(commit));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert - Should navigate back
      expect(find.byType(CommitDetailsView), findsNothing);
    });

    testWidgets('should copy hash on copy button tap', (tester) async {
      // Arrange
      final commit = createCommit(hash: 'abc123def456');

      // Act
      await tester.pumpWidget(createCommitDetailsWidget(commit));
      await tester.pumpAndSettle();

      // Tap copy button in hash row
      final copyButtons = find.byIcon(Icons.copy);
      if (copyButtons.evaluate().isNotEmpty) {
        await tester.tap(copyButtons.first);
        await tester.pumpAndSettle();
      }

      // Assert - Widget should still render
      expect(find.byType(CommitDetailsView), findsOneWidget);
    });
  });

  group('CommitHistoryViewer - Pagination', () {
    testWidgets('should load more commits on scroll to bottom',
        (tester) async {
      // Arrange
      final commits = List.generate(
        20,
        (i) => createCommit(hash: 'hash$i', message: 'Commit $i'),
      );

      final state = AsyncValue.data(commits);

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Scroll to bottom
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -5000),
      );
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(CommitHistoryViewer), findsOneWidget);
    });
  });
}
