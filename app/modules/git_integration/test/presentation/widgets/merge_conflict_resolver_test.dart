import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:git_integration/git_integration.dart';
import 'package:get_it/get_it.dart';
import 'package:fpdart/fpdart.dart';

// Mock classes
class MockResolveConflictUseCase extends Mock implements ResolveConflictUseCase {}

void main() {
  late MockResolveConflictUseCase mockResolveConflictUseCase;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(RepositoryPath.create('/test/repo'));
    registerFallbackValue(ConflictResolutionStrategy.manual);
  });

  setUp(() {
    mockResolveConflictUseCase = MockResolveConflictUseCase();

    getIt = GetIt.instance;
    if (!getIt.isRegistered<ResolveConflictUseCase>()) {
      getIt.registerSingleton<ResolveConflictUseCase>(
        mockResolveConflictUseCase,
      );
    }
  });

  tearDown(() async {
    await getIt.reset();
  });

  ConflictedFile createConflictedFile({
    String filePath = 'lib/test.dart',
    String ourContent = 'our version',
    String theirContent = 'their version',
    String baseContent = 'base version',
    bool isResolved = false,
  }) {
    return ConflictedFile(
      filePath: filePath,
      ourContent: ourContent,
      theirContent: theirContent,
      baseContent: baseContent,
      markers: const [],
      isResolved: isResolved,
      resolvedContent: none(),
    );
  }

  Widget createTestWidget({
    required ConflictedFile conflictedFile,
    VoidCallback? onResolved,
    VoidCallback? onCancel,
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: MergeConflictResolver(
          repositoryPath: '/test/repo',
          conflictedFile: conflictedFile,
          onResolved: onResolved,
          onCancel: onCancel,
        ),
      ),
    );
  }

  group('MergeConflictResolver - Widget Rendering', () {
    testWidgets('should render without crashing', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MergeConflictResolver), findsOneWidget);
    });

    testWidgets('should show file name in app bar', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile(
        filePath: 'lib/src/feature.dart',
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Resolve Conflict: feature.dart'), findsOneWidget);
    });

    testWidgets('should show conflict count', (tester) async {
      // Arrange
      final conflictedFile = ConflictedFile(
        filePath: 'test.dart',
        ourContent: 'our',
        theirContent: 'their',
        baseContent: 'base',
        markers: const [
          ConflictMarker(startLine: 1, middleLine: 2, endLine: 3),
        ],
        isResolved: false,
        resolvedContent: none(),
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('1 conflict(s) found'), findsOneWidget);
    });
  });

  group('MergeConflictResolver - Resolution Strategies', () {
    testWidgets('should display all resolution strategies', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Keep Current (Ours)'), findsOneWidget);
      expect(find.text('Accept Incoming (Theirs)'), findsOneWidget);
      expect(find.text('Accept Both'), findsOneWidget);
      expect(find.text('Manual Edit'), findsOneWidget);
    });

    testWidgets('should select strategy on chip tap', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Keep Current (Ours)'));
      await tester.pumpAndSettle();

      // Assert - Widget should still render
      expect(find.byType(MergeConflictResolver), findsOneWidget);
    });

    testWidgets('should show manual editor when manual strategy selected',
        (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Manual Edit'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Manual Resolution'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show three-way merge view for other strategies',
        (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Keep Current (Ours)'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Current (Ours)'), findsOneWidget);
      expect(find.text('Base (Common Ancestor)'), findsOneWidget);
      expect(find.text('Incoming (Theirs)'), findsOneWidget);
    });
  });

  group('MergeConflictResolver - Three-Way Merge View', () {
    testWidgets('should display all three versions', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile(
        ourContent: 'our code',
        theirContent: 'their code',
        baseContent: 'base code',
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Select non-manual strategy to show three-way view
      await tester.tap(find.text('Accept Both'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('our code'), findsOneWidget);
      expect(find.text('their code'), findsOneWidget);
      expect(find.text('base code'), findsOneWidget);
    });

    testWidgets('should show syntax highlighting', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile(
        filePath: 'lib/test.dart',
        ourContent: 'void main() {}',
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Select strategy to show three-way view
      await tester.tap(find.text('Keep Current (Ours)'));
      await tester.pumpAndSettle();

      // Assert - Should render code
      expect(find.text('void main() {}'), findsOneWidget);
    });
  });

  group('MergeConflictResolver - Manual Editor', () {
    testWidgets('should allow editing in manual mode', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Switch to manual edit
      await tester.tap(find.text('Manual Edit'));
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(
        find.byType(TextField),
        'manually resolved content',
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('manually resolved content'), findsOneWidget);
    });

    testWidgets('should show copy button in manual editor', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Manual Edit'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.widgetWithIcon(IconButton, Icons.copy), findsOneWidget);
    });

    testWidgets('should copy content on copy button tap', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Manual Edit'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(IconButton, Icons.copy));
      await tester.pumpAndSettle();

      // Assert - Should show snackbar
      expect(find.text('Content copied to clipboard'), findsOneWidget);
    });
  });

  group('MergeConflictResolver - Preview', () {
    testWidgets('should show preview panel', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Preview'), findsOneWidget);
    });

    testWidgets('should update preview when strategy changes', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile(
        ourContent: 'ours',
        theirContent: 'theirs',
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Switch to "Accept Incoming"
      await tester.tap(find.text('Accept Incoming (Theirs)'));
      await tester.pumpAndSettle();

      // Assert - Preview should show their content
      expect(find.text('theirs'), findsWidgets);
    });
  });

  group('MergeConflictResolver - Resolution', () {
    testWidgets('should resolve conflict on button tap', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();
      bool resolved = false;

      when(() => mockResolveConflictUseCase.resolveWithStrategy(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            strategy: any(named: 'strategy'),
          )).thenAnswer((_) async => right(unit));

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
        onResolved: () => resolved = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resolve Conflict'));
      await tester.pumpAndSettle();

      // Assert
      expect(resolved, isTrue);
    });

    testWidgets('should show loading state while resolving', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      when(() => mockResolveConflictUseCase.resolveWithStrategy(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            strategy: any(named: 'strategy'),
          )).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return right(unit);
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resolve Conflict'));
      await tester.pump();

      // Assert - Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Resolving...'), findsOneWidget);
    });

    testWidgets('should show error on resolution failure', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();

      when(() => mockResolveConflictUseCase.resolveWithStrategy(
            path: any(named: 'path'),
            filePath: any(named: 'filePath'),
            strategy: any(named: 'strategy'),
          )).thenAnswer(
        (_) async => left(GitFailure.operationFailed(
          operation: 'resolve',
          reason: 'Test error',
        )),
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resolve Conflict'));
      await tester.pumpAndSettle();

      // Assert - Should show error
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('should call onCancel when cancel button tapped',
        (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile();
      bool cancelled = false;

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
        onCancel: () => cancelled = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert
      expect(cancelled, isTrue);
    });
  });

  group('MergeConflictsList', () {
    Widget createConflictsListWidget({
      required List<ConflictedFile> conflicts,
      Function(ConflictedFile)? onResolveConflict,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: MergeConflictsList(
              repositoryPath: '/test/repo',
              conflicts: conflicts,
              onResolveConflict: onResolveConflict ?? (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets('should render conflicts list', (tester) async {
      // Arrange
      final conflicts = [
        createConflictedFile(filePath: 'file1.dart'),
        createConflictedFile(filePath: 'file2.dart'),
      ];

      // Act
      await tester.pumpWidget(createConflictsListWidget(conflicts: conflicts));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('file1.dart'), findsOneWidget);
      expect(find.text('file2.dart'), findsOneWidget);
    });

    testWidgets('should show progress header', (tester) async {
      // Arrange
      final conflicts = [
        createConflictedFile(isResolved: true),
        createConflictedFile(isResolved: false),
        createConflictedFile(isResolved: false),
      ];

      // Act
      await tester.pumpWidget(createConflictsListWidget(conflicts: conflicts));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Merge Conflicts (1/3 resolved)'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty state when no conflicts', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createConflictsListWidget(conflicts: []));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No Conflicts'), findsOneWidget);
      expect(find.text('All merge conflicts have been resolved'),
          findsOneWidget);
    });

    testWidgets('should call onResolveConflict when resolve button tapped',
        (tester) async {
      // Arrange
      final conflicts = [createConflictedFile()];
      ConflictedFile? tappedConflict;

      // Act
      await tester.pumpWidget(createConflictsListWidget(
        conflicts: conflicts,
        onResolveConflict: (conflict) => tappedConflict = conflict,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resolve'));
      await tester.pumpAndSettle();

      // Assert
      expect(tappedConflict, isNotNull);
    });

    testWidgets('should show resolved indicator for resolved conflicts',
        (tester) async {
      // Arrange
      final conflicts = [
        createConflictedFile(isResolved: true),
      ];

      // Act
      await tester.pumpWidget(createConflictsListWidget(conflicts: conflicts));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('- Resolved'), findsOneWidget);
    });

    testWidgets('should show error indicator for unresolved conflicts',
        (tester) async {
      // Arrange
      final conflicts = [
        createConflictedFile(isResolved: false),
      ];

      // Act
      await tester.pumpWidget(createConflictsListWidget(conflicts: conflicts));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('MergeConflictResolver - Edge Cases', () {
    testWidgets('should handle very long content', (tester) async {
      // Arrange
      final longContent = 'a' * 10000;
      final conflictedFile = createConflictedFile(
        ourContent: longContent,
        theirContent: longContent,
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert - Should render without error
      expect(find.byType(MergeConflictResolver), findsOneWidget);
    });

    testWidgets('should handle special characters in content', (tester) async {
      // Arrange
      final conflictedFile = createConflictedFile(
        ourContent: 'content with <special> & "characters"',
        theirContent: 'content with \$symbols \${variables}',
      );

      // Act
      await tester.pumpWidget(createTestWidget(
        conflictedFile: conflictedFile,
      ));
      await tester.pumpAndSettle();

      // Assert - Should render without error
      expect(find.byType(MergeConflictResolver), findsOneWidget);
    });
  });
}
