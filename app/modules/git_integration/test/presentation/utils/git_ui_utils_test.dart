import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_integration/src/presentation/utils/git_ui_utils.dart';

void main() {
  group('GitUIUtils', () {
    group('Author Color Generation', () {
      test('should generate consistent color for same author', () {
        // Arrange
        const author = 'John Doe';

        // Act
        final color1 = GitUIUtils.getAuthorColor(author);
        final color2 = GitUIUtils.getAuthorColor(author);

        // Assert
        expect(color1, equals(color2));
      });

      test('should generate different colors for different authors', () {
        // Arrange
        const author1 = 'John Doe';
        const author2 = 'Jane Smith';

        // Act
        final color1 = GitUIUtils.getAuthorColor(author1);
        final color2 = GitUIUtils.getAuthorColor(author2);

        // Assert
        expect(color1, isNot(equals(color2)));
      });

      test('should generate color within HSL constraints', () {
        // Arrange
        const author = 'Test Author';

        // Act
        final color = GitUIUtils.getAuthorColor(author);
        final hslColor = HSLColor.fromColor(color);

        // Assert
        expect(hslColor.hue, greaterThanOrEqualTo(0));
        expect(hslColor.hue, lessThan(360));
        expect(hslColor.saturation, equals(0.6));
        expect(hslColor.lightness, equals(0.5));
      });

      test('should handle empty author name', () {
        // Arrange
        const author = '';

        // Act
        final color = GitUIUtils.getAuthorColor(author);

        // Assert
        expect(color, isA<Color>());
      });

      test('should handle special characters in author name', () {
        // Arrange
        const author = 'Author @#\$%^&*()';

        // Act
        final color = GitUIUtils.getAuthorColor(author);

        // Assert
        expect(color, isA<Color>());
      });

      test('should generate deterministic colors based on hash', () {
        // Arrange
        const author = 'Consistent Author';

        // Act
        final colors = List.generate(10, (_) => GitUIUtils.getAuthorColor(author));

        // Assert
        final firstColor = colors.first;
        for (final color in colors) {
          expect(color, equals(firstColor));
        }
      });

      test('should distribute colors across hue spectrum', () {
        // Arrange
        final authors = List.generate(100, (i) => 'Author$i');

        // Act
        final colors = authors.map((a) => GitUIUtils.getAuthorColor(a)).toList();
        final hues = colors.map((c) => HSLColor.fromColor(c).hue).toSet();

        // Assert - Should have good distribution
        expect(hues.length, greaterThan(50)); // At least 50% unique hues
      });
    });

    group('Author Initials', () {
      test('should return first letter for single name', () {
        // Arrange
        const name = 'Alice';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('A'));
      });

      test('should return first and last initials for full name', () {
        // Arrange
        const name = 'John Doe';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('JD'));
      });

      test('should return first and last initials for name with middle', () {
        // Arrange
        const name = 'Bob Smith Jones';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('BJ'));
      });

      test('should handle multiple spaces between names', () {
        // Arrange
        const name = 'First    Last';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('FL'));
      });

      test('should handle leading and trailing spaces', () {
        // Arrange
        const name = '  John Doe  ';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('JD'));
      });

      test('should return question mark for empty name', () {
        // Arrange
        const name = '';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('?'));
      });

      test('should return question mark for whitespace-only name', () {
        // Arrange
        const name = '   ';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('?'));
      });

      test('should convert initials to uppercase', () {
        // Arrange
        const name = 'john doe';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('JD'));
      });

      test('should handle names with hyphens', () {
        // Arrange
        const name = 'Mary-Jane Watson';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('MW'));
      });

      test('should handle names with special characters', () {
        // Arrange
        const name = "O'Brien MacDonald";

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('OM'));
      });

      test('should handle unicode names', () {
        // Arrange
        const name = '张伟 李娜';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials.length, equals(2));
      });

      test('should handle names with numbers', () {
        // Arrange
        const name = 'User123 Test456';

        // Act
        final initials = GitUIUtils.getAuthorInitials(name);

        // Assert
        expect(initials, equals('UT'));
      });
    });

    group('Theme-aware Colors', () {
      testWidgets('should return light green for dark theme additions', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                // Act
                final color = GitUIUtils.getAdditionColor(context);

                // Assert
                expect(color, equals(const Color(0xFF8FD9A8)));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return dark green for light theme additions', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Builder(
              builder: (context) {
                // Act
                final color = GitUIUtils.getAdditionColor(context);

                // Assert
                expect(color, equals(const Color(0xFF0F6D31)));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return light red for dark theme deletions', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                // Act
                final color = GitUIUtils.getDeletionColor(context);

                // Assert
                expect(color, equals(const Color(0xFFFF8A8A)));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return dark red for light theme deletions', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Builder(
              builder: (context) {
                // Act
                final color = GitUIUtils.getDeletionColor(context);

                // Assert
                expect(color, equals(const Color(0xFFB71C1C)));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return light orange for dark theme warnings', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                // Act
                final color = GitUIUtils.getWarningColor(context);

                // Assert
                expect(color, equals(const Color(0xFFFFA726)));
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return dark orange for light theme warnings', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Builder(
              builder: (context) {
                // Act
                final color = GitUIUtils.getWarningColor(context);

                // Assert
                expect(color, equals(const Color(0xFFE65100)));
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Clipboard Operations', () {
      testWidgets('should handle copy to clipboard', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await GitUIUtils.copyToClipboard(
                        context,
                        'test content',
                      );
                    },
                    child: const Text('Copy'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Assert - Should show snackbar
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });

      testWidgets('should support custom success message', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await GitUIUtils.copyToClipboard(
                        context,
                        'commit hash',
                        successMessage: 'Commit hash copied',
                      );
                    },
                    child: const Text('Copy'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Commit hash copied'), findsOneWidget);
      });

      testWidgets('should handle empty text copy', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await GitUIUtils.copyToClipboard(context, '');
                    },
                    child: const Text('Copy'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Assert - Should still show success
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });

      testWidgets('should handle multiline text copy', (tester) async {
        // Arrange
        const multilineText = '''
Line 1
Line 2
Line 3
''';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await GitUIUtils.copyToClipboard(context, multilineText);
                    },
                    child: const Text('Copy'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });

      testWidgets('should handle special characters in copy', (tester) async {
        // Arrange
        const specialText = 'Text with @#\$%^&*() special chars';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await GitUIUtils.copyToClipboard(context, specialText);
                    },
                    child: const Text('Copy'),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });
    });
  });

  group('Debouncer', () {
    group('Construction', () {
      test('should create debouncer with milliseconds', () {
        // Act
        final debouncer = Debouncer(milliseconds: 300);

        // Assert
        expect(debouncer, isNotNull);
        expect(debouncer.milliseconds, equals(300));
      });

      test('should create debouncer with different durations', () {
        // Act
        final debouncer100 = Debouncer(milliseconds: 100);
        final debouncer500 = Debouncer(milliseconds: 500);

        // Assert
        expect(debouncer100.milliseconds, equals(100));
        expect(debouncer500.milliseconds, equals(500));
      });
    });

    group('Run', () {
      test('should execute action after delay', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);
        var executed = false;

        // Act
        debouncer.run(() {
          executed = true;
        });

        // Wait less than debounce time
        await Future.delayed(const Duration(milliseconds: 50));
        expect(executed, isFalse);

        // Wait for debounce to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(executed, isTrue);
      });

      test('should cancel previous action when called again', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);
        var firstCalled = false;
        var secondCalled = false;

        // Act
        debouncer.run(() {
          firstCalled = true;
        });

        await Future.delayed(const Duration(milliseconds: 50));

        debouncer.run(() {
          secondCalled = true;
        });

        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(firstCalled, isFalse);
        expect(secondCalled, isTrue);
      });

      test('should handle rapid consecutive calls', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);
        var callCount = 0;

        // Act
        for (var i = 0; i < 10; i++) {
          debouncer.run(() {
            callCount++;
          });
          await Future.delayed(const Duration(milliseconds: 20));
        }

        await Future.delayed(const Duration(milliseconds: 200));

        // Assert - Only last call should execute
        expect(callCount, equals(1));
      });

      test('should execute action with captured variables', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 50);
        var result = '';

        // Act
        final value = 'test value';
        debouncer.run(() {
          result = value;
        });

        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(result, equals('test value'));
      });
    });

    group('Cancel', () {
      test('should cancel pending action', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);
        var executed = false;

        // Act
        debouncer.run(() {
          executed = true;
        });

        debouncer.cancel();

        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executed, isFalse);
      });

      test('should handle cancel when no action pending', () {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);

        // Act & Assert - should not throw
        expect(() => debouncer.cancel(), returnsNormally);
      });

      test('should handle multiple cancel calls', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);
        var executed = false;

        // Act
        debouncer.run(() {
          executed = true;
        });

        debouncer.cancel();
        debouncer.cancel();
        debouncer.cancel();

        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executed, isFalse);
      });
    });

    group('Dispose', () {
      test('should dispose debouncer and cancel action', () async {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);
        var executed = false;

        // Act
        debouncer.run(() {
          executed = true;
        });

        debouncer.dispose();

        await Future.delayed(const Duration(milliseconds: 150));

        // Assert
        expect(executed, isFalse);
      });

      test('should handle dispose without pending action', () {
        // Arrange
        final debouncer = Debouncer(milliseconds: 100);

        // Act & Assert
        expect(() => debouncer.dispose(), returnsNormally);
      });
    });
  });

  group('Throttler', () {
    group('Construction', () {
      test('should create throttler with milliseconds', () {
        // Act
        final throttler = Throttler(milliseconds: 300);

        // Assert
        expect(throttler, isNotNull);
        expect(throttler.milliseconds, equals(300));
      });
    });

    group('Run', () {
      test('should execute action immediately on first call', () {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var executed = false;

        // Act
        throttler.run(() {
          executed = true;
        });

        // Assert - should execute immediately
        expect(executed, isTrue);
      });

      test('should ignore subsequent calls within throttle period', () async {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var callCount = 0;

        // Act
        throttler.run(() {
          callCount++;
        });

        await Future.delayed(const Duration(milliseconds: 50));

        throttler.run(() {
          callCount++;
        });

        // Assert - second call should be ignored
        expect(callCount, equals(1));
      });

      test('should allow execution after throttle period expires', () async {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var callCount = 0;

        // Act
        throttler.run(() {
          callCount++;
        });

        await Future.delayed(const Duration(milliseconds: 150));

        throttler.run(() {
          callCount++;
        });

        // Assert
        expect(callCount, equals(2));
      });

      test('should throttle rapid consecutive calls', () async {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var callCount = 0;

        // Act
        for (var i = 0; i < 10; i++) {
          throttler.run(() {
            callCount++;
          });
          await Future.delayed(const Duration(milliseconds: 10));
        }

        // Assert - Only first call in each throttle window executes
        expect(callCount, equals(1));
      });

      test('should execute action with captured variables', () {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var result = '';

        // Act
        final value = 'test value';
        throttler.run(() {
          result = value;
        });

        // Assert
        expect(result, equals('test value'));
      });
    });

    group('Reset', () {
      test('should reset throttle state', () async {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var callCount = 0;

        // Act
        throttler.run(() {
          callCount++;
        });

        throttler.reset();

        throttler.run(() {
          callCount++;
        });

        // Assert - both calls should execute
        expect(callCount, equals(2));
      });

      test('should allow immediate execution after reset', () {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var callCount = 0;

        // Act
        throttler.run(() {
          callCount++;
        });

        throttler.reset();

        throttler.run(() {
          callCount++;
        });

        throttler.run(() {
          callCount++;
        });

        // Assert - first two calls execute, third is throttled
        expect(callCount, equals(2));
      });

      test('should handle reset when no prior execution', () {
        // Arrange
        final throttler = Throttler(milliseconds: 100);

        // Act & Assert
        expect(() => throttler.reset(), returnsNormally);
      });
    });

    group('Real-World Use Cases', () {
      test('should handle scroll event throttling', () async {
        // Arrange
        final throttler = Throttler(milliseconds: 100);
        var loadMoreCallCount = 0;

        // Simulate rapid scroll events
        for (var i = 0; i < 20; i++) {
          throttler.run(() {
            loadMoreCallCount++;
          });
          await Future.delayed(const Duration(milliseconds: 10));
        }

        // Assert - should significantly reduce call count
        expect(loadMoreCallCount, lessThan(5));
      });

      test('should handle resize event throttling', () async {
        // Arrange
        final throttler = Throttler(milliseconds: 200);
        var recalculateCount = 0;

        // Simulate rapid resize events
        for (var i = 0; i < 50; i++) {
          throttler.run(() {
            recalculateCount++;
          });
          await Future.delayed(const Duration(milliseconds: 5));
        }

        // Assert
        expect(recalculateCount, lessThan(5));
      });
    });
  });
}
