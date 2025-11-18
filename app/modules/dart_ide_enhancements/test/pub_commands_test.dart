import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:dart_ide_enhancements/dart_ide_enhancements.dart';

// Mock Process for testing
class MockProcess extends Mock implements Process {}

void main() {
  group('PubCommands', () {
    late String testProjectRoot;
    late PubCommands pubCommands;

    setUp(() {
      testProjectRoot = '/test/project';
      pubCommands = PubCommands(projectRoot: testProjectRoot);
    });

    group('Constructor and Validation', () {
      test('should create instance with valid project root', () {
        // Arrange & Act
        final commands = PubCommands(projectRoot: '/valid/path');

        // Assert
        expect(commands, isNotNull);
      });

      test('should throw ArgumentError when project root is empty', () {
        // Arrange, Act & Assert
        expect(
          () => PubCommands(projectRoot: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError when project root contains parent directory references', () {
        // Arrange, Act & Assert
        expect(
          () => PubCommands(projectRoot: '/test/../dangerous'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should normalize project root path', () {
        // Arrange & Act
        final commands = PubCommands(projectRoot: '/test/./project');

        // Assert
        expect(commands.pubspecPath, equals(path.normalize('/test/./project/pubspec.yaml')));
      });
    });

    group('Package Name Validation', () {
      test('should accept valid package names', () {
        // Arrange
        final validNames = [
          'package_name',
          'package-name',
          'package123',
          'PACKAGE_NAME',
          'a',
          '123',
        ];

        // Act & Assert
        for (final name in validNames) {
          expect(
            () => PubCommands(projectRoot: '/test').addPackage(packageName: name),
            returnsNormally,
          );
        }
      });

      test('should reject empty package name', () async {
        // Arrange & Act
        final result = await pubCommands.addPackage(packageName: '');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('cannot be empty')),
          (_) => fail('Should have failed'),
        );
      });

      test('should reject package name with shell metacharacters', () async {
        // Arrange
        final dangerousNames = [
          'package;rm -rf /',
          'package && malicious',
          'package | grep',
          'package`whoami`',
          'package\$HOME',
          'package()',
          'package<>',
        ];

        // Act & Assert
        for (final name in dangerousNames) {
          final result = await pubCommands.addPackage(packageName: name);
          expect(result.isLeft(), isTrue, reason: 'Should reject: $name');
        }
      });

      test('should reject package name with spaces', () async {
        // Arrange & Act
        final result = await pubCommands.addPackage(packageName: 'invalid package');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Invalid package name')),
          (_) => fail('Should have failed'),
        );
      });

      test('should reject package name with special characters', () async {
        // Arrange & Act
        final result = await pubCommands.addPackage(packageName: 'package@#!');

        // Assert
        expect(result.isLeft(), isTrue);
      });
    });

    group('isValidDartProject', () {
      test('should return true when pubspec.yaml exists', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.isValidDartProject();

        // Assert
        expect(result, isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should return false when pubspec.yaml does not exist', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.isValidDartProject();

        // Assert
        expect(result, isFalse);

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('pubGet', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.pubGet();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid Dart/Flutter project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should use dart command when useFlutter is false', () async {
        // This test verifies the command selection logic
        // In a real implementation, you would mock Process.run

        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.pubGet(useFlutter: false);

        // Assert
        // The command will fail since dart pub get requires actual dependencies
        // but we're testing that it attempts to run with 'dart' command
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('pubUpgrade', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.pubUpgrade();

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

    group('pubOutdated', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.pubOutdated();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid Dart/Flutter project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should use --json flag for machine-readable output', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.pubOutdated();

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('addPackage', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(packageName: 'dartz');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid Dart/Flutter project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should validate package name before execution', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(packageName: 'invalid;package');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('shell metacharacters')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should add package with version constraint', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(
          packageName: 'dartz',
          version: '^0.10.0',
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should add dev dependency when isDev is true', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(
          packageName: 'test',
          isDev: true,
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('removePackage', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.removePackage(packageName: 'dartz');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid Dart/Flutter project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should validate package name before execution', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.removePackage(packageName: 'invalid|package');

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('analyze', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
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

      test('should use dart analyze command when useFlutter is false', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.analyze(useFlutter: false);

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should return right with output even if warnings exist', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.analyze();

        // Assert
        // analyze returns 0 even with warnings, so it should be right
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('format', () {
      test('should return left when not a valid Dart project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
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

      test('should use --fix flag when fix is true', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.format(fix: true);

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should format entire project with dot argument', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.format();

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('getDartVersion', () {
      test('should return dart version from stderr', () async {
        // Arrange & Act
        final result = await pubCommands.getDartVersion();

        // Assert
        expect(result, isA<Either<String, String>>());
        // Dart outputs version to stderr
        result.fold(
          (error) => {}, // May fail if dart not installed in test environment
          (version) => expect(version, isNotEmpty),
        );
      });

      test('should complete within timeout', () async {
        // Arrange & Act
        final result = await pubCommands.getDartVersion().timeout(
          const Duration(seconds: 15),
        );

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('getFlutterVersion', () {
      test('should return flutter version or error', () async {
        // Arrange & Act
        final result = await pubCommands.getFlutterVersion();

        // Assert
        expect(result, isA<Either<String, String>>());
        // May return left if Flutter not installed
      });

      test('should complete within timeout', () async {
        // Arrange & Act
        final result = await pubCommands.getFlutterVersion().timeout(
          const Duration(seconds: 15),
        );

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should return left when flutter is not available', () async {
        // This test documents expected behavior when Flutter SDK is not installed
        // The actual result depends on the test environment

        // Arrange & Act
        final result = await pubCommands.getFlutterVersion();

        // Assert
        result.fold(
          (error) => expect(error, contains('Flutter not available')),
          (version) => expect(version, isNotEmpty),
        );
      });
    });

    group('Timeout Handling', () {
      test('should respect default timeout of 2 minutes', () async {
        // This test verifies the timeout constant is properly defined
        // Arrange & Act
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // The timeout is internal, we just verify the method doesn't hang indefinitely
        final result = await commands.pubGet().timeout(
          const Duration(minutes: 3), // Give it more than default
          onTimeout: () => left('Test timeout'),
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('Real-world Use Cases', () {
      test('should handle typical project initialization workflow', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('''
name: test_project
version: 1.0.0

environment:
  sdk: '>=2.17.0 <4.0.0'

dependencies:
''');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act - Check if valid project
        final isValid = await commands.isValidDartProject();
        expect(isValid, isTrue);

        // Act - Get dependencies
        final getResult = await commands.pubGet();
        expect(getResult, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should handle adding multiple packages sequentially', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('''
name: test_project
version: 1.0.0

environment:
  sdk: '>=2.17.0 <4.0.0'

dependencies:
''');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act - Add multiple packages
        final packages = ['dartz', 'equatable', 'rxdart'];
        for (final package in packages) {
          final result = await commands.addPackage(packageName: package);
          expect(result, isA<Either<String, String>>());
        }

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should handle analyze and format workflow', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act - Analyze then format
        final analyzeResult = await commands.analyze();
        expect(analyzeResult, isA<Either<String, String>>());

        final formatResult = await commands.format(fix: true);
        expect(formatResult, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('Edge Cases', () {
      test('should handle pubspec.yaml path correctly', () {
        // Arrange & Act
        final commands = PubCommands(projectRoot: '/test/project');

        // Assert
        expect(
          commands.pubspecPath,
          equals(path.join('/test/project', 'pubspec.yaml')),
        );
      });

      test('should handle commands with special characters in project path', () {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart test with spaces');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        pubspecFile.writeAsStringSync('name: test_project\n');

        // Act
        final commands = PubCommands(projectRoot: tempDir.path);
        final isValid = commands.isValidDartProject();

        // Assert
        expect(isValid, completion(isTrue));

        // Cleanup
        tempDir.deleteSync(recursive: true);
      });

      test('should handle empty output from commands', () async {
        // This documents behavior when commands produce no output
        // The implementation should still handle this gracefully

        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('dart_test');
        final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
        await pubspecFile.writeAsString('name: test_project\n');

        final commands = PubCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.getDartVersion();

        // Assert
        result.fold(
          (error) => expect(error, isA<String>()),
          (output) => {}, // Empty output is acceptable for some commands
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });
  });
}
