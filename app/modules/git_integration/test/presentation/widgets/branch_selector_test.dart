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

  void setState(GitRepositoryState newState) {
    _currentState = newState;
    state = newState;
  }

  @override
  Future<void> checkoutBranch(String branchName, {bool force = false}) async {
    // Mock implementation
  }

  @override
  Future<void> createBranch({
    required String branchName,
    String? startPoint,
    bool checkout = false,
  }) async {
    // Mock implementation
  }

  @override
  Future<void> deleteBranch({
    required String branchName,
    bool force = false,
  }) async {
    // Mock implementation
  }
}

void main() {
  late MockGitService mockGitService;

  setUp(() {
    mockGitService = MockGitService();
  });

  GitBranch createBranch({
    String name = 'main',
    bool isRemote = false,
    String? commitHash,
  }) {
    return GitBranch(
      name: BranchName.create(isRemote ? 'origin/$name' : name),
      headCommit: commitHash != null
          ? some(GitHash.create(commitHash))
          : none(),
      isRemote: isRemote,
    );
  }

  GitRepository createRepository({
    List<GitBranch>? localBranches,
    List<GitBranch>? remoteBranches,
    GitBranch? currentBranch,
  }) {
    return GitRepository(
      path: RepositoryPath.create('/test/repo'),
      currentBranch: currentBranch != null ? some(currentBranch) : none(),
      localBranches: localBranches ?? [createBranch(name: 'main')],
      remoteBranches: remoteBranches ?? [],
      changes: const [],
      stagedChanges: const [],
      remotes: const [],
      stashes: const [],
      headCommit: some(GitHash.create('abc123')),
      status: RepositoryStatus.clean,
    );
  }

  Widget createTestWidget({
    GitRepositoryState? initialState,
    bool showCreateButton = true,
  }) {
    final state = initialState ??
        GitRepositoryState(
          repository: createRepository(),
        );

    return ProviderScope(
      overrides: [
        gitRepositoryNotifierProvider
            .overrideWith((ref) => MockGitRepositoryNotifier(state)),
        gitServiceProvider.overrideWithValue(mockGitService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: BranchSelector(
            showCreateButton: showCreateButton,
          ),
        ),
      ),
    );
  }

  group('BranchSelector - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BranchSelector), findsOneWidget);
    });

    testWidgets('should show empty state when no repository', (tester) async {
      // Arrange
      const state = GitRepositoryState();

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No Repository'), findsOneWidget);
      expect(find.byIcon(Icons.call_split), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      final state = GitRepositoryState(
        repository: createRepository(),
        isLoading: true,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('BranchSelector - Branch List', () {
    testWidgets('should display local branches', (tester) async {
      // Arrange
      final localBranches = [
        createBranch(name: 'main'),
        createBranch(name: 'develop'),
        createBranch(name: 'feature/test'),
      ];

      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: localBranches,
          currentBranch: localBranches[0],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('main'), findsOneWidget);
      expect(find.text('develop'), findsOneWidget);
      expect(find.text('feature/test'), findsOneWidget);
    });

    testWidgets('should display remote branches when enabled', (tester) async {
      // Arrange
      final remoteBranches = [
        createBranch(name: 'main', isRemote: true),
        createBranch(name: 'develop', isRemote: true),
      ];

      final state = GitRepositoryState(
        repository: createRepository(
          remoteBranches: remoteBranches,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Remote branches section header should be visible
      expect(find.text('Remote Branches'), findsOneWidget);
    });

    testWidgets('should highlight current branch', (tester) async {
      // Arrange
      final currentBranch = createBranch(name: 'main');
      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: [
            currentBranch,
            createBranch(name: 'develop'),
          ],
          currentBranch: currentBranch,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Current branch should have check_circle icon
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('BranchSelector - Search', () {
    testWidgets('should show search bar', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.widgetWithText(TextField, 'Search branches...'),
        findsOneWidget,
      );
    });

    testWidgets('should filter branches on search', (tester) async {
      // Arrange
      final localBranches = [
        createBranch(name: 'main'),
        createBranch(name: 'feature/auth'),
        createBranch(name: 'feature/payment'),
      ];

      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: localBranches,
          currentBranch: localBranches[0],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(
        find.widgetWithText(TextField, 'Search branches...'),
        'feature',
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      // Assert - Should show filtered results
      expect(find.text('feature/auth'), findsOneWidget);
      expect(find.text('feature/payment'), findsOneWidget);
    });

    testWidgets('should clear search on clear button tap', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enter search text
      await tester.enterText(
        find.widgetWithText(TextField, 'Search branches...'),
        'test',
      );
      await tester.pumpAndSettle();

      // Tap clear button
      final clearButton = find.widgetWithIcon(IconButton, Icons.clear);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Assert - Search field should be empty
      final textField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Search branches...'),
      );
      expect(textField.controller?.text, isEmpty);
    });
  });

  group('BranchSelector - Remote Toggle', () {
    testWidgets('should toggle remote branches visibility', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Tap remote toggle chip
      final remoteChip = find.ancestor(
        of: find.text('Remote'),
        matching: find.byType(FilterChip),
      );
      await tester.tap(remoteChip);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(BranchSelector), findsOneWidget);
    });
  });

  group('BranchSelector - Branch Actions', () {
    testWidgets('should show branch menu on more button tap', (tester) async {
      // Arrange
      final localBranches = [
        createBranch(name: 'main'),
        createBranch(name: 'develop'),
      ];

      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: localBranches,
          currentBranch: localBranches[0],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Tap more button on develop branch
      final moreButtons = find.byIcon(Icons.more_vert);
      await tester.tap(moreButtons.last);
      await tester.pumpAndSettle();

      // Assert - Menu should be visible
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Merge'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Copy Name'), findsOneWidget);
    });

    testWidgets('should checkout branch on menu action', (tester) async {
      // Arrange
      final localBranches = [
        createBranch(name: 'main'),
        createBranch(name: 'develop'),
      ];

      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: localBranches,
          currentBranch: localBranches[0],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Open menu
      final moreButtons = find.byIcon(Icons.more_vert);
      await tester.tap(moreButtons.last);
      await tester.pumpAndSettle();

      // Tap checkout
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();

      // Assert - Should navigate back (pop)
      expect(find.byType(BranchSelector), findsNothing);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      // Arrange
      final localBranches = [
        createBranch(name: 'main'),
        createBranch(name: 'feature/test'),
      ];

      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: localBranches,
          currentBranch: localBranches[0],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Open menu on feature branch
      final moreButtons = find.byIcon(Icons.more_vert);
      await tester.tap(moreButtons.last);
      await tester.pumpAndSettle();

      // Tap delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert - Confirmation dialog should appear
      expect(find.text('Delete Branch'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('BranchSelector - Create Branch', () {
    testWidgets('should show create button when enabled', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(showCreateButton: true));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('should hide create button when disabled', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(showCreateButton: false));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('New'), findsNothing);
    });

    testWidgets('should show create branch dialog on button tap',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('New'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Create Branch'), findsOneWidget);
      expect(find.byType(CreateBranchDialog), findsOneWidget);
    });
  });

  group('CreateBranchDialog', () {
    testWidgets('should render create branch dialog', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitRepositoryNotifierProvider.overrideWith(
              (ref) => MockGitRepositoryNotifier(
                GitRepositoryState(repository: createRepository()),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CreateBranchDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Create Branch'), findsOneWidget);
      expect(find.text('Branch Name'), findsOneWidget);
      expect(find.text('Checkout branch'), findsOneWidget);
    });

    testWidgets('should validate branch name', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitRepositoryNotifierProvider.overrideWith(
              (ref) => MockGitRepositoryNotifier(
                GitRepositoryState(repository: createRepository()),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CreateBranchDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Try to create with invalid names
      final createButton = find.text('Create');

      // Test empty name
      await tester.tap(createButton);
      await tester.pumpAndSettle();
      expect(find.text('Branch name is required'), findsOneWidget);

      // Test name with spaces
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Branch Name'),
        'invalid name',
      );
      await tester.tap(createButton);
      await tester.pumpAndSettle();
      expect(find.text('Branch name cannot contain spaces'), findsOneWidget);

      // Test name with ..
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Branch Name'),
        'invalid..name',
      );
      await tester.tap(createButton);
      await tester.pumpAndSettle();
      expect(find.text('Branch name cannot contain ".."'), findsOneWidget);
    });

    testWidgets('should create branch with valid name', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitRepositoryNotifierProvider.overrideWith(
              (ref) => MockGitRepositoryNotifier(
                GitRepositoryState(repository: createRepository()),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CreateBranchDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Branch Name'),
        'feature/new-feature',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Assert - Dialog should close
      expect(find.byType(CreateBranchDialog), findsNothing);
    });

    testWidgets('should toggle checkout option', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gitRepositoryNotifierProvider.overrideWith(
              (ref) => MockGitRepositoryNotifier(
                GitRepositoryState(repository: createRepository()),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CreateBranchDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final checkboxTile = find.byType(CheckboxListTile);
      await tester.tap(checkboxTile);
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(CreateBranchDialog), findsOneWidget);
    });
  });

  group('BranchSelector - Empty State', () {
    testWidgets('should show no results message when search has no matches',
        (tester) async {
      // Arrange
      final state = GitRepositoryState(
        repository: createRepository(
          localBranches: [createBranch(name: 'main')],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Search branches...'),
        'nonexistent',
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 350));

      // Assert
      expect(find.text('No branches found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });
  });
}
