import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/src/presentation/widgets/git_panel_enhanced.dart';
import 'package:git_integration/src/presentation/providers/git_state_provider.dart';
import 'package:git_integration/src/domain/entities/git_repository.dart';
import 'package:git_integration/src/domain/entities/git_status.dart';
import 'package:git_integration/src/domain/entities/merge_state.dart';
import 'package:git_integration/src/domain/value_objects/repository_path.dart';

void main() {
  Widget createTestWidget({
    GitState? initialState,
  }) {
    return ProviderScope(
      overrides: initialState != null
          ? [
              gitStateProvider.overrideWith((ref) => initialState),
            ]
          : [],
      child: const MaterialApp(
        home: Scaffold(
          body: GitPanelEnhanced(),
        ),
      ),
    );
  }

  group('GitPanelEnhanced - No Repository', () {
    testWidgets('should show "No repository" message when no repo is open',
        (tester) async {
      // Arrange
      final state = GitState(
        repository: null,
        currentBranch: null,
        branches: [],
        status: null,
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('No repository'), findsOneWidget);
    });

    testWidgets('should show "Open Repository" button when no repo is open',
        (tester) async {
      // Arrange
      final state = GitState(
        repository: null,
        currentBranch: null,
        branches: [],
        status: null,
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Open Repository'), findsOneWidget);
    });
  });

  group('GitPanelEnhanced - With Repository', () {
    testWidgets('should show current branch name', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main', 'develop'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('main'), findsWidgets);
    });

    testWidgets('should show sync button', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.sync), findsOneWidget);
    });

    testWidgets('should show refresh button', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should show SSH key manager button', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.vpn_key), findsOneWidget);
    });
  });

  group('GitPanelEnhanced - File Changes', () {
    testWidgets('should show modified files', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: ['file1.dart', 'file2.dart'],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('file1.dart'), findsOneWidget);
      expect(find.text('file2.dart'), findsOneWidget);
    });

    testWidgets('should show added files', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: ['new_file.dart'],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('new_file.dart'), findsOneWidget);
    });

    testWidgets('should show deleted files', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: ['removed.dart'],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('removed.dart'), findsOneWidget);
    });

    testWidgets('should show "No changes" when status is clean',
        (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('No changes'), findsOneWidget);
    });
  });

  group('GitPanelEnhanced - Merge Conflicts', () {
    testWidgets('should show conflict banner when conflicts exist',
        (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: ['conflicted_file.dart'],
        ),
        mergeState: MergeState(
          hasConflicts: true,
          conflictedFiles: [
            ConflictedFile(
              path: 'conflicted_file.dart',
              currentContent: 'current',
              incomingContent: 'incoming',
              baseContent: 'base',
            ),
          ],
          mergeHead: 'feature-branch',
        ),
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Merge Conflicts'), findsOneWidget);
      expect(find.text('Resolve'), findsOneWidget);
    });

    testWidgets('should show conflict count', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: ['file1.dart', 'file2.dart', 'file3.dart'],
        ),
        mergeState: MergeState(
          hasConflicts: true,
          conflictedFiles: [
            ConflictedFile(
              path: 'file1.dart',
              currentContent: 'current1',
              incomingContent: 'incoming1',
              baseContent: 'base1',
            ),
            ConflictedFile(
              path: 'file2.dart',
              currentContent: 'current2',
              incomingContent: 'incoming2',
              baseContent: 'base2',
            ),
            ConflictedFile(
              path: 'file3.dart',
              currentContent: 'current3',
              incomingContent: 'incoming3',
              baseContent: 'base3',
            ),
          ],
          mergeHead: 'feature',
        ),
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('3 file'), findsOneWidget);
    });

    testWidgets('should not show conflict banner when no conflicts',
        (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Merge Conflicts'), findsNothing);
      expect(find.text('Resolve'), findsNothing);
    });
  });

  group('GitPanelEnhanced - Loading State', () {
    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: null,
        mergeState: null,
        isLoading: true,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pump(); // Don't settle, to catch loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('GitPanelEnhanced - Error State', () {
    testWidgets('should show error message when error occurs', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: null,
        branches: [],
        status: null,
        mergeState: null,
        isLoading: false,
        error: 'Failed to fetch repository status',
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(
          find.textContaining('Failed to fetch repository status'),
          findsOneWidget);
    });
  });

  group('GitPanelEnhanced - Branch Management', () {
    testWidgets('should show branch dropdown', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main', 'develop', 'feature'],
        status: GitStatus(
          modified: [],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Branch name should be shown
      expect(find.textContaining('main'), findsWidgets);
    });
  });

  group('GitPanelEnhanced - Commit Button', () {
    testWidgets('should show commit button', (tester) async {
      // Arrange
      final state = GitState(
        repository: GitRepository(
          path: RepositoryPath('/test/repo'),
          name: 'test-repo',
        ),
        currentBranch: 'main',
        branches: ['main'],
        status: GitStatus(
          modified: ['file.dart'],
          added: [],
          deleted: [],
          untracked: [],
          renamed: [],
          conflicted: [],
        ),
        mergeState: null,
        isLoading: false,
        error: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Commit'), findsWidgets);
    });
  });
}
