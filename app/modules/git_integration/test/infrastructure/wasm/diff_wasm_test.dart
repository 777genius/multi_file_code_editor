import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_integration/src/infrastructure/wasm/diff_wasm.dart';

void main() {
  group('DiffWasmLoader', () {
    group('Singleton Pattern', () {
      test('should return same instance on multiple calls', () {
        // Act
        final instance1 = DiffWasmLoader.instance;
        final instance2 = DiffWasmLoader.instance;

        // Assert
        expect(identical(instance1, instance2), isTrue);
      });

      test('should create instance lazily', () {
        // Act
        final instance = DiffWasmLoader.instance;

        // Assert
        expect(instance, isNotNull);
        expect(instance, isA<DiffWasmLoader>());
      });
    });

    group('Platform Support - Non-Web (Stub)', () {
      test('should report WASM as not supported on non-web platforms', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act
        final isSupported = loader.isSupported;

        // Assert
        expect(isSupported, isFalse);
      });

      test('should report as not initialized on non-web platforms', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act
        final isInitialized = loader.isInitialized;

        // Assert
        expect(isInitialized, isFalse);
      });

      test('should throw UnsupportedError on initialize', () async {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        await expectLater(
          loader.initialize(),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should include helpful message in initialize error', () async {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        await expectLater(
          loader.initialize(),
          throwsA(
            predicate((e) =>
                e is UnsupportedError &&
                e.message!.contains('web platform')),
          ),
        );
      });

      test('should suggest fallback in initialize error message', () async {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        await expectLater(
          loader.initialize(),
          throwsA(
            predicate((e) =>
                e is UnsupportedError &&
                e.message!.contains('fallback')),
          ),
        );
      });
    });

    group('Myers Diff - Non-Web (Stub)', () {
      test('should throw UnsupportedError on myersDiff call', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(
            oldText: 'old',
            newText: 'new',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw even with empty strings', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(
            oldText: '',
            newText: '',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw with custom context lines', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(
            oldText: 'old',
            newText: 'new',
            contextLines: 5,
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should include platform message in myersDiff error', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: 'a', newText: 'b'),
          throwsA(
            predicate((e) =>
                e is UnsupportedError &&
                e.message!.contains('web platform')),
          ),
        );
      });
    });

    group('Diff Stats - Non-Web (Stub)', () {
      test('should throw UnsupportedError on diffStats call', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.diffStats(
            oldText: 'old',
            newText: 'new',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw with empty strings', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.diffStats(
            oldText: '',
            newText: '',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw with multiline text', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.diffStats(
            oldText: 'line1\nline2\nline3',
            newText: 'line1\nmodified\nline3',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should include platform message in diffStats error', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.diffStats(oldText: 'a', newText: 'b'),
          throwsA(
            predicate((e) =>
                e is UnsupportedError &&
                e.message!.contains('web platform')),
          ),
        );
      });
    });

    group('Parse Methods - Non-Web (Stub)', () {
      test('should throw UnsupportedError on parseDiffResult', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        final json = '{"hunks": []}';

        // Act & Assert
        expect(
          () => loader.parseDiffResult(json),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw UnsupportedError on parseDiffStats', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        final json = '{"additions": 5, "deletions": 3, "total": 8}';

        // Act & Assert
        expect(
          () => loader.parseDiffStats(json),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw even with valid JSON in parseDiffResult', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        final validJson = jsonEncode({
          'hunks': [
            {
              'oldStart': 1,
              'oldLines': 3,
              'newStart': 1,
              'newLines': 4,
              'lines': ['+added'],
            },
          ],
        });

        // Act & Assert
        expect(
          () => loader.parseDiffResult(validJson),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should throw even with valid JSON in parseDiffStats', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        final validJson = jsonEncode({
          'additions': 10,
          'deletions': 5,
          'total': 15,
        });

        // Act & Assert
        expect(
          () => loader.parseDiffStats(validJson),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Method Parameter Validation', () {
      test('should respect contextLines parameter signature', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - should accept contextLines parameter
        expect(
          () => loader.myersDiff(
            oldText: 'text',
            newText: 'text',
            contextLines: 0,
          ),
          throwsA(isA<UnsupportedError>()),
        );

        expect(
          () => loader.myersDiff(
            oldText: 'text',
            newText: 'text',
            contextLines: 10,
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should require oldText and newText parameters', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(
            oldText: 'test',
            newText: 'test',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should accept various text types in parameters', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - Should handle empty, single-line, multi-line
        final testCases = [
          ('', ''),
          ('single line', 'single line'),
          ('line1\nline2', 'line1\nline2\nline3'),
          ('special chars: @#\$%', 'special chars: @#\$%^'),
        ];

        for (final (old, new_) in testCases) {
          expect(
            () => loader.myersDiff(oldText: old, newText: new_),
            throwsA(isA<UnsupportedError>()),
          );
        }
      });
    });

    group('Error Messages', () {
      test('should provide consistent error messages across methods', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - All methods should mention web platform
        final errors = <String>[];

        try {
          loader.myersDiff(oldText: 'a', newText: 'b');
        } on UnsupportedError catch (e) {
          errors.add(e.message ?? '');
        }

        try {
          loader.diffStats(oldText: 'a', newText: 'b');
        } on UnsupportedError catch (e) {
          errors.add(e.message ?? '');
        }

        for (final error in errors) {
          expect(error, contains('web platform'));
          expect(error, contains('fallback'));
        }
      });

      test('should suggest alternative implementation', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: 'a', newText: 'b'),
          throwsA(
            predicate((e) =>
                e is UnsupportedError &&
                e.message!.toLowerCase().contains('dart')),
          ),
        );
      });
    });

    group('Integration Behavior', () {
      test('should maintain singleton across multiple operation attempts', () {
        // Arrange & Act
        final instance1 = DiffWasmLoader.instance;

        try {
          instance1.myersDiff(oldText: 'a', newText: 'b');
        } catch (_) {}

        try {
          instance1.diffStats(oldText: 'a', newText: 'b');
        } catch (_) {}

        final instance2 = DiffWasmLoader.instance;

        // Assert
        expect(identical(instance1, instance2), isTrue);
      });

      test('should consistently report unsupported state', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - State should remain consistent
        expect(loader.isSupported, isFalse);
        expect(loader.isInitialized, isFalse);

        try {
          loader.myersDiff(oldText: 'a', newText: 'b');
        } catch (_) {}

        expect(loader.isSupported, isFalse);
        expect(loader.isInitialized, isFalse);
      });

      test('should handle rapid consecutive calls gracefully', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        for (var i = 0; i < 10; i++) {
          expect(
            () => loader.myersDiff(oldText: 'old$i', newText: 'new$i'),
            throwsA(isA<UnsupportedError>()),
          );
        }
      });
    });

    group('Edge Cases', () {
      test('should handle very long text inputs', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        final longText = 'x' * 10000;

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: longText, newText: longText),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle special characters in text', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        const specialChars = '!@#\$%^&*()_+-=[]{}|;:\'",.<>?/~`';

        // Act & Assert
        expect(
          () => loader.myersDiff(
            oldText: specialChars,
            newText: specialChars,
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle unicode characters', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        const unicode = '你好世界 🌍 Привет مرحبا';

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: unicode, newText: unicode),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle null-like empty strings', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: '', newText: ''),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle newline variations', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        final newlineVariants = [
          'line1\nline2',    // Unix
          'line1\r\nline2',  // Windows
          'line1\rline2',    // Old Mac
        ];

        for (final text in newlineVariants) {
          expect(
            () => loader.myersDiff(oldText: text, newText: text),
            throwsA(isA<UnsupportedError>()),
          );
        }
      });
    });

    group('Documentation Compliance', () {
      test('should match documented API for myersDiff', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - API should accept all documented parameters
        expect(
          () => loader.myersDiff(
            oldText: 'function foo() {}',
            newText: 'function bar() {}',
            contextLines: 3, // Default context
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should match documented API for diffStats', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(
          () => loader.diffStats(
            oldText: 'old content',
            newText: 'new content',
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should document platform-specific behavior', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Assert - Non-web should be clearly unsupported
        expect(loader.isSupported, isFalse);
        expect(loader.isInitialized, isFalse);
      });
    });

    group('Type Safety', () {
      test('should return correct types for getters', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert
        expect(loader.isSupported, isA<bool>());
        expect(loader.isInitialized, isA<bool>());
      });

      test('should accept correct parameter types', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - Should compile and accept String types
        expect(
          () => loader.myersDiff(
            oldText: 'string type',
            newText: 'string type',
            contextLines: 5, // int type
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Conditional Export Behavior', () {
      test('should use stub implementation on non-web platforms', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Assert - Stub should be active (test runs on VM, not web)
        expect(loader.isSupported, isFalse);
      });

      test('should throw UnsupportedError consistently', () {
        // Arrange
        final loader = DiffWasmLoader.instance;

        // Act & Assert - All operations should throw
        final operations = [
          () async => await loader.initialize(),
          () => loader.myersDiff(oldText: 'a', newText: 'b'),
          () => loader.diffStats(oldText: 'a', newText: 'b'),
          () => loader.parseDiffResult('{}'),
          () => loader.parseDiffStats('{}'),
        ];

        for (final operation in operations) {
          expect(operation, throwsA(isA<UnsupportedError>()));
        }
      });
    });

    group('Real-World Scenarios', () {
      test('should handle typical code diff scenario', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        const oldCode = '''
void main() {
  print('Hello');
}
''';
        const newCode = '''
void main() {
  print('Hello World');
}
''';

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: oldCode, newText: newCode),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle git commit diff scenario', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        const oldFile = 'const version = "1.0.0";';
        const newFile = 'const version = "1.1.0";';

        // Act & Assert
        expect(
          () => loader.diffStats(oldText: oldFile, newText: newFile),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle file creation scenario', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        const oldFile = '';
        const newFile = 'New file content\nLine 2\nLine 3';

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: oldFile, newText: newFile),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('should handle file deletion scenario', () {
        // Arrange
        final loader = DiffWasmLoader.instance;
        const oldFile = 'Content to be deleted\nLine 2\nLine 3';
        const newFile = '';

        // Act & Assert
        expect(
          () => loader.myersDiff(oldText: oldFile, newText: newFile),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });
  });
}
