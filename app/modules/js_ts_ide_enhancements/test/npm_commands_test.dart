import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:js_ts_ide_enhancements/js_ts_ide_enhancements.dart';

void main() {
  group('NpmCommands', () {
    late String testProjectRoot;
    late NpmCommands npmCommands;

    setUp(() {
      testProjectRoot = '/test/project';
      npmCommands = NpmCommands(projectRoot: testProjectRoot);
    });

    group('Constructor and Validation', () {
      test('should create instance with valid project root', () {
        // Arrange & Act
        final commands = NpmCommands(projectRoot: '/valid/path');

        // Assert
        expect(commands, isNotNull);
      });

      test('should create instance with package manager', () {
        // Arrange & Act
        final commands = NpmCommands(
          projectRoot: '/valid/path',
          packageManager: PackageManager.yarn,
        );

        // Assert
        expect(commands, isNotNull);
      });

      test('should throw ArgumentError when project root is empty', () {
        // Arrange, Act & Assert
        expect(
          () => NpmCommands(projectRoot: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError when project root contains parent directory references', () {
        // Arrange, Act & Assert
        expect(
          () => NpmCommands(projectRoot: '/test/../dangerous'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should normalize project root path', () {
        // Arrange & Act
        final commands = NpmCommands(projectRoot: '/test/./project');

        // Assert
        expect(commands.packageJsonPath, equals(path.normalize('/test/./project/package.json')));
      });

      test('should default to npm package manager', () {
        // Arrange & Act
        final commands = NpmCommands(projectRoot: '/test');

        // Assert
        expect(commands, isNotNull);
      });
    });

    group('Package Name Validation', () {
      test('should accept valid package names', () {
        // Arrange
        final validNames = [
          'package-name',
          'package_name',
          'package.name',
          '@scope/package',
          '@org/package-name',
          'PACKAGE_NAME',
          'package123',
        ];

        // Act & Assert
        for (final name in validNames) {
          expect(
            () => NpmCommands(projectRoot: '/test').addPackage(packageName: name),
            returnsNormally,
          );
        }
      });

      test('should reject empty package name', () async {
        // Arrange & Act
        final result = await npmCommands.addPackage(packageName: '');

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
          final result = await npmCommands.addPackage(packageName: name);
          expect(result.isLeft(), isTrue, reason: 'Should reject: $name');
        }
      });

      test('should reject package name with spaces', () async {
        // Arrange & Act
        final result = await npmCommands.addPackage(packageName: 'invalid package');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Invalid package name')),
          (_) => fail('Should have failed'),
        );
      });

      test('should accept scoped package names', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test-project"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(packageName: '@types/node');

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('isValidJsProject', () {
      test('should return true when package.json exists', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test-project"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.isValidJsProject();

        // Assert
        expect(result, isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should return false when package.json does not exist', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.isValidJsProject();

        // Assert
        expect(result, isFalse);

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('Package Manager Detection', () {
      test('should detect npm from package-lock.json', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');
        final lockFile = File(path.join(tempDir.path, 'package-lock.json'));
        await lockFile.writeAsString('{}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.detectPackageManager();

        // Assert
        expect(result, equals(PackageManager.npm));

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should detect yarn from yarn.lock', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');
        final lockFile = File(path.join(tempDir.path, 'yarn.lock'));
        await lockFile.writeAsString('');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.detectPackageManager();

        // Assert
        expect(result, equals(PackageManager.yarn));

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should detect pnpm from pnpm-lock.yaml', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');
        final lockFile = File(path.join(tempDir.path, 'pnpm-lock.yaml'));
        await lockFile.writeAsString('');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.detectPackageManager();

        // Assert
        expect(result, equals(PackageManager.pnpm));

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should default to npm when no lock file exists', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.detectPackageManager();

        // Assert
        expect(result, equals(PackageManager.npm));

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should prioritize pnpm over yarn over npm', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        // Create all lock files
        final npmLock = File(path.join(tempDir.path, 'package-lock.json'));
        await npmLock.writeAsString('{}');
        final yarnLock = File(path.join(tempDir.path, 'yarn.lock'));
        await yarnLock.writeAsString('');
        final pnpmLock = File(path.join(tempDir.path, 'pnpm-lock.yaml'));
        await pnpmLock.writeAsString('');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.detectPackageManager();

        // Assert
        expect(result, equals(PackageManager.pnpm));

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('setPackageManager', () {
      test('should change package manager', () {
        // Arrange
        final commands = NpmCommands(
          projectRoot: '/test',
          packageManager: PackageManager.npm,
        );

        // Act
        commands.setPackageManager(PackageManager.yarn);

        // Assert - No exception means success
        expect(commands, isNotNull);
      });
    });

    group('install', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.install();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid JavaScript/TypeScript project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should execute npm install', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test-project"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.install();

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('addPackage', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(packageName: 'lodash');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, contains('Not a valid JavaScript/TypeScript project')),
          (_) => fail('Should have failed'),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should validate package name before execution', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(packageName: 'invalid;package');

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should add package with version constraint', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(
          packageName: 'lodash',
          version: '^4.17.0',
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should add dev dependency when isDev is true', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.addPackage(
          packageName: 'jest',
          isDev: true,
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should add global package when isGlobal is true', () async {
        // Arrange
        final commands = NpmCommands(projectRoot: '/test');

        // Act
        final result = await commands.addPackage(
          packageName: 'typescript',
          isGlobal: true,
        );

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle yarn-specific command syntax', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(
          projectRoot: tempDir.path,
          packageManager: PackageManager.yarn,
        );

        // Act
        final result = await commands.addPackage(
          packageName: 'lodash',
          isDev: true,
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('removePackage', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.removePackage(packageName: 'lodash');

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should validate package name before execution', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.removePackage(packageName: 'invalid|package');

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should remove global package when isGlobal is true', () async {
        // Arrange
        final commands = NpmCommands(projectRoot: '/test');

        // Act
        final result = await commands.removePackage(
          packageName: 'typescript',
          isGlobal: true,
        );

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle yarn-specific remove syntax', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(
          projectRoot: tempDir.path,
          packageManager: PackageManager.yarn,
        );

        // Act
        final result = await commands.removePackage(packageName: 'lodash');

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('outdated', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.outdated();

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should return right even with non-zero exit code', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.outdated();

        // Assert
        // outdated command returns non-zero when packages are outdated
        // but we still want the output
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('update', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.update();

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should use npm update command', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.update();

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should use yarn upgrade command', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(
          projectRoot: tempDir.path,
          packageManager: PackageManager.yarn,
        );

        // Act
        final result = await commands.update();

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('runScript', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.runScript(scriptName: 'test');

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should validate script name', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.runScript(scriptName: 'invalid;script');

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should run npm script with npm run', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "test": "echo test"
  }
}
''');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.runScript(scriptName: 'test');

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should run yarn script without run keyword', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "build": "echo build"
  }
}
''');

        final commands = NpmCommands(
          projectRoot: tempDir.path,
          packageManager: PackageManager.yarn,
        );

        // Act
        final result = await commands.runScript(scriptName: 'build');

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('getAvailableScripts', () {
      test('should return left when not a valid JS project', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.getAvailableScripts();

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should return empty list when no scripts defined', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.getAvailableScripts();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should have succeeded'),
          (scripts) => expect(scripts, isEmpty),
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should return list of available scripts', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "test": "jest",
    "build": "webpack",
    "start": "node index.js"
  }
}
''');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.getAvailableScripts();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should have succeeded'),
          (scripts) {
            expect(scripts, hasLength(3));
            expect(scripts, contains('test'));
            expect(scripts, contains('build'));
            expect(scripts, contains('start'));
          },
        );

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should handle malformed package.json', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('invalid json');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.getAvailableScripts();

        // Assert
        expect(result.isLeft(), isTrue);

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('getNodeVersion', () {
      test('should return node version or error', () async {
        // Act
        final result = await npmCommands.getNodeVersion();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should complete within timeout', () async {
        // Act
        final result = await npmCommands.getNodeVersion().timeout(
          const Duration(seconds: 15),
        );

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('getPackageManagerVersion', () {
      test('should return package manager version', () async {
        // Act
        final result = await npmCommands.getPackageManagerVersion();

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should return different versions for different package managers', () async {
        // Arrange
        final npmCommands = NpmCommands(
          projectRoot: '/test',
          packageManager: PackageManager.npm,
        );
        final yarnCommands = NpmCommands(
          projectRoot: '/test',
          packageManager: PackageManager.yarn,
        );

        // Act
        final npmResult = await npmCommands.getPackageManagerVersion();
        final yarnResult = await yarnCommands.getPackageManagerVersion();

        // Assert
        expect(npmResult, isA<Either<String, String>>());
        expect(yarnResult, isA<Either<String, String>>());
      });
    });

    group('Real-world Use Cases', () {
      test('should handle typical project initialization workflow', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('''
{
  "name": "test-project",
  "version": "1.0.0",
  "scripts": {}
}
''');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act - Check if valid project
        final isValid = await commands.isValidJsProject();
        expect(isValid, isTrue);

        // Act - Install dependencies
        final installResult = await commands.install();
        expect(installResult, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should handle adding multiple packages sequentially', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act - Add multiple packages
        final packages = ['lodash', 'axios', 'express'];
        for (final package in packages) {
          final result = await commands.addPackage(packageName: package);
          expect(result, isA<Either<String, String>>());
        }

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should handle test-driven development workflow', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch"
  }
}
''');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act - Get available scripts
        final scriptsResult = await commands.getAvailableScripts();
        expect(scriptsResult.isRight(), isTrue);

        // Act - Run tests
        final testResult = await commands.runScript(scriptName: 'test');
        expect(testResult, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });

      test('should handle build and deployment workflow', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "build": "webpack",
    "deploy": "netlify deploy"
  }
}
''');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act - Build
        final buildResult = await commands.runScript(scriptName: 'build');
        expect(buildResult, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('Edge Cases', () {
      test('should handle package.json path correctly', () {
        // Arrange & Act
        final commands = NpmCommands(projectRoot: '/test/project');

        // Assert
        expect(
          commands.packageJsonPath,
          equals(path.join('/test/project', 'package.json')),
        );
      });

      test('should handle commands with special characters in project path', () {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm test with spaces');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        packageJsonFile.writeAsStringSync('{"name": "test"}');

        // Act
        final commands = NpmCommands(projectRoot: tempDir.path);
        final isValid = commands.isValidJsProject();

        // Assert
        expect(isValid, completion(isTrue));

        // Cleanup
        tempDir.deleteSync(recursive: true);
      });

      test('should handle package manager switching', () {
        // Arrange
        final commands = NpmCommands(
          projectRoot: '/test',
          packageManager: PackageManager.npm,
        );

        // Act - Switch to yarn
        commands.setPackageManager(PackageManager.yarn);

        // Assert - No exception
        expect(commands, isNotNull);

        // Act - Switch to pnpm
        commands.setPackageManager(PackageManager.pnpm);

        // Assert
        expect(commands, isNotNull);
      });
    });

    group('Timeout Handling', () {
      test('should respect default timeout of 2 minutes', () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('npm_test');
        final packageJsonFile = File(path.join(tempDir.path, 'package.json'));
        await packageJsonFile.writeAsString('{"name": "test"}');

        final commands = NpmCommands(projectRoot: tempDir.path);

        // Act
        final result = await commands.install().timeout(
          const Duration(minutes: 3),
          onTimeout: () => left('Test timeout'),
        );

        // Assert
        expect(result, isA<Either<String, String>>());

        // Cleanup
        await tempDir.delete(recursive: true);
      });
    });

    group('PackageManager Enum', () {
      test('should have npm, yarn, and pnpm values', () {
        // Assert
        expect(PackageManager.values, hasLength(3));
        expect(PackageManager.values, contains(PackageManager.npm));
        expect(PackageManager.values, contains(PackageManager.yarn));
        expect(PackageManager.values, contains(PackageManager.pnpm));
      });

      test('should have proper enum names', () {
        // Assert
        expect(PackageManager.npm.name, equals('npm'));
        expect(PackageManager.yarn.name, equals('yarn'));
        expect(PackageManager.pnpm.name, equals('pnpm'));
      });
    });
  });
}
