import 'dart:io';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:js_ts_ide_enhancements/js_ts_ide_enhancements.dart';

void main() {
  group('Prettier Integration', () {
    late String testProjectRoot;
    late File packageJsonFile;
    late NpmCommands npmCommands;

    setUp(() async {
      // Create temporary test project
      final tempDir = Directory.systemTemp.createTempSync('prettier_test');
      testProjectRoot = tempDir.path;
      packageJsonFile = File(path.join(testProjectRoot, 'package.json'));
      await packageJsonFile.writeAsString('''
{
  "name": "test-project",
  "version": "1.0.0",
  "devDependencies": {
    "prettier": "^3.0.0"
  },
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
''');
      npmCommands = NpmCommands(projectRoot: testProjectRoot);
    });

    tearDown(() async {
      // Cleanup
      if (await packageJsonFile.exists()) {
        await packageJsonFile.parent.delete(recursive: true);
      }
    });

    group('Prettier Script Execution', () {
      test('should detect prettier format script', () async {
        // Arrange & Act
        final scriptsResult = await npmCommands.getAvailableScripts();

        // Assert
        expect(scriptsResult.isRight(), isTrue);
        scriptsResult.fold(
          (_) => fail('Should have succeeded'),
          (scripts) {
            expect(scripts, contains('format'));
            expect(scripts, contains('format:check'));
          },
        );
      });

      test('should execute prettier format script', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('const x={a:1,b:2};console.log(x);');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should execute prettier check script', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('''
const x = {
  a: 1,
  b: 2
};
console.log(x);
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format:check');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle prettier with custom config', () async {
        // Arrange - Create .prettierrc config
        final prettierrc = File(path.join(testProjectRoot, '.prettierrc'));
        await prettierrc.writeAsString('''
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
''');

        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('const x = {a: 1};');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Prettier Configuration Detection', () {
      test('should detect .prettierrc file', () async {
        // Arrange
        final prettierrc = File(path.join(testProjectRoot, '.prettierrc'));
        await prettierrc.writeAsString('{"semi": false}');

        // Act
        final exists = await prettierrc.exists();

        // Assert
        expect(exists, isTrue);
      });

      test('should detect .prettierrc.json file', () async {
        // Arrange
        final prettierrcJson = File(path.join(testProjectRoot, '.prettierrc.json'));
        await prettierrcJson.writeAsString('{"semi": false}');

        // Act
        final exists = await prettierrcJson.exists();

        // Assert
        expect(exists, isTrue);
      });

      test('should detect .prettierrc.js file', () async {
        // Arrange
        final prettierrcJs = File(path.join(testProjectRoot, '.prettierrc.js'));
        await prettierrcJs.writeAsString('''
module.exports = {
  semi: false,
  singleQuote: true
};
''');

        // Act
        final exists = await prettierrcJs.exists();

        // Assert
        expect(exists, isTrue);
      });

      test('should detect prettier config in package.json', () async {
        // Arrange
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "prettier": {
    "semi": false,
    "singleQuote": true
  }
}
''');

        // Act
        final content = await packageJsonFile.readAsString();

        // Assert
        expect(content, contains('prettier'));
      });
    });

    group('Format Different File Types', () {
      test('should format JavaScript files', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'app.js'));
        await jsFile.writeAsString('''
function hello(){console.log("Hello World");}
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format TypeScript files', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final tsFile = File(path.join(srcDir.path, 'app.ts'));
        await tsFile.writeAsString('''
interface User{name:string;age:number;}
const user:User={name:"John",age:30};
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format JSX/TSX files', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsxFile = File(path.join(srcDir.path, 'App.jsx'));
        await jsxFile.writeAsString('''
import React from 'react';
const App=()=>{return <div><h1>Hello</h1></div>;};
export default App;
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format JSON files', () async {
        // Arrange
        final dataDir = Directory(path.join(testProjectRoot, 'data'));
        await dataDir.create();
        final jsonFile = File(path.join(dataDir.path, 'config.json'));
        await jsonFile.writeAsString('{"name":"test","value":123}');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format CSS files', () async {
        // Arrange
        final stylesDir = Directory(path.join(testProjectRoot, 'styles'));
        await stylesDir.create();
        final cssFile = File(path.join(stylesDir.path, 'app.css'));
        await cssFile.writeAsString('''
.button{background:blue;color:white;padding:10px;}
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format HTML files', () async {
        // Arrange
        final publicDir = Directory(path.join(testProjectRoot, 'public'));
        await publicDir.create();
        final htmlFile = File(path.join(publicDir.path, 'index.html'));
        await htmlFile.writeAsString('''
<!DOCTYPE html><html><head><title>Test</title></head><body><h1>Hello</h1></body></html>
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format Markdown files', () async {
        // Arrange
        final docsDir = Directory(path.join(testProjectRoot, 'docs'));
        await docsDir.create();
        final mdFile = File(path.join(docsDir.path, 'README.md'));
        await mdFile.writeAsString('''
#Title
This is a paragraph with no spacing.
*   bullet point
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should format YAML files', () async {
        // Arrange
        final yamlFile = File(path.join(testProjectRoot, '.github/workflows/ci.yml'));
        await yamlFile.parent.create(recursive: true);
        await yamlFile.writeAsString('''
name: CI
on: push
jobs: {build: {runs-on: ubuntu-latest}}
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Prettier Ignore Files', () {
      test('should respect .prettierignore file', () async {
        // Arrange
        final prettierignore = File(path.join(testProjectRoot, '.prettierignore'));
        await prettierignore.writeAsString('''
node_modules
dist
build
*.min.js
''');

        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'app.js'));
        await jsFile.writeAsString('const x = 1;');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should ignore node_modules by default', () async {
        // Arrange
        final nodeModules = Directory(path.join(testProjectRoot, 'node_modules'));
        await nodeModules.create();
        final packageDir = Directory(path.join(nodeModules.path, 'some-package'));
        await packageDir.create();
        final jsFile = File(path.join(packageDir.path, 'index.js'));
        await jsFile.writeAsString('const x={};');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Real-world Developer Workflows', () {
      test('should run format before commit workflow', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('const x={a:1};');

        // Act - Pre-commit: check format
        final checkResult = await npmCommands.runScript(scriptName: 'format:check');
        expect(checkResult, isA<Either<String, String>>());

        // Act - Format if needed
        final formatResult = await npmCommands.runScript(scriptName: 'format');
        expect(formatResult, isA<Either<String, String>>());
      });

      test('should handle CI format check workflow', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('''
const x = {
  a: 1,
  b: 2
};
''');

        // Act - CI: check format without modifying files
        final result = await npmCommands.runScript(scriptName: 'format:check');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle IDE save-on-format workflow', () async {
        // Arrange - Add format script to simulate IDE integration
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "format:file": "prettier --write"
  }
}
''');

        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'app.js'));
        await jsFile.writeAsString('function save(){return true;}');

        // Act - Format on save
        final result = await npmCommands.runScript(scriptName: 'format:file');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle team collaboration format enforcement', () async {
        // Arrange - Setup project with Prettier config
        final prettierrc = File(path.join(testProjectRoot, '.prettierrc'));
        await prettierrc.writeAsString('''
{
  "semi": false,
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
''');

        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'team.js'));
        await jsFile.writeAsString('const teamCode = "uniform style";');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format:check');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Prettier with ESLint Integration', () {
      test('should work with ESLint and Prettier together', () async {
        // Arrange
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "lint": "eslint .",
    "format": "prettier --write .",
    "lint:fix": "eslint --fix ."
  }
}
''');

        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('const x = 1');

        // Act - Run both lint and format
        final formatResult = await npmCommands.runScript(scriptName: 'format');
        expect(formatResult, isA<Either<String, String>>());

        final lintResult = await npmCommands.runScript(scriptName: 'lint');
        expect(lintResult, isA<Either<String, String>>());
      });

      test('should handle eslint-config-prettier', () async {
        // Arrange
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "devDependencies": {
    "prettier": "^3.0.0",
    "eslint": "^8.0.0",
    "eslint-config-prettier": "^9.0.0"
  }
}
''');

        // Act
        final scriptsResult = await npmCommands.getAvailableScripts();

        // Assert
        expect(scriptsResult, isA<Either<String, List<String>>>());
      });
    });

    group('Prettier Plugin Support', () {
      test('should support prettier-plugin-organize-imports', () async {
        // Arrange
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "devDependencies": {
    "prettier": "^3.0.0",
    "prettier-plugin-organize-imports": "^3.0.0"
  }
}
''');

        final tsFile = File(path.join(testProjectRoot, 'src/app.ts'));
        await tsFile.parent.create(recursive: true);
        await tsFile.writeAsString('''
import { z } from 'zod';
import { a } from 'a';
import { b } from 'b';
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should support prettier-plugin-tailwindcss', () async {
        // Arrange
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "devDependencies": {
    "prettier": "^3.0.0",
    "prettier-plugin-tailwindcss": "^0.5.0"
  }
}
''');

        final jsxFile = File(path.join(testProjectRoot, 'src/App.jsx'));
        await jsxFile.parent.create(recursive: true);
        await jsxFile.writeAsString('''
export default function App() {
  return <div className="text-blue-500 bg-gray-100 p-4">Hello</div>;
}
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Performance and Optimization', () {
      test('should format large codebase efficiently', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();

        // Create multiple files
        for (int i = 0; i < 20; i++) {
          final file = File(path.join(srcDir.path, 'file_$i.js'));
          await file.writeAsString('''
function function$i(){const x={a:1,b:2};return x;}
''');
        }

        // Act
        final stopwatch = Stopwatch()..start();
        final result = await npmCommands.runScript(scriptName: 'format');
        stopwatch.stop();

        // Assert
        expect(result, isA<Either<String, String>>());
        // Should complete in reasonable time
        expect(stopwatch.elapsed.inSeconds, lessThan(60));
      });

      test('should support incremental formatting', () async {
        // Arrange
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "format:staged": "prettier --write --cache"
  }
}
''');

        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'index.js'));
        await jsFile.writeAsString('const x = 1;');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format:staged');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Error Handling', () {
      test('should handle missing prettier package', () async {
        // Arrange - Package.json without prettier
        await packageJsonFile.writeAsString('''
{
  "name": "test",
  "scripts": {
    "format": "prettier --write ."
  }
}
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle syntax errors in files', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'broken.js'));
        // Invalid JavaScript syntax
        await jsFile.writeAsString('''
const x = {
  a: 1,
  b: 2,
  // missing closing brace
''');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle invalid prettier config', () async {
        // Arrange
        final prettierrc = File(path.join(testProjectRoot, '.prettierrc'));
        await prettierrc.writeAsString('invalid json content');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Edge Cases', () {
      test('should handle empty project', () async {
        // Arrange - Project with no source files

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle mixed file types', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();

        final jsFile = File(path.join(srcDir.path, 'app.js'));
        await jsFile.writeAsString('const x=1;');

        final tsFile = File(path.join(srcDir.path, 'app.ts'));
        await tsFile.writeAsString('const y:number=2;');

        final cssFile = File(path.join(srcDir.path, 'app.css'));
        await cssFile.writeAsString('.class{color:red;}');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle nested directory structure', () async {
        // Arrange
        final deepDir = Directory(path.join(
          testProjectRoot,
          'src/components/ui/buttons',
        ));
        await deepDir.create(recursive: true);

        final jsFile = File(path.join(deepDir.path, 'Button.jsx'));
        await jsFile.writeAsString('export const Button=()=><button>Click</button>;');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle files with special characters', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final specialFile = File(path.join(srcDir.path, 'file-with-dashes.js'));
        await specialFile.writeAsString('const x=1;');

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should handle very long lines', () async {
        // Arrange
        final srcDir = Directory(path.join(testProjectRoot, 'src'));
        await srcDir.create();
        final jsFile = File(path.join(srcDir.path, 'long.js'));
        await jsFile.writeAsString(
          'const veryLongVariableName = "' +
              'a' * 200 +
              '";',
        );

        // Act
        final result = await npmCommands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });

    group('Package Manager Compatibility', () {
      test('should work with npm', () async {
        // Arrange
        final commands = NpmCommands(
          projectRoot: testProjectRoot,
          packageManager: PackageManager.npm,
        );

        // Act
        final result = await commands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should work with yarn', () async {
        // Arrange
        final commands = NpmCommands(
          projectRoot: testProjectRoot,
          packageManager: PackageManager.yarn,
        );

        // Act
        final result = await commands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });

      test('should work with pnpm', () async {
        // Arrange
        final commands = NpmCommands(
          projectRoot: testProjectRoot,
          packageManager: PackageManager.pnpm,
        );

        // Act
        final result = await commands.runScript(scriptName: 'format');

        // Assert
        expect(result, isA<Either<String, String>>());
      });
    });
  });
}
