import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockGitService extends Mock implements GitService {}

void main() {
  late MockGitService mockGitService;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(RepositoryPath.create('/test/repo'));
    registerFallbackValue(GitAuthor.create(name: 'Test', email: 'test@example.com'));
  });

  setUp(() {
    mockGitService = MockGitService();

    container = ProviderContainer(
      overrides: [
        gitServiceProvider.overrideWithValue(mockGitService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  GitRepository createRepository({
    List<FileChange>? changes,
    List<FileChange>? stagedChanges,
  }) {
    return GitRepository(
      path: RepositoryPath.create('/test/repo'),
      currentBranch: some(GitBranch(
        name: BranchName.create('main'),
        headCommit: some(GitHash.create('abc123')),
        isRemote: false,
      )),
      localBranches: [],
      remoteBranches: [],
      changes: changes ?? [],
      stagedChanges: stagedChanges ?? [],
      remotes: [],
      stashes: [],
      headCommit: some(GitHash.create('abc123')),
      status: RepositoryStatus.clean,
    );
  }

  GitCommit createCommit() {
    return GitCommit(
      hash: GitHash.create('abc123'),
      author: GitAuthor.create(name: 'Test', email: 'test@example.com'),
      committer: GitAuthor.create(name: 'Test', email: 'test@example.com'),
      authorDate: DateTime.now(),
      commitDate: DateTime.now(),
      message: GitCommitMessage.create('test commit'),
      parentHash: none(),
      tags: const [],
      isMergeCommit: false,
      changedFiles: const [],
      insertions: 0,
      deletions: 0,
    );
  }

  group('GitRepositoryNotifier - Initial State', () {
    test('should have empty initial state', () {
      // Arrange & Act
      final state = container.read(gitRepositoryNotifierProvider);

      // Assert
      expect(state.repository, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.hasRepository, isFalse);
    });
  });

  group('GitRepositoryNotifier - openRepository', () {
    test('should open repository successfully', () async {
      // Arrange
      final repository = createRepository();

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(repository));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      final path = RepositoryPath.create('/test/repo');

      // Act
      await notifier.openRepository(path);

      // Assert
      final state = container.read(gitRepositoryNotifierProvider);
      expect(state.repository, equals(repository));
      expect(state.isLoading, isFalse);
      expect(state.hasRepository, isTrue);

      final currentPath = container.read(currentRepositoryPathProvider);
      expect(currentPath, equals(path));
    });

    test('should set loading state while opening', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return right(createRepository());
        },
      );

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);

      // Act
      final future =
          notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Assert - Check loading state immediately
      final loadingState = container.read(gitRepositoryNotifierProvider);
      expect(loadingState.isLoading, isTrue);

      await future;
    });

    test('should handle open failure', () async {
      // Arrange
      final failure = GitFailure.notFound(path: '/test/repo');

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => left(failure));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);

      // Act
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Assert
      final state = container.read(gitRepositoryNotifierProvider);
      expect(state.error, equals(failure));
      expect(state.isLoading, isFalse);
      expect(state.hasError, isTrue);
    });
  });

  group('GitRepositoryNotifier - refresh', () {
    test('should refresh repository status', () async {
      // Arrange
      final repository = createRepository();

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(repository));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.refresh();

      // Assert
      verify(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: true,
          )).called(1);
    });

    test('should handle refresh failure', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      final failure = GitFailure.operationFailed(
        operation: 'refresh',
        reason: 'test',
      );

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: true,
          )).thenAnswer((_) async => left(failure));

      // Act
      await notifier.refresh();

      // Assert
      final state = container.read(gitRepositoryNotifierProvider);
      expect(state.error, equals(failure));
    });
  });

  group('GitRepositoryNotifier - stageFiles', () {
    test('should stage files successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.stageFiles(
            path: any(named: 'path'),
            filePaths: any(named: 'filePaths'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.stageFiles(['file1.dart', 'file2.dart']);

      // Assert
      verify(() => mockGitService.stageFiles(
            path: any(named: 'path'),
            filePaths: ['file1.dart', 'file2.dart'],
          )).called(1);
    });

    test('should refresh after staging', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.stageFiles(
            path: any(named: 'path'),
            filePaths: any(named: 'filePaths'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.stageFiles(['file1.dart']);

      // Assert - Refresh should be called
      verify(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: true,
          )).called(1);
    });
  });

  group('GitRepositoryNotifier - stageAll', () {
    test('should stage all files successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.stageAll(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.stageAll();

      // Assert
      verify(() => mockGitService.stageAll(
            path: any(named: 'path'),
          )).called(1);
    });
  });

  group('GitRepositoryNotifier - unstageFiles', () {
    test('should unstage files successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.unstageFiles(
            path: any(named: 'path'),
            filePaths: any(named: 'filePaths'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.unstageFiles(['file1.dart']);

      // Assert
      verify(() => mockGitService.unstageFiles(
            path: any(named: 'path'),
            filePaths: ['file1.dart'],
          )).called(1);
    });
  });

  group('GitRepositoryNotifier - unstageAll', () {
    test('should unstage all files successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.unstageAll(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.unstageAll();

      // Assert
      verify(() => mockGitService.unstageAll(
            path: any(named: 'path'),
          )).called(1);
    });
  });

  group('GitRepositoryNotifier - commit', () {
    test('should commit successfully', () async {
      // Arrange
      final commit = createCommit();

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.commit(
            path: any(named: 'path'),
            message: any(named: 'message'),
            author: any(named: 'author'),
            amend: any(named: 'amend'),
          )).thenAnswer((_) async => right(commit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      final author = GitAuthor.create(name: 'Test', email: 'test@example.com');

      // Act
      final result = await notifier.commit(
        message: 'test commit',
        author: author,
      );

      // Assert
      expect(result, equals(commit));
    });

    test('should handle commit with amend', () async {
      // Arrange
      final commit = createCommit();

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.commit(
            path: any(named: 'path'),
            message: any(named: 'message'),
            author: any(named: 'author'),
            amend: true,
          )).thenAnswer((_) async => right(commit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      final author = GitAuthor.create(name: 'Test', email: 'test@example.com');

      // Act
      final result = await notifier.commit(
        message: 'test commit',
        author: author,
        amend: true,
      );

      // Assert
      expect(result, equals(commit));
      verify(() => mockGitService.commit(
            path: any(named: 'path'),
            message: 'test commit',
            author: author,
            amend: true,
          )).called(1);
    });

    test('should return null on commit failure', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.commit(
            path: any(named: 'path'),
            message: any(named: 'message'),
            author: any(named: 'author'),
            amend: any(named: 'amend'),
          )).thenAnswer(
        (_) async => left(GitFailure.operationFailed(
          operation: 'commit',
          reason: 'test',
        )),
      );

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      final author = GitAuthor.create(name: 'Test', email: 'test@example.com');

      // Act
      final result = await notifier.commit(
        message: 'test commit',
        author: author,
      );

      // Assert
      expect(result, isNull);
    });
  });

  group('GitRepositoryNotifier - branch operations', () {
    test('should checkout branch successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.checkoutBranch(
            path: any(named: 'path'),
            branchName: any(named: 'branchName'),
            force: any(named: 'force'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.checkoutBranch('develop');

      // Assert
      verify(() => mockGitService.checkoutBranch(
            path: any(named: 'path'),
            branchName: 'develop',
            force: false,
          )).called(1);
    });

    test('should create branch successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.createBranch(
            path: any(named: 'path'),
            branchName: any(named: 'branchName'),
            startPoint: any(named: 'startPoint'),
            checkout: any(named: 'checkout'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.createBranch(
        branchName: 'feature/new',
        checkout: true,
      );

      // Assert
      verify(() => mockGitService.createBranch(
            path: any(named: 'path'),
            branchName: 'feature/new',
            startPoint: null,
            checkout: true,
          )).called(1);
    });

    test('should delete branch successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.deleteBranch(
            path: any(named: 'path'),
            branchName: any(named: 'branchName'),
            force: any(named: 'force'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.deleteBranch(branchName: 'old-branch');

      // Assert
      verify(() => mockGitService.deleteBranch(
            path: any(named: 'path'),
            branchName: 'old-branch',
            force: false,
          )).called(1);
    });
  });

  group('GitRepositoryNotifier - remote operations', () {
    test('should push successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.push(
            path: any(named: 'path'),
            remote: any(named: 'remote'),
            branch: any(named: 'branch'),
            force: any(named: 'force'),
            setUpstream: any(named: 'setUpstream'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.push(branch: 'main');

      // Assert
      verify(() => mockGitService.push(
            path: any(named: 'path'),
            remote: 'origin',
            branch: 'main',
            force: false,
            setUpstream: false,
          )).called(1);
    });

    test('should pull successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.pull(
            path: any(named: 'path'),
            remote: any(named: 'remote'),
            rebase: any(named: 'rebase'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.pull(rebase: true);

      // Assert
      verify(() => mockGitService.pull(
            path: any(named: 'path'),
            remote: 'origin',
            rebase: true,
          )).called(1);
    });

    test('should fetch successfully', () async {
      // Arrange
      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(createRepository()));

      when(() => mockGitService.fetch(
            path: any(named: 'path'),
            remote: any(named: 'remote'),
          )).thenAnswer((_) async => right(unit));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      await notifier.fetch();

      // Assert
      verify(() => mockGitService.fetch(
            path: any(named: 'path'),
            remote: 'origin',
          )).called(1);
    });
  });

  group('GitRepositoryNotifier - file selection', () {
    test('should toggle file selection', () {
      // Arrange
      final file = FileChange(
        path: 'test.dart',
        status: ChangeStatus.modified,
        stagedStatus: none(),
      );

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);

      // Act
      notifier.toggleFileSelection(file);

      // Assert
      final state = container.read(gitRepositoryNotifierProvider);
      expect(state.selectedFiles, contains(file));

      // Act - Toggle again
      notifier.toggleFileSelection(file);

      // Assert
      final newState = container.read(gitRepositoryNotifierProvider);
      expect(newState.selectedFiles, isNot(contains(file)));
    });

    test('should clear file selection', () {
      // Arrange
      final file = FileChange(
        path: 'test.dart',
        status: ChangeStatus.modified,
        stagedStatus: none(),
      );

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      notifier.toggleFileSelection(file);

      // Act
      notifier.clearSelection();

      // Assert
      final state = container.read(gitRepositoryNotifierProvider);
      expect(state.selectedFiles, isEmpty);
    });

    test('should select all files', () async {
      // Arrange
      final changes = [
        FileChange(
          path: 'file1.dart',
          status: ChangeStatus.modified,
          stagedStatus: none(),
        ),
        FileChange(
          path: 'file2.dart',
          status: ChangeStatus.modified,
          stagedStatus: none(),
        ),
      ];

      final repository = createRepository(changes: changes);

      when(() => mockGitService.getStatus(
            path: any(named: 'path'),
            forceRefresh: any(named: 'forceRefresh'),
          )).thenAnswer((_) async => right(repository));

      final notifier = container.read(gitRepositoryNotifierProvider.notifier);
      await notifier.openRepository(RepositoryPath.create('/test/repo'));

      // Act
      notifier.selectAll();

      // Assert
      final state = container.read(gitRepositoryNotifierProvider);
      expect(state.selectedFiles.length, equals(2));
    });
  });

  group('CommitHistoryNotifier - load', () {
    test('should load commit history successfully', () async {
      // Arrange
      final commits = [createCommit(), createCommit()];

      when(() => mockGitService.getHistory(
            path: any(named: 'path'),
            maxCount: any(named: 'maxCount'),
            skip: any(named: 'skip'),
          )).thenAnswer((_) async => right(commits));

      container.read(currentRepositoryPathProvider.notifier).state =
          RepositoryPath.create('/test/repo');

      final notifier = container.read(commitHistoryNotifierProvider.notifier);

      // Act
      await notifier.load();

      // Assert
      final state = container.read(commitHistoryNotifierProvider);
      expect(state.value, equals(commits));
    });

    test('should handle load failure', () async {
      // Arrange
      final failure = GitFailure.notFound(path: '/test/repo');

      when(() => mockGitService.getHistory(
            path: any(named: 'path'),
            maxCount: any(named: 'maxCount'),
            skip: any(named: 'skip'),
          )).thenAnswer((_) async => left(failure));

      container.read(currentRepositoryPathProvider.notifier).state =
          RepositoryPath.create('/test/repo');

      final notifier = container.read(commitHistoryNotifierProvider.notifier);

      // Act
      await notifier.load();

      // Assert
      final state = container.read(commitHistoryNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('CommitHistoryNotifier - loadMore', () {
    test('should load more commits', () async {
      // Arrange
      final initialCommits = [createCommit()];
      final moreCommits = [createCommit(), createCommit()];

      when(() => mockGitService.getHistory(
            path: any(named: 'path'),
            maxCount: any(named: 'maxCount'),
            skip: 0,
          )).thenAnswer((_) async => right(initialCommits));

      when(() => mockGitService.getHistory(
            path: any(named: 'path'),
            maxCount: 50,
            skip: 1,
          )).thenAnswer((_) async => right(moreCommits));

      container.read(currentRepositoryPathProvider.notifier).state =
          RepositoryPath.create('/test/repo');

      final notifier = container.read(commitHistoryNotifierProvider.notifier);
      await notifier.load();

      // Act
      await notifier.loadMore();

      // Assert
      final state = container.read(commitHistoryNotifierProvider);
      expect(state.value!.length, equals(3)); // 1 + 2
    });
  });
}
