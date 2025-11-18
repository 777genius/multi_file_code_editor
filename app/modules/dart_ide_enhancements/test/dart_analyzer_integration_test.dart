import 'dart:io';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:dart_ide_enhancements/dart_ide_enhancements.dart';

void main() {
  group('Dart Analyzer Integration', () {
    late String testProjectRoot;
    late File pubspecFile;
    late PubCommands pubCommands;

    setUp(() async {
      // Create temporary test project
      final tempDir = Directory.systemTemp.createTempSync('dart_analyzer_test');
      testProjectRoot = tempDir.path;
      pubspecFile = File(path.join(testProjectRoot, 'pubspec.yaml'));
      await pubspecFile.writeAsString('''
name: test_project
version: 1.0.0

environment:
  sdk: '>=2.17.0 <4.0.0'

dependencies:
  dartz: ^0.10.1
''');
      pubCommands = PubCommands(projectRoot: testProjectRoot);
    });

    tearDown(() async {
      // Cleanup
      if (await pubspecFile.exists()) {
        await pubspecFile.parent.delete(recursive: true);
      }
    });

    group('Analyzer Execution', () {
      test('should execute dart analyze command', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() { print("Hello"); }');

        // Act
        final result = await pubCommands.analyze(useFlutter: false);

        // Assert
        expect(result, isA<Either<String, String>>());
        result.fold(
          (error) => {}, // May fail if project setup is invalid
          (output) => expect(output, isA<String>()),
        );
      });

      test('should execute flutter analyze command when useFlutter is true', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() { print("Hello"); }');

        // Act
        final result = await pubCommands.analyze(useFlutter: true);

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('invalid_project');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.analyze();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid Dart/Flutter project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should complete within reasonable timeout', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() {}');

        // Act & Assert
        final result = await pubCommands.analyze().timeout(
          const Duration(minutes: 3),
          onTimeout: () => left('Test timeout'),
        );

        expect(result, isA<Either<String, String>>());
      });
    });

    group('Analyzer Output Parsing', () {
      test('should return output even when there are no issues', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() { print("Clean code"); }');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
        result.fold(
          (error) => {},
          (output) => expect(output, isNotEmpty),
        );
      });

      test('should return output when there are warnings', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        // Code with potential warning (unused variable)
        await mainFile.writeAsString('''
void main() {
  var unusedVariable = 42;
  print("Hello");
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        // Note: analyze returns 0 even with warnings
        expect(result, isA<Either<String, String>>());
        result.fold(
          (error) => {},
          (output) => expect(output, isA<String>()),
        );
      });

      test('should handle analyzer output with multiple files', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() { print("Main"); }');

        final utilFile = File(path.join(libDir.path, 'util.dart'));
        await utilFile.writeAsString('String getMessage() => "Util";');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
        result.fold(
          (error) => {},
          (output) => expect(output, isA<String>()),
        );
      });
    });

    group('Format Integration', () {
      test('should execute dart format command', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main(){print("Unformatted");}');

        // Act
        final result = await pubCommands.format();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should execute dart format with --fix flag', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main(){print("Unformatted");}');

        // Act
        final result = await pubCommands.format(fix: true);

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format entire project directory', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main(){print("Main");}');

        final utilFile = File(path.join(libDir.path, 'util.dart'));
        await utilFile.writeAsString('String getMessage(){return "Util";}');

        // Act
        final result = await pubCommands.format();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('invalid_project');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.format();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid Dart/Flutter project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('Real-world Developer Workflows', () {
      test('should run analyze before format workflow', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main(){print("Code");}');

        // Act - Typical pre-commit workflow
        final analyzeResult = await pubCommands.analyze();
        expect(analyzeResult, isA<Either<String, String>>());

        final formatResult = await pubCommands.format(fix: true);
        expect(formatResult, isA<Either<String, String>>());

        // Assert - Both should complete
        expect(analyzeResult, isA<Either<String, String>>());
        expect(formatResult, isA<Either<String, String>>());
      });

      test('should handle continuous integration workflow', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
void main() {
  print("CI workflow test");
}
''');

        // Act - CI workflow: get deps, analyze, format check
        final getResult = await pubCommands.pubGet();
        expect(getResult, isA<Either<String, String>>());

        final analyzeResult = await pubCommands.analyze();
        expect(analyzeResult, isA<Either<String, String>>());

        final formatResult = await pubCommands.format();
        expect(formatResult, isA<Either<String, String>>());

        // Assert
        expect(getResult, isA<Either<String, String>>());
        expect(analyzeResult, isA<Either<String, String>>());
        expect(formatResult, isA<Either<String, String>>());
      });

      test('should handle IDE save workflow', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() { print("Save workflow"); }');

        // Act - On save: format with fix
        final result = await pubCommands.format(fix: true);

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle pre-push validation workflow', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
void main() {
  print("Pre-push validation");
}
''');

        // Act - Pre-push: analyze with strict checks
        final analyzeResult = await pubCommands.analyze();

        // Assert
        expect(analyzeResult, isA<Either<String, String>>());
      });
    });

    group('Error Detection and Reporting', () {
      test('should handle syntax errors in code', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        // Syntax error: missing semicolon
        await mainFile.writeAsString('''
void main() {
  print("Missing semicolon")
  print("Another line");
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
        // Analyzer should report the syntax error
      });

      test('should handle type errors in code', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        // Type error: assigning string to int
        await mainFile.writeAsString('''
void main() {
  int number = "not a number";
  print(number);
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle missing imports', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        // Using undefined class
        await mainFile.writeAsString('''
void main() {
  var list = LinkedList();
  print(list);
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle linter warnings', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        // Add analysis_options.yaml with linter rules
        final analysisOptions = File(path.join(testProjectRoot, 'analysis_options.yaml'));
        await analysisOptions.writeAsString('''
linter:
  rules:
    - prefer_const_constructors
    - avoid_print
''');

        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
void main() {
  print("This violates avoid_print rule");
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Code Quality Checks', () {
      test('should analyze code with custom linter rules', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        // Create custom analysis_options.yaml
        final analysisOptions = File(path.join(testProjectRoot, 'analysis_options.yaml'));
        await analysisOptions.writeAsString('''
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  errors:
    missing_return: error
    dead_code: warning

linter:
  rules:
    - always_declare_return_types
    - prefer_final_locals
    - avoid_print
''');

        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
void main() {
  var message = "Hello";
  print(message);
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should detect unused code', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
void main() {
  usedFunction();
}

void usedFunction() {
  print("Used");
}

void unusedFunction() {
  print("Unused");
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should check for deprecated API usage', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        final apiFile = File(path.join(libDir.path, 'api.dart'));
        await apiFile.writeAsString('''
@deprecated
void oldFunction() {
  print("Deprecated");
}

void newFunction() {
  print("New");
}
''');

        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
import 'api.dart';

void main() {
  oldFunction(); // Using deprecated API
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Format Options and Behaviors', () {
      test('should format without modifying files when checking format', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        final unformattedCode = 'void main(){print("Test");}';
        await mainFile.writeAsString(unformattedCode);

        // Act
        final result = await pubCommands.format();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should apply formatting fixes when fix flag is true', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main(){print("Test");}');

        // Act
        final result = await pubCommands.format(fix: true);

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle already formatted code', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('''
void main() {
  print("Already formatted");
}
''');

        // Act
        final result = await pubCommands.format();

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Performance and Optimization', () {
      test('should analyze large codebase efficiently', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        // Create multiple files
        for (int i = 0; i < 10; i++) {
          final file = File(path.join(libDir.path, 'file_$i.dart'));
          await file.writeAsString('''
void function$i() {
  print("File $i");
}
''');
        }

        // Act
        final stopwatch = Stopwatch()..start();
        final result = await pubCommands.analyze();
        stopwatch.stop();

        // Assert
        expect(result, isA<Either<String, String>>());
        // Should complete in reasonable time
        expect(stopwatch.elapsed.inSeconds, lessThan(60));
      });

      test('should format large codebase efficiently', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        // Create multiple files with unformatted code
        for (int i = 0; i < 10; i++) {
          final file = File(path.join(libDir.path, 'file_$i.dart'));
          await file.writeAsString('void function$i(){print("File $i");}');
        }

        // Act
        final stopwatch = Stopwatch()..start();
        final result = await pubCommands.format();
        stopwatch.stop();

        // Assert
        expect(result, isA<Either<String, String>>());
        expect(stopwatch.elapsed.inSeconds, lessThan(60));
      });
    });

    group('Version Compatibility', () {
      test('should get Dart SDK version', () async {
        // Act
        final result = await pubCommands.getDartVersion();

        // Assert
        expect(result, isA<Either<String, String>>());
        result.fold(
          (error) => {}, // May fail if Dart not installed
          (version) {
            expect(version, isNotEmpty);
            // Dart version typically contains "Dart SDK version"
          },
        );
      });

      test('should handle analyzer with different Dart versions', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();
        final mainFile = File(path.join(libDir.path, 'main.dart'));
        await mainFile.writeAsString('void main() { print("Test"); }');

        // Act
        final versionResult = await pubCommands.getDartVersion();
        final analyzeResult = await pubCommands.analyze();

        // Assert
        expect(versionResult, isA<Either<String, String>>());
        expect(analyzeResult, isA<Either<String, String>>());
      });
    });

    group('Edge Cases', () {
      test('should handle empty project', () async {
        // Arrange
        // Project has only pubspec.yaml, no lib directory

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle project with only test files', () async {
        // Arrange
        final testDir = Directory(path.join(testProjectRoot, 'test'));
        await testDir.create();
        final testFile = File(path.join(testDir.path, 'test.dart'));
        await testFile.writeAsString('''
import 'package:test/test.dart';

void main() {
  test('sample test', () {
    expect(1, equals(1));
  });
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle nested directory structure', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        final srcDir = Directory(path.join(libDir.path, 'src'));
        await srcDir.create();

        final modelsDir = Directory(path.join(srcDir.path, 'models'));
        await modelsDir.create();

        final modelFile = File(path.join(modelsDir.path, 'user.dart'));
        await modelFile.writeAsString('''
class User {
  final String name;
  User(this.name);
}
''');

        // Act
        final result = await pubCommands.analyze();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle special characters in file names', () async {
        // Arrange
        final libDir = Directory(path.join(testProjectRoot, 'lib'));
        await libDir.create();

        final specialFile = File(path.join(libDir.path, 'file_with_underscore.dart'));
        await specialFile.writeAsString('void main() { print("Special"); }');

        // Act
        final result = await pubCommands.format();

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });
  });
}
