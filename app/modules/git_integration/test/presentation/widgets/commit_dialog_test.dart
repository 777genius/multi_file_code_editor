import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockGitService extends Mock implements GitService {}

class MockGitRepositoryNotifier extends GitRepositoryNotifier {
  GitRepositoryState _currentState;

  MockGitRepositoryNotifier(this._currentState);

  @override
  GitRepositoryState build() => _currentState;

  @override
  Future<GitCommit?> commit({
    required String message,
    required GitAuthor author,
    bool amend = false,
  }) async {
    return GitCommit(
      hash: GitHash.create('abc123'),
      author: author,
      committer: author,
      authorDate: DateTime.now(),
      commitDate: DateTime.now(),
      message: GitCommitMessage.create(message),
      parentHash: none(),
      tags: const [],
      isMergeCommit: false,
      changedFiles: const [],
      insertions: 0,
      deletions: 0,
    );
  }
}

void main() {
  late MockGitService mockGitService;

  setUp(() {
    mockGitService = MockGitService();
  });

  Widget createTestWidget({
    bool amend = false,
    GitRepositoryState? initialState,
  }) {
    final state = initialState ?? const GitRepositoryState();

    return ProviderScope(
      overrides: [
        gitRepositoryNotifierProvider
            .overrideWith((ref) => MockGitRepositoryNotifier(state)),
        gitServiceProvider.overrideWithValue(mockGitService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: CommitDialog(amend: amend),
        ),
      ),
    );
  }

  group('CommitDialog - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CommitDialog), findsOneWidget);
    });

    testWidgets('should show "Create Commit" title for new commit',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(amend: false));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Create Commit'), findsOneWidget);
    });

    testWidgets('should show "Amend Commit" title for amend', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(amend: true));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Amend Commit'), findsOneWidget);
    });
  });

  group('CommitDialog - Form Fields', () {
    testWidgets('should display all form fields', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Commit Message'), findsOneWidget);
      expect(find.text('Description (optional)'), findsOneWidget);
      expect(find.text('Author'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should show conventional commit toggle', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Use Conventional Commit'), findsOneWidget);
      expect(
        find.text('Format: type(scope): subject'),
        findsOneWidget,
      );
    });

    testWidgets('should show commit type selector when conventional enabled',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enable conventional commits
      final conventionalToggle = find.byType(CheckboxListTile);
      await tester.tap(conventionalToggle);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Commit Type'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });
  });

  group('CommitDialog - Validation', () {
    testWidgets('should validate required fields', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Try to commit without filling fields
      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert - Should show validation errors
      expect(find.text('Commit message is required'), findsOneWidget);
    });

    testWidgets('should validate commit message length', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enter short message
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'ab',
      );
      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Commit message is too short'), findsOneWidget);
    });

    testWidgets('should validate author name', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Clear author name
      final nameField = find.widgetWithText(TextFormField, 'Name');
      await tester.enterText(nameField, '');

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'Valid commit message',
      );

      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('should validate author email', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enter invalid email
      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'invalid-email');

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'Valid commit message',
      );

      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Invalid email'), findsOneWidget);
    });
  });

  group('CommitDialog - Conventional Commits', () {
    testWidgets('should toggle conventional commit mode', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      final toggle = find.byType(CheckboxListTile);
      await tester.tap(toggle);
      await tester.pumpAndSettle();

      // Assert - Type selector should appear
      expect(find.text('Commit Type'), findsOneWidget);
    });

    testWidgets('should show all commit types', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enable conventional commits
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Act - Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('feat'), findsWidgets);
      expect(find.text('fix'), findsWidgets);
      expect(find.text('docs'), findsWidgets);
      expect(find.text('refactor'), findsWidgets);
    });

    testWidgets('should select commit type', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enable conventional commits
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Act - Select a type
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('fix').last);
      await tester.pumpAndSettle();

      // Assert - Widget should render without error
      expect(find.byType(CommitDialog), findsOneWidget);
    });
  });

  group('CommitDialog - User Interactions', () {
    testWidgets('should cancel dialog on cancel button', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert - Dialog should close
      expect(find.byType(CommitDialog), findsNothing);
    });

    testWidgets('should update character count on input', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'Test message',
      );
      await tester.pumpAndSettle();

      // Assert - Counter should update
      expect(find.textContaining('/50'), findsOneWidget);
    });

    testWidgets('should create commit with valid data', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Fill in all fields
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'Add new feature',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description (optional)'),
        'This is a detailed description',
      );

      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert - Dialog should close
      expect(find.byType(CommitDialog), findsNothing);
    });

    testWidgets('should show loading state while committing', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'Valid message',
      );

      await tester.tap(find.text('Commit'));
      await tester.pump();

      // Assert - Loading indicator should appear briefly
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('QuickCommitDialog', () {
    Widget createQuickCommitWidget() {
      return ProviderScope(
        overrides: [
          gitRepositoryNotifierProvider.overrideWith(
            (ref) => MockGitRepositoryNotifier(const GitRepositoryState()),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: QuickCommitDialog(),
          ),
        ),
      );
    }

    testWidgets('should render quick commit dialog', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createQuickCommitWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Quick Commit'), findsOneWidget);
      expect(find.text('Commit message'), findsOneWidget);
    });

    testWidgets('should disable commit button when empty', (tester) async {
      // Arrange
      await tester.pumpWidget(createQuickCommitWidget());
      await tester.pumpAndSettle();

      // Act - Get commit button
      final commitButton = find.ancestor(
        of: find.text('Commit'),
        matching: find.byType(FilledButton),
      );

      final button = tester.widget<FilledButton>(commitButton);

      // Assert
      expect(button.onPressed, isNull);
    });

    testWidgets('should enable commit button with text', (tester) async {
      // Arrange
      await tester.pumpWidget(createQuickCommitWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.widgetWithText(TextField, 'Commit message'),
        'Quick commit message',
      );
      await tester.pumpAndSettle();

      final commitButton = find.ancestor(
        of: find.text('Commit'),
        matching: find.byType(FilledButton),
      );

      final button = tester.widget<FilledButton>(commitButton);

      // Assert
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should commit with quick message', (tester) async {
      // Arrange
      await tester.pumpWidget(createQuickCommitWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.widgetWithText(TextField, 'Commit message'),
        'Quick fix',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert - Dialog should close
      expect(find.byType(QuickCommitDialog), findsNothing);
    });
  });

  group('CommitDialog - Edge Cases', () {
    testWidgets('should handle max length for commit message', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enter max length message
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'A' * 50,
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('50/50'), findsOneWidget);
    });

    testWidgets('should handle conventional commit formatting', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enable conventional and fill message
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Commit Message'),
        'add user authentication',
      );

      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();

      // Assert - Should create commit (dialog closes)
      expect(find.byType(CommitDialog), findsNothing);
    });
  });
}
