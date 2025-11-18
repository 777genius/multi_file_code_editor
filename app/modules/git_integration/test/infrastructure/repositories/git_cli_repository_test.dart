import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:git_integration/git_integration.dart';
import 'package:git_integration/src/infrastructure/repositories/git_cli_repository.dart';
import 'package:git_integration/src/infrastructure/adapters/git_command_adapter.dart';
import 'package:git_integration/src/infrastructure/adapters/git_parser_adapter.dart';

class MockGitCommandAdapter extends Mock implements GitCommandAdapter {}

class MockGitParserAdapter extends Mock implements GitParserAdapter {}

// Mock entities for testing
class MockRepositoryPath extends Mock implements RepositoryPath {}

void main() {
  late GitCliRepository repository;
  late MockGitCommandAdapter mockCommandAdapter;
  late MockGitParserAdapter mockParserAdapter;
  late RepositoryPath testPath;

  setUp(() {
    mockCommandAdapter = MockGitCommandAdapter();
    mockParserAdapter = MockGitParserAdapter();
    repository = GitCliRepository(mockCommandAdapter, mockParserAdapter);
    testPath = RepositoryPath.create('/test/repo');

    // Register fallback values for mocktail
    registerFallbackValue<List<String>>([]);
  });

  group('GitCliRepository', () {
    group('Construction', () {
      test('should create repository with adapters', () {
        // Act
        final repo = GitCliRepository(mockCommandAdapter, mockParserAdapter);

        // Assert
        expect(repo, isA<GitCliRepository>());
        expect(repo, isA<IGitRepository>());
      });

      test('should implement IGitRepository interface', () {
        // Assert
        expect(repository, isA<IGitRepository>());
      });
    });

    group('Repository State Determination', () {
      test('should determine clean state with no changes', () async {
        // Arrange
        when(() => mockCommandAdapter.buildStatusCommand()).thenReturn(['status', '--porcelain=v2', '-b']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: any(named: 'args'),
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseStatus(any())).thenReturn((
          changes: <FileChange>[],
          stagedChanges: <FileChange>[],
          currentBranch: 'main',
          ahead: 0,
          behind: 0,
          headCommit: null,
        ));

        when(() => mockCommandAdapter.buildBranchListCommand(includeRemote: true))
            .thenReturn(['branch', '-a', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['branch', '-a', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right('* main abcd123'));

        when(() => mockParserAdapter.parseBranches(any())).thenReturn([
          GitBranch(
            name: BranchName.create('main'),
            isCurrent: true,
            isRemote: false,
            headCommit: fp.none(),
          ),
        ]);

        when(() => mockCommandAdapter.buildRemoteListCommand()).thenReturn(['remote', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['remote', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseRemotes(any())).thenReturn([]);

        when(() => testPath.exists()).thenAnswer((_) async => true);

        // Act
        final result = await repository.getStatus(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
        final repo = (result as Right<GitFailure, GitRepository>).value;
        expect(repo.state, equals(GitRepositoryState.clean));
      });

      test('should determine modified state with unstaged changes', () async {
        // Arrange
        final unstagedChanges = [
          FileChange.create(
            path: 'file.txt',
            status: FileStatus.modified,
          ),
        ];

        when(() => mockCommandAdapter.buildStatusCommand()).thenReturn(['status', '--porcelain=v2', '-b']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: any(named: 'args'),
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseStatus(any())).thenReturn((
          changes: unstagedChanges,
          stagedChanges: <FileChange>[],
          currentBranch: 'main',
          ahead: 0,
          behind: 0,
          headCommit: null,
        ));

        when(() => mockCommandAdapter.buildBranchListCommand(includeRemote: true))
            .thenReturn(['branch', '-a', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['branch', '-a', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseBranches(any())).thenReturn([]);

        when(() => mockCommandAdapter.buildRemoteListCommand()).thenReturn(['remote', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['remote', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseRemotes(any())).thenReturn([]);

        when(() => testPath.exists()).thenAnswer((_) async => true);

        // Act
        final result = await repository.getStatus(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
        final repo = (result as Right<GitFailure, GitRepository>).value;
        expect(repo.state, equals(GitRepositoryState.modified));
      });

      test('should determine staged state with staged changes', () async {
        // Arrange
        final stagedChanges = [
          FileChange.create(
            path: 'file.txt',
            status: FileStatus.added,
          ),
        ];

        when(() => mockCommandAdapter.buildStatusCommand()).thenReturn(['status', '--porcelain=v2', '-b']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: any(named: 'args'),
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseStatus(any())).thenReturn((
          changes: <FileChange>[],
          stagedChanges: stagedChanges,
          currentBranch: 'main',
          ahead: 0,
          behind: 0,
          headCommit: null,
        ));

        when(() => mockCommandAdapter.buildBranchListCommand(includeRemote: true))
            .thenReturn(['branch', '-a', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['branch', '-a', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseBranches(any())).thenReturn([]);

        when(() => mockCommandAdapter.buildRemoteListCommand()).thenReturn(['remote', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['remote', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseRemotes(any())).thenReturn([]);

        when(() => testPath.exists()).thenAnswer((_) async => true);

        // Act
        final result = await repository.getStatus(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
        final repo = (result as Right<GitFailure, GitRepository>).value;
        expect(repo.state, equals(GitRepositoryState.staged));
      });

      test('should determine merging state with conflicts', () async {
        // Arrange
        final conflictedChanges = [
          FileChange.create(
            path: 'file.txt',
            status: FileStatus.conflicted,
          ),
        ];

        when(() => mockCommandAdapter.buildStatusCommand()).thenReturn(['status', '--porcelain=v2', '-b']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: any(named: 'args'),
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseStatus(any())).thenReturn((
          changes: conflictedChanges,
          stagedChanges: <FileChange>[],
          currentBranch: 'main',
          ahead: 0,
          behind: 0,
          headCommit: null,
        ));

        when(() => mockCommandAdapter.buildBranchListCommand(includeRemote: true))
            .thenReturn(['branch', '-a', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['branch', '-a', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseBranches(any())).thenReturn([]);

        when(() => mockCommandAdapter.buildRemoteListCommand()).thenReturn(['remote', '-v']);
        when(() => mockCommandAdapter.executeAndGetOutput(
              args: ['remote', '-v'],
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer((_) async => right(''));

        when(() => mockParserAdapter.parseRemotes(any())).thenReturn([]);

        when(() => testPath.exists()).thenAnswer((_) async => true);

        // Act
        final result = await repository.getStatus(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
        final repo = (result as Right<GitFailure, GitRepository>).value;
        expect(repo.state, equals(GitRepositoryState.merging));
      });
    });

    group('Staging Operations', () {
      test('should stage files successfully', () async {
        // Arrange
        final filePaths = ['file1.txt', 'file2.txt'];

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', ...filePaths],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.stageFiles(
          path: testPath,
          filePaths: filePaths,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', ...filePaths],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should stage all files successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', '-A'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.stageAll(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', '-A'],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should unstage files successfully', () async {
        // Arrange
        final filePaths = ['file1.txt', 'file2.txt'];

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['reset', 'HEAD', '--', ...filePaths],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.unstageFiles(
          path: testPath,
          filePaths: filePaths,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['reset', 'HEAD', '--', ...filePaths],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should unstage all files successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['reset', 'HEAD'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.unstageAll(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['reset', 'HEAD'],
              workingDirectory: testPath.path,
            )).called(1);
      });
    });

    group('Branch Operations', () {
      test('should create branch successfully', () async {
        // Arrange
        final branchName = BranchName.create('feature/test');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['branch', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.createBranch(
          path: testPath,
          name: branchName,
        );

        // Assert
        expect(result.isRight(), isTrue);
        expect((result as Right).value.name, equals(branchName));
      });

      test('should create branch from specific commit', () async {
        // Arrange
        final branchName = BranchName.create('feature/test');
        final startPoint = fp.some(CommitHash.create('abc123'));

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['branch', branchName.value, 'abc123'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.createBranch(
          path: testPath,
          name: branchName,
          startPoint: startPoint,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['branch', branchName.value, 'abc123'],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should checkout branch successfully', () async {
        // Arrange
        final branchName = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.checkout(
          path: testPath,
          branch: branchName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should force checkout branch when specified', () async {
        // Arrange
        final branchName = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', '--force', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.checkout(
          path: testPath,
          branch: branchName,
          force: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', '--force', branchName.value],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should delete local branch successfully', () async {
        // Arrange
        final branchName = BranchName.create('feature/old');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['branch', '-d', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.deleteBranch(
          path: testPath,
          branch: branchName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should force delete local branch when specified', () async {
        // Arrange
        final branchName = BranchName.create('feature/old');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['branch', '-D', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.deleteBranch(
          path: testPath,
          branch: branchName,
          force: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should delete remote branch successfully', () async {
        // Arrange
        final branchName = BranchName.create('feature/old');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['push', 'origin', '--delete', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.deleteBranch(
          path: testPath,
          branch: branchName,
          remote: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should merge branch successfully', () async {
        // Arrange
        final branchName = BranchName.create('feature/test');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['merge', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.merge(
          path: testPath,
          branch: branchName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should merge branch with no fast-forward', () async {
        // Arrange
        final branchName = BranchName.create('feature/test');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['merge', '--no-ff', branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.merge(
          path: testPath,
          branch: branchName,
          noFastForward: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });
    });

    group('Remote Operations', () {
      test('should add remote successfully', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');
        const url = 'https://github.com/user/repo.git';

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['remote', 'add', remoteName.value, url],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.addRemote(
          path: testPath,
          name: remoteName,
          url: url,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should add remote and fetch when specified', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');
        const url = 'https://github.com/user/repo.git';

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['remote', 'add', remoteName.value, url],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['fetch', '--prune', '--tags', remoteName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.addRemote(
          path: testPath,
          name: remoteName,
          url: url,
          fetch: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['fetch', '--prune', '--tags', remoteName.value],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should remove remote successfully', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['remote', 'remove', remoteName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.removeRemote(
          path: testPath,
          name: remoteName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should rename remote successfully', () async {
        // Arrange
        final oldName = RemoteName.create('old');
        final newName = RemoteName.create('new');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['remote', 'rename', oldName.value, newName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.renameRemote(
          path: testPath,
          oldName: oldName,
          newName: newName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should push branch successfully', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');
        final branchName = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['push', remoteName.value, branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.push(
          path: testPath,
          remote: remoteName,
          branch: branchName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should push with set-upstream flag', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');
        final branchName = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['push', '-u', remoteName.value, branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.push(
          path: testPath,
          remote: remoteName,
          branch: branchName,
          setUpstream: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should force push when specified', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');
        final branchName = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['push', '--force', remoteName.value, branchName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.push(
          path: testPath,
          remote: remoteName,
          branch: branchName,
          force: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should pull changes successfully', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['pull', remoteName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.pull(
          path: testPath,
          remote: remoteName,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should pull with rebase when specified', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['pull', '--rebase', remoteName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.pull(
          path: testPath,
          remote: remoteName,
          rebase: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should fetch from remote successfully', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['fetch', '--tags', remoteName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.fetch(
          path: testPath,
          remote: remoteName,
          branch: fp.none(),
          prune: false,
          tags: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should fetch with prune when specified', () async {
        // Arrange
        final remoteName = RemoteName.create('origin');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['fetch', '--prune', '--tags', remoteName.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.fetch(
          path: testPath,
          remote: remoteName,
          branch: fp.none(),
          prune: true,
          tags: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should fetch all remotes successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['fetch', '--all', '--tags'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.fetchAll(
          path: testPath,
          prune: false,
          tags: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });
    });

    group('Stash Operations', () {
      test('should stash changes successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'push'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.stash(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should stash with message', () async {
        // Arrange
        const message = 'WIP: feature implementation';

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'push', '-m', message],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.stash(
          path: testPath,
          message: message,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should stash with untracked files', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'push', '-u'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.stash(
          path: testPath,
          includeUntracked: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should stash specific files', () async {
        // Arrange
        final files = ['file1.txt', 'file2.txt'];

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'push', '--', ...files],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.stashFiles(
          path: testPath,
          filePaths: files,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should apply stash successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'apply', 'stash@{0}'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.applyStash(
          path: testPath,
          stashIndex: 0,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should pop stash successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'pop', 'stash@{0}'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.applyStash(
          path: testPath,
          stashIndex: 0,
          pop: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should drop stash successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'drop', 'stash@{2}'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.dropStash(
          path: testPath,
          stashIndex: 2,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should clear all stashes successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['stash', 'clear'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.clearStashes(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
      });
    });

    group('Conflict Resolution', () {
      test('should accept incoming changes for conflict', () async {
        // Arrange
        const filePath = 'conflict.txt';

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', '--theirs', filePath],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', filePath],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.acceptIncoming(
          path: testPath,
          filePath: filePath,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', '--theirs', filePath],
              workingDirectory: testPath.path,
            )).called(1);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', filePath],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should accept current changes for conflict', () async {
        // Arrange
        const filePath = 'conflict.txt';

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', '--ours', filePath],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', filePath],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.acceptCurrent(
          path: testPath,
          filePath: filePath,
        );

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['checkout', '--ours', filePath],
              workingDirectory: testPath.path,
            )).called(1);
      });

      test('should mark file as resolved', () async {
        // Arrange
        const filePath = 'resolved.txt';

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['add', filePath],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.markResolved(
          path: testPath,
          filePath: filePath,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should accept both sides not be implemented', () async {
        // Act
        final result = await repository.acceptBoth(
          path: testPath,
          filePath: 'conflict.txt',
        );

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = (result as Left<GitFailure, Unit>).value;
        expect(failure.maybeWhen(
          unknown: (message, _, __) => message.contains('not yet implemented'),
          orElse: () => false,
        ), isTrue);
      });
    });

    group('Rebase Operations', () {
      test('should rebase onto branch successfully', () async {
        // Arrange
        final onto = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['rebase', onto.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.rebase(
          path: testPath,
          onto: onto,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should interactive rebase when specified', () async {
        // Arrange
        final onto = BranchName.create('main');

        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['rebase', '-i', onto.value],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.rebase(
          path: testPath,
          onto: onto,
          interactive: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should continue rebase successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['rebase', '--continue'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.rebaseContinue(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should skip rebase step successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['rebase', '--skip'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.rebaseSkip(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should abort rebase successfully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: ['rebase', '--abort'],
              workingDirectory: testPath.path,
            )).thenAnswer((_) async => right(unit));

        // Act
        final result = await repository.rebaseAbort(path: testPath);

        // Assert
        expect(result.isRight(), isTrue);
      });
    });

    group('Error Handling', () {
      test('should return failure when staging files fails', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: any(named: 'args'),
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer(
          (_) async => left(GitFailure.unknown(message: 'Command failed')),
        );

        // Act
        final result = await repository.stageFiles(
          path: testPath,
          filePaths: ['file.txt'],
        );

        // Assert
        expect(result.isLeft(), isTrue);
      });

      test('should return failure when repository does not exist', () async {
        // Arrange
        when(() => testPath.exists()).thenAnswer((_) async => false);

        // Act
        final result = await repository.open(path: testPath);

        // Assert
        expect(result.isLeft(), isTrue);
        expect((result as Left).value, isA<GitFailure>());
      });

      test('should handle command adapter errors gracefully', () async {
        // Arrange
        when(() => mockCommandAdapter.executeAndCheckSuccess(
              args: any(named: 'args'),
              workingDirectory: any(named: 'workingDirectory'),
            )).thenAnswer(
          (_) async => left(GitFailure.commandFailed(
            command: 'git add',
            exitCode: 1,
            stderr: 'Error message',
          )),
        );

        // Act
        final result = await repository.stageAll(path: testPath);

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });
  });
}
