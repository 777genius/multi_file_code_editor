import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockDiffService extends Mock implements DiffService {}

void main() {
  late MockDiffService mockDiffService;
  late ProviderContainer container;

  setUp(() {
    mockDiffService = MockDiffService();

    container = ProviderContainer(
      overrides: [
        diffServiceProvider.overrideWithValue(mockDiffService),
        currentRepositoryPathProvider
            .overrideWith((ref) => RepositoryPath.create('/test/repo')),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  DiffHunk createDiffHunk() {
    return DiffHunk(
      header: '@@ -1,3 +1,3 @@',
      lines: [
        DiffLine(
          type: DiffLineType.context,
          content: 'context',
          oldLineNumber: some(1),
          newLineNumber: some(1),
        ),
        DiffLine(
          type: DiffLineType.removed,
          content: 'removed',
          oldLineNumber: some(2),
          newLineNumber: none(),
        ),
        DiffLine(
          type: DiffLineType.added,
          content: 'added',
          oldLineNumber: none(),
          newLineNumber: some(2),
        ),
      ],
    );
  }

  group('DiffNotifier - Initial State', () {
    test('should have empty initial state', () {
      // Arrange & Act
      final state = container.read(diffNotifierProvider);

      // Assert
      expect(state.fileDiffs, isEmpty);
      expect(state.selectedFile, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.viewMode, equals(DiffViewMode.sideBySide));
      expect(state.hasFiles, isFalse);
    });
  });

  group('DiffNotifier - loadStagedDiff', () {
    test('should load staged diff successfully', () async {
      // Arrange
      final fileDiffs = {
        'file1.dart': [createDiffHunk()],
        'file2.dart': [createDiffHunk()],
      };

      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right(fileDiffs));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadStagedDiff();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.fileDiffs, equals(fileDiffs));
      expect(state.isLoading, isFalse);
      expect(state.hasFiles, isTrue);
      expect(state.selectedFile, equals('file1.dart')); // Auto-selected
    });

    test('should set loading state while loading', () async {
      // Arrange
      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return right({});
        },
      );

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      final future = notifier.loadStagedDiff();

      // Assert - Check loading state immediately
      final loadingState = container.read(diffNotifierProvider);
      expect(loadingState.isLoading, isTrue);

      await future;
    });

    test('should handle load failure', () async {
      // Arrange
      final failure = GitFailure.operationFailed(
        operation: 'diff',
        reason: 'test error',
      );

      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => left(failure));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadStagedDiff();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.error, equals(failure));
      expect(state.isLoading, isFalse);
      expect(state.hasError, isTrue);
    });
  });

  group('DiffNotifier - loadUnstagedDiff', () {
    test('should load unstaged diff successfully', () async {
      // Arrange
      final fileDiffs = {
        'file1.dart': [createDiffHunk()],
      };

      when(() => mockDiffService.getUnstagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right(fileDiffs));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadUnstagedDiff();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.fileDiffs, equals(fileDiffs));
      expect(state.isLoading, isFalse);
      expect(state.hasFiles, isTrue);
    });

    test('should handle load failure', () async {
      // Arrange
      final failure = GitFailure.notFound(path: '/test/repo');

      when(() => mockDiffService.getUnstagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => left(failure));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadUnstagedDiff();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.error, equals(failure));
      expect(state.hasError, isTrue);
    });
  });

  group('DiffNotifier - loadFileDiff', () {
    test('should load file diff successfully', () async {
      // Arrange
      final hunks = [createDiffHunk()];

      when(() => mockDiffService.getFileDiff(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            staged: any(named: 'staged'),
          )).thenAnswer((_) async => right(hunks));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadFileDiff(filePath: 'test.dart', staged: false);

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.fileDiffs['test.dart'], equals(hunks));
      expect(state.selectedFile, equals('test.dart'));
      expect(state.isLoading, isFalse);
    });

    test('should handle staged parameter', () async {
      // Arrange
      final hunks = [createDiffHunk()];

      when(() => mockDiffService.getFileDiff(
            path: any(named: 'path'),
            filePath: 'test.dart',
            staged: true,
          )).thenAnswer((_) async => right(hunks));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadFileDiff(filePath: 'test.dart', staged: true);

      // Assert
      verify(() => mockDiffService.getFileDiff(
            path: any(named: 'path'),
            filePath: 'test.dart',
            staged: true,
          )).called(1);
    });

    test('should update existing file diffs', () async {
      // Arrange
      final initialHunks = [createDiffHunk()];
      final updatedHunks = [createDiffHunk(), createDiffHunk()];

      when(() => mockDiffService.getFileDiff(
            path: any(named: 'path'),
            filePath: 'test.dart',
            staged: any(named: 'staged'),
          )).thenAnswer((_) async => right(initialHunks));

      final notifier = container.read(diffNotifierProvider.notifier);
      await notifier.loadFileDiff(filePath: 'test.dart');

      when(() => mockDiffService.getFileDiff(
            path: any(named: 'path'),
            filePath: 'test.dart',
            staged: any(named: 'staged'),
          )).thenAnswer((_) async => right(updatedHunks));

      // Act
      await notifier.loadFileDiff(filePath: 'test.dart');

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.fileDiffs['test.dart'], equals(updatedHunks));
    });
  });

  group('DiffNotifier - loadCommitDiff', () {
    test('should load commit diff successfully', () async {
      // Arrange
      final fileDiffs = {
        'file1.dart': [createDiffHunk()],
        'file2.dart': [createDiffHunk()],
      };

      when(() => mockDiffService.getDiffBetweenCommits(
            path: any(named: 'path'),
            oldCommit: any(named: 'oldCommit'),
            newCommit: any(named: 'newCommit'),
          )).thenAnswer((_) async => right(fileDiffs));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadCommitDiff(
        oldCommit: 'abc123',
        newCommit: 'def456',
      );

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.fileDiffs, equals(fileDiffs));
      expect(state.selectedFile, equals('file1.dart'));
    });

    test('should pass commit hashes correctly', () async {
      // Arrange
      when(() => mockDiffService.getDiffBetweenCommits(
            path: any(named: 'path'),
            oldCommit: 'commit1',
            newCommit: 'commit2',
          )).thenAnswer((_) async => right({}));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadCommitDiff(
        oldCommit: 'commit1',
        newCommit: 'commit2',
      );

      // Assert
      verify(() => mockDiffService.getDiffBetweenCommits(
            path: any(named: 'path'),
            oldCommit: 'commit1',
            newCommit: 'commit2',
          )).called(1);
    });
  });

  group('DiffNotifier - selectFile', () {
    test('should select file', () {
      // Arrange
      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      notifier.selectFile('test.dart');

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.selectedFile, equals('test.dart'));
    });

    test('should update selected diff', () async {
      // Arrange
      final fileDiffs = {
        'file1.dart': [createDiffHunk()],
        'file2.dart': [createDiffHunk(), createDiffHunk()],
      };

      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right(fileDiffs));

      final notifier = container.read(diffNotifierProvider.notifier);
      await notifier.loadStagedDiff();

      // Act
      notifier.selectFile('file2.dart');

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.selectedDiff, equals(fileDiffs['file2.dart']));
    });
  });

  group('DiffNotifier - setViewMode', () {
    test('should set view mode to side by side', () {
      // Arrange
      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      notifier.setViewMode(DiffViewMode.sideBySide);

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.viewMode, equals(DiffViewMode.sideBySide));
    });

    test('should set view mode to unified', () {
      // Arrange
      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      notifier.setViewMode(DiffViewMode.unified);

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.viewMode, equals(DiffViewMode.unified));
    });
  });

  group('DiffNotifier - toggleContext', () {
    test('should toggle context visibility', () {
      // Arrange
      final notifier = container.read(diffNotifierProvider.notifier);
      final initialState = container.read(diffNotifierProvider);

      // Act
      notifier.toggleContext();

      // Assert
      final newState = container.read(diffNotifierProvider);
      expect(newState.showContext, equals(!initialState.showContext));
    });
  });

  group('DiffNotifier - setContextLines', () {
    test('should set context lines count', () {
      // Arrange
      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      notifier.setContextLines(5);

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.contextLines, equals(5));
    });
  });

  group('DiffNotifier - clear', () {
    test('should clear all state', () async {
      // Arrange
      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right({'test.dart': [createDiffHunk()]}));

      final notifier = container.read(diffNotifierProvider.notifier);
      await notifier.loadStagedDiff();

      // Act
      notifier.clear();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.fileDiffs, isEmpty);
      expect(state.selectedFile, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });
  });

  group('DiffNotifier - clearError', () {
    test('should clear error', () async {
      // Arrange
      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer(
        (_) async => left(GitFailure.operationFailed(
          operation: 'diff',
          reason: 'test',
        )),
      );

      final notifier = container.read(diffNotifierProvider.notifier);
      await notifier.loadStagedDiff();

      // Act
      notifier.clearError();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.error, isNull);
      expect(state.hasError, isFalse);
    });
  });

  group('DiffState - Statistics', () {
    test('should calculate total files', () {
      // Arrange
      final state = DiffState(
        fileDiffs: {
          'file1.dart': [createDiffHunk()],
          'file2.dart': [createDiffHunk()],
          'file3.dart': [createDiffHunk()],
        },
      );

      // Act & Assert
      expect(state.totalFiles, equals(3));
    });

    test('should calculate total additions', () {
      // Arrange
      final hunks = [
        DiffHunk(
          header: '@@ -1,1 +1,2 @@',
          lines: [
            DiffLine(
              type: DiffLineType.added,
              content: 'added1',
              oldLineNumber: none(),
              newLineNumber: some(1),
            ),
            DiffLine(
              type: DiffLineType.added,
              content: 'added2',
              oldLineNumber: none(),
              newLineNumber: some(2),
            ),
          ],
        ),
      ];

      final state = DiffState(
        fileDiffs: {'test.dart': hunks},
      );

      // Act & Assert
      expect(state.totalAdditions, equals(2));
    });

    test('should calculate total deletions', () {
      // Arrange
      final hunks = [
        DiffHunk(
          header: '@@ -1,2 +1,1 @@',
          lines: [
            DiffLine(
              type: DiffLineType.removed,
              content: 'removed1',
              oldLineNumber: some(1),
              newLineNumber: none(),
            ),
            DiffLine(
              type: DiffLineType.removed,
              content: 'removed2',
              oldLineNumber: some(2),
              newLineNumber: none(),
            ),
            DiffLine(
              type: DiffLineType.removed,
              content: 'removed3',
              oldLineNumber: some(3),
              newLineNumber: none(),
            ),
          ],
        ),
      ];

      final state = DiffState(
        fileDiffs: {'test.dart': hunks},
      );

      // Act & Assert
      expect(state.totalDeletions, equals(3));
    });

    test('should calculate total changes', () {
      // Arrange
      final hunks = [
        DiffHunk(
          header: '@@ -1,2 +1,3 @@',
          lines: [
            DiffLine(
              type: DiffLineType.added,
              content: 'added',
              oldLineNumber: none(),
              newLineNumber: some(1),
            ),
            DiffLine(
              type: DiffLineType.removed,
              content: 'removed',
              oldLineNumber: some(1),
              newLineNumber: none(),
            ),
          ],
        ),
      ];

      final state = DiffState(
        fileDiffs: {'test.dart': hunks},
      );

      // Act & Assert
      expect(state.totalChanges, equals(2)); // 1 addition + 1 deletion
    });
  });

  group('diffStatistics provider', () {
    test('should return null when no selected diff', () {
      // Arrange & Act
      final stats = container.read(diffStatisticsProvider);

      // Assert
      expect(stats, isNull);
    });

    test('should calculate statistics for selected diff', () async {
      // Arrange
      final hunks = [createDiffHunk()];

      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right({'test.dart': hunks}));

      when(() => mockDiffService.calculateStatistics(hunks))
          .thenReturn(const DiffStatistics(
        additions: 10,
        deletions: 5,
        changes: 15,
      ));

      final notifier = container.read(diffNotifierProvider.notifier);
      await notifier.loadStagedDiff();

      // Act
      final stats = container.read(diffStatisticsProvider);

      // Assert
      expect(stats, isNotNull);
      expect(stats!.additions, equals(10));
      expect(stats.deletions, equals(5));
      expect(stats.changes, equals(15));
    });
  });

  group('DiffNotifier - Edge Cases', () {
    test('should handle empty file diffs', () async {
      // Arrange
      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right({}));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadStagedDiff();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.hasFiles, isFalse);
      expect(state.selectedFile, isNull);
    });

    test('should handle multiple files', () async {
      // Arrange
      final fileDiffs = {
        'file1.dart': [createDiffHunk()],
        'file2.dart': [createDiffHunk()],
        'file3.dart': [createDiffHunk()],
        'file4.dart': [createDiffHunk()],
        'file5.dart': [createDiffHunk()],
      };

      when(() => mockDiffService.getStagedDiff(
            path: any(named: 'path'),
          )).thenAnswer((_) async => right(fileDiffs));

      final notifier = container.read(diffNotifierProvider.notifier);

      // Act
      await notifier.loadStagedDiff();

      // Assert
      final state = container.read(diffNotifierProvider);
      expect(state.totalFiles, equals(5));
    });
  });
}
