import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockBlameService extends Mock implements BlameService {}

void main() {
  late MockBlameService mockBlameService;
  late ProviderContainer container;

  setUp(() {
    mockBlameService = MockBlameService();

    container = ProviderContainer(
      overrides: [
        blameServiceProvider.overrideWithValue(mockBlameService),
        currentRepositoryPathProvider
            .overrideWith((ref) => RepositoryPath.create('/test/repo')),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  BlameLine createBlameLine({
    int lineNumber = 1,
    String authorName = 'John Doe',
  }) {
    return BlameLine(
      lineNumber: lineNumber,
      commit: GitCommit(
        hash: GitHash.create('abc123'),
        author: GitAuthor.create(name: authorName, email: 'john@example.com'),
        committer: GitAuthor.create(name: authorName, email: 'john@example.com'),
        authorDate: DateTime.now(),
        commitDate: DateTime.now(),
        message: GitCommitMessage.create('test commit'),
        parentHash: none(),
        tags: const [],
        isMergeCommit: false,
        changedFiles: const [],
        insertions: 0,
        deletions: 0,
      ),
    );
  }

  group('BlameNotifier - Initial State', () {
    test('should have empty initial state', () {
      // Arrange & Act
      final state = container.read(blameNotifierProvider);

      // Assert
      expect(state.blameLines, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.hasBlame, isFalse);
    });
  });

  group('BlameNotifier - loadBlame', () {
    test('should load blame successfully', () async {
      // Arrange
      final blameLines = [
        createBlameLine(lineNumber: 1),
        createBlameLine(lineNumber: 2),
      ];

      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right(blameLines));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({'John Doe': 100.0}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([1, 2]));

      final notifier = container.read(blameNotifierProvider.notifier);

      // Act
      await notifier.loadBlame(filePath: 'test.dart');

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.blameLines, equals(blameLines));
      expect(state.isLoading, isFalse);
      expect(state.hasBlame, isTrue);
      expect(state.filePath, equals('test.dart'));
    });

    test('should set loading state while loading', () async {
      // Arrange
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return right([]);
        },
      );

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      final notifier = container.read(blameNotifierProvider.notifier);

      // Act
      final future = notifier.loadBlame(filePath: 'test.dart');

      // Assert - Check loading state immediately
      final loadingState = container.read(blameNotifierProvider);
      expect(loadingState.isLoading, isTrue);

      await future;
    });

    test('should handle load failure', () async {
      // Arrange
      final failure = GitFailure.notFound(path: 'test.dart');

      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => left(failure));

      final notifier = container.read(blameNotifierProvider.notifier);

      // Act
      await notifier.loadBlame(filePath: 'test.dart');

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.error, equals(failure));
      expect(state.isLoading, isFalse);
      expect(state.hasError, isTrue);
    });

    test('should load author contribution', () async {
      // Arrange
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({
                'Alice': 60.5,
                'Bob': 39.5,
              }));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      final notifier = container.read(blameNotifierProvider.notifier);

      // Act
      await notifier.loadBlame(filePath: 'test.dart');

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.authorContribution, isNotNull);
      expect(state.authorContribution!['Alice'], equals(61)); // Rounded
      expect(state.authorContribution!['Bob'], equals(40)); // Rounded
    });

    test('should load heat map', () async {
      // Arrange
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([1, 5, 10, 30, 100]));

      final notifier = container.read(blameNotifierProvider.notifier);

      // Act
      await notifier.loadBlame(filePath: 'test.dart');

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.heatMap, equals([1, 5, 10, 30, 100]));
      expect(state.hasHeatMap, isTrue);
    });
  });

  group('BlameNotifier - selectLine', () {
    test('should select line and load tooltip', () async {
      // Arrange
      final tooltip = const BlameTooltip(
        commitHash: 'abc123',
        author: 'John Doe',
        date: const_date,
        message: 'Test commit',
        lineNumber: 1,
      );

      when(() => mockBlameService.getLineTooltip(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            lineNumber: any(named: 'lineNumber'),
          )).thenAnswer((_) async => right(tooltip));

      // Load blame first
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      final notifier = container.read(blameNotifierProvider.notifier);
      await notifier.loadBlame(filePath: 'test.dart');

      // Act
      await notifier.selectLine(1);

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.selectedLineNumber, equals(1));
      expect(state.tooltip, equals(tooltip));
      expect(state.hasSelection, isTrue);
      expect(state.hasTooltip, isTrue);
    });

    test('should handle tooltip load failure gracefully', () async {
      // Arrange
      when(() => mockBlameService.getLineTooltip(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            lineNumber: any(named: 'lineNumber'),
          )).thenAnswer(
        (_) async => left(GitFailure.operationFailed(
          operation: 'tooltip',
          reason: 'test',
        )),
      );

      // Load blame first
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      final notifier = container.read(blameNotifierProvider.notifier);
      await notifier.loadBlame(filePath: 'test.dart');

      // Act
      await notifier.selectLine(1);

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.selectedLineNumber, equals(1));
      expect(state.tooltip, isNull); // Tooltip not loaded
      expect(state.hasSelection, isTrue);
      expect(state.hasTooltip, isFalse);
    });
  });

  group('BlameNotifier - clearSelection', () {
    test('should clear selection and tooltip', () async {
      // Arrange
      // Load blame and select line first
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      when(() => mockBlameService.getLineTooltip(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            lineNumber: any(named: 'lineNumber'),
          )).thenAnswer(
        (_) async => right(const BlameTooltip(
          commitHash: 'abc',
          author: 'John',
          date: const_date,
          message: 'test',
          lineNumber: 1,
        )),
      );

      final notifier = container.read(blameNotifierProvider.notifier);
      await notifier.loadBlame(filePath: 'test.dart');
      await notifier.selectLine(1);

      // Act
      notifier.clearSelection();

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.selectedLineNumber, isNull);
      expect(state.tooltip, isNull);
      expect(state.hasSelection, isFalse);
      expect(state.hasTooltip, isFalse);
    });
  });

  group('BlameNotifier - clear', () {
    test('should clear all state', () async {
      // Arrange
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({}));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      final notifier = container.read(blameNotifierProvider.notifier);
      await notifier.loadBlame(filePath: 'test.dart');

      // Act
      notifier.clear();

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.blameLines, isEmpty);
      expect(state.filePath, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });
  });

  group('BlameNotifier - clearError', () {
    test('should clear error', () async {
      // Arrange
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer(
        (_) async => left(GitFailure.notFound(path: 'test.dart')),
      );

      final notifier = container.read(blameNotifierProvider.notifier);
      await notifier.loadBlame(filePath: 'test.dart');

      // Act
      notifier.clearError();

      // Assert
      final state = container.read(blameNotifierProvider);
      expect(state.error, isNull);
      expect(state.hasError, isFalse);
    });
  });

  group('authorContributionChart provider', () {
    test('should return empty list when no contribution data', () {
      // Arrange & Act
      final chart = container.read(authorContributionChartProvider);

      // Assert
      expect(chart, isEmpty);
    });

    test('should return sorted contribution list', () async {
      // Arrange
      when(() => mockBlameService.getBlame(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            startLine: any(named: 'startLine'),
            endLine: any(named: 'endLine'),
          )).thenAnswer((_) async => right([createBlameLine()]));

      when(() => mockBlameService.getAuthorContribution(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right({
                'Alice': 60.0,
                'Bob': 30.0,
                'Charlie': 10.0,
              }));

      when(() => mockBlameService.getBlameHeatMap(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
          )).thenAnswer((_) async => right([]));

      final notifier = container.read(blameNotifierProvider.notifier);
      await notifier.loadBlame(filePath: 'test.dart');

      // Act
      final chart = container.read(authorContributionChartProvider);

      // Assert
      expect(chart.length, equals(3));
      expect(chart[0].author, equals('Alice'));
      expect(chart[0].percentage, equals(60));
      expect(chart[1].author, equals('Bob'));
      expect(chart[1].percentage, equals(30));
      expect(chart[2].author, equals('Charlie'));
      expect(chart[2].percentage, equals(10));
    });
  });
}

final const_date = DateTime(2024, 1, 1);
