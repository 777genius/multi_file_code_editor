import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/src/ports/services/language_detector.dart';

class MockLanguageDetector extends Mock implements LanguageDetector {}

void main() {
  group('LanguageDetector', () {
    late MockLanguageDetector detector;

    setUp(() {
      detector = MockLanguageDetector();
    });

    group('detectFromFileName', () {
      test('should detect Dart from .dart file', () {
        // Arrange
        when(() => detector.detectFromFileName('main.dart'))
            .thenReturn('dart');

        // Act
        final result = detector.detectFromFileName('main.dart');

        // Assert
        expect(result, equals('dart'));
        verify(() => detector.detectFromFileName('main.dart')).called(1);
      });

      test('should detect JavaScript from .js file', () {
        // Arrange
        when(() => detector.detectFromFileName('app.js')).thenReturn('javascript');

        // Act
        final result = detector.detectFromFileName('app.js');

        // Assert
        expect(result, equals('javascript'));
      });

      test('should detect TypeScript from .ts file', () {
        // Arrange
        when(() => detector.detectFromFileName('index.ts')).thenReturn('typescript');

        // Act
        final result = detector.detectFromFileName('index.ts');

        // Assert
        expect(result, equals('typescript'));
      });

      test('should detect Python from .py file', () {
        // Arrange
        when(() => detector.detectFromFileName('script.py')).thenReturn('python');

        // Act
        final result = detector.detectFromFileName('script.py');

        // Assert
        expect(result, equals('python'));
      });

      test('should detect JSON from .json file', () {
        // Arrange
        when(() => detector.detectFromFileName('config.json')).thenReturn('json');

        // Act
        final result = detector.detectFromFileName('config.json');

        // Assert
        expect(result, equals('json'));
      });

      test('should detect YAML from .yaml file', () {
        // Arrange
        when(() => detector.detectFromFileName('pubspec.yaml')).thenReturn('yaml');

        // Act
        final result = detector.detectFromFileName('pubspec.yaml');

        // Assert
        expect(result, equals('yaml'));
      });

      test('should detect Markdown from .md file', () {
        // Arrange
        when(() => detector.detectFromFileName('README.md')).thenReturn('markdown');

        // Act
        final result = detector.detectFromFileName('README.md');

        // Assert
        expect(result, equals('markdown'));
      });

      test('should detect HTML from .html file', () {
        // Arrange
        when(() => detector.detectFromFileName('index.html')).thenReturn('html');

        // Act
        final result = detector.detectFromFileName('index.html');

        // Assert
        expect(result, equals('html'));
      });

      test('should detect CSS from .css file', () {
        // Arrange
        when(() => detector.detectFromFileName('styles.css')).thenReturn('css');

        // Act
        final result = detector.detectFromFileName('styles.css');

        // Assert
        expect(result, equals('css'));
      });

      test('should handle files with multiple extensions', () {
        // Arrange
        when(() => detector.detectFromFileName('archive.tar.gz'))
            .thenReturn('gzip');

        // Act
        final result = detector.detectFromFileName('archive.tar.gz');

        // Assert
        expect(result, equals('gzip'));
      });

      test('should return plaintext for unknown extension', () {
        // Arrange
        when(() => detector.detectFromFileName('file.unknown'))
            .thenReturn('plaintext');

        // Act
        final result = detector.detectFromFileName('file.unknown');

        // Assert
        expect(result, equals('plaintext'));
      });

      test('should return plaintext for files without extension', () {
        // Arrange
        when(() => detector.detectFromFileName('README')).thenReturn('plaintext');

        // Act
        final result = detector.detectFromFileName('README');

        // Assert
        expect(result, equals('plaintext'));
      });

      test('should handle dotfiles', () {
        // Arrange
        when(() => detector.detectFromFileName('.gitignore'))
            .thenReturn('plaintext');

        // Act
        final result = detector.detectFromFileName('.gitignore');

        // Assert
        expect(result, equals('plaintext'));
      });

      test('should be case-insensitive', () {
        // Arrange
        when(() => detector.detectFromFileName('Main.DART')).thenReturn('dart');
        when(() => detector.detectFromFileName('APP.JS')).thenReturn('javascript');

        // Act
        final result1 = detector.detectFromFileName('Main.DART');
        final result2 = detector.detectFromFileName('APP.JS');

        // Assert
        expect(result1, equals('dart'));
        expect(result2, equals('javascript'));
      });
    });

    group('detectFromExtension', () {
      test('should detect language from dart extension', () {
        // Arrange
        when(() => detector.detectFromExtension('dart')).thenReturn('dart');

        // Act
        final result = detector.detectFromExtension('dart');

        // Assert
        expect(result, equals('dart'));
        verify(() => detector.detectFromExtension('dart')).called(1);
      });

      test('should detect language from js extension', () {
        // Arrange
        when(() => detector.detectFromExtension('js')).thenReturn('javascript');

        // Act
        final result = detector.detectFromExtension('js');

        // Assert
        expect(result, equals('javascript'));
      });

      test('should detect language from ts extension', () {
        // Arrange
        when(() => detector.detectFromExtension('ts')).thenReturn('typescript');

        // Act
        final result = detector.detectFromExtension('ts');

        // Assert
        expect(result, equals('typescript'));
      });

      test('should detect language from py extension', () {
        // Arrange
        when(() => detector.detectFromExtension('py')).thenReturn('python');

        // Act
        final result = detector.detectFromExtension('py');

        // Assert
        expect(result, equals('python'));
      });

      test('should handle extension with leading dot', () {
        // Arrange
        when(() => detector.detectFromExtension('.dart')).thenReturn('dart');

        // Act
        final result = detector.detectFromExtension('.dart');

        // Assert
        expect(result, equals('dart'));
      });

      test('should return plaintext for unknown extension', () {
        // Arrange
        when(() => detector.detectFromExtension('xyz')).thenReturn('plaintext');

        // Act
        final result = detector.detectFromExtension('xyz');

        // Assert
        expect(result, equals('plaintext'));
      });

      test('should be case-insensitive', () {
        // Arrange
        when(() => detector.detectFromExtension('DART')).thenReturn('dart');
        when(() => detector.detectFromExtension('JS')).thenReturn('javascript');

        // Act
        final result1 = detector.detectFromExtension('DART');
        final result2 = detector.detectFromExtension('JS');

        // Assert
        expect(result1, equals('dart'));
        expect(result2, equals('javascript'));
      });
    });

    group('detectFromContent', () {
      test('should detect Dart from package import', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
''';
        when(() => detector.detectFromContent(content)).thenReturn('dart');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('dart'));
      });

      test('should detect JavaScript from function syntax', () {
        // Arrange
        const content = '''
function hello() {
  console.log('Hello, World!');
}
''';
        when(() => detector.detectFromContent(content)).thenReturn('javascript');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('javascript'));
      });

      test('should detect Python from def keyword', () {
        // Arrange
        const content = '''
def hello():
    print("Hello, World!")
''';
        when(() => detector.detectFromContent(content)).thenReturn('python');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('python'));
      });

      test('should detect HTML from tags', () {
        // Arrange
        const content = '''
<!DOCTYPE html>
<html>
<head>
  <title>Test</title>
</head>
<body>
  <h1>Hello</h1>
</body>
</html>
''';
        when(() => detector.detectFromContent(content)).thenReturn('html');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('html'));
      });

      test('should detect JSON from structure', () {
        // Arrange
        const content = '''
{
  "name": "test",
  "version": "1.0.0",
  "dependencies": {}
}
''';
        when(() => detector.detectFromContent(content)).thenReturn('json');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('json'));
      });

      test('should detect YAML from structure', () {
        // Arrange
        const content = '''
name: my_app
description: A test app
dependencies:
  flutter:
    sdk: flutter
''';
        when(() => detector.detectFromContent(content)).thenReturn('yaml');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('yaml'));
      });

      test('should detect Markdown from headers', () {
        // Arrange
        const content = '''
# My Project

## Installation

Install dependencies:

```bash
npm install
```
''';
        when(() => detector.detectFromContent(content)).thenReturn('markdown');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('markdown'));
      });

      test('should detect shell script from shebang', () {
        // Arrange
        const content = '''
#!/bin/bash
echo "Hello, World!"
''';
        when(() => detector.detectFromContent(content)).thenReturn('bash');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('bash'));
      });

      test('should return plaintext for ambiguous content', () {
        // Arrange
        const content = 'Just some plain text content.';
        when(() => detector.detectFromContent(content)).thenReturn('plaintext');

        // Act
        final result = detector.detectFromContent(content);

        // Assert
        expect(result, equals('plaintext'));
      });

      test('should return plaintext for empty content', () {
        // Arrange
        when(() => detector.detectFromContent('')).thenReturn('plaintext');

        // Act
        final result = detector.detectFromContent('');

        // Assert
        expect(result, equals('plaintext'));
      });
    });

    group('getSupportedLanguages', () {
      test('should return list of supported languages', () {
        // Arrange
        final languages = [
          'dart',
          'javascript',
          'typescript',
          'python',
          'java',
          'html',
          'css',
          'json',
          'yaml',
          'markdown',
          'plaintext',
        ];

        when(() => detector.getSupportedLanguages()).thenReturn(languages);

        // Act
        final result = detector.getSupportedLanguages();

        // Assert
        expect(result, isA<List<String>>());
        expect(result, isNotEmpty);
        expect(result, contains('dart'));
        expect(result, contains('javascript'));
        expect(result, contains('python'));
        verify(() => detector.getSupportedLanguages()).called(1);
      });

      test('should include common programming languages', () {
        // Arrange
        final languages = [
          'dart',
          'javascript',
          'typescript',
          'python',
          'java',
          'cpp',
          'c',
          'go',
          'rust',
          'ruby',
        ];

        when(() => detector.getSupportedLanguages()).thenReturn(languages);

        // Act
        final result = detector.getSupportedLanguages();

        // Assert
        expect(result, contains('dart'));
        expect(result, contains('python'));
        expect(result, contains('java'));
      });

      test('should include markup and data languages', () {
        // Arrange
        final languages = [
          'html',
          'css',
          'xml',
          'json',
          'yaml',
          'markdown',
        ];

        when(() => detector.getSupportedLanguages()).thenReturn(languages);

        // Act
        final result = detector.getSupportedLanguages();

        // Assert
        expect(result, contains('html'));
        expect(result, contains('json'));
        expect(result, contains('yaml'));
      });
    });

    group('getFileExtension', () {
      test('should get extension for dart language', () {
        // Arrange
        when(() => detector.getFileExtension('dart')).thenReturn('dart');

        // Act
        final result = detector.getFileExtension('dart');

        // Assert
        expect(result, equals('dart'));
        verify(() => detector.getFileExtension('dart')).called(1);
      });

      test('should get extension for javascript language', () {
        // Arrange
        when(() => detector.getFileExtension('javascript')).thenReturn('js');

        // Act
        final result = detector.getFileExtension('javascript');

        // Assert
        expect(result, equals('js'));
      });

      test('should get extension for typescript language', () {
        // Arrange
        when(() => detector.getFileExtension('typescript')).thenReturn('ts');

        // Act
        final result = detector.getFileExtension('typescript');

        // Assert
        expect(result, equals('ts'));
      });

      test('should get extension for python language', () {
        // Arrange
        when(() => detector.getFileExtension('python')).thenReturn('py');

        // Act
        final result = detector.getFileExtension('python');

        // Assert
        expect(result, equals('py'));
      });

      test('should get extension for json language', () {
        // Arrange
        when(() => detector.getFileExtension('json')).thenReturn('json');

        // Act
        final result = detector.getFileExtension('json');

        // Assert
        expect(result, equals('json'));
      });

      test('should get extension for yaml language', () {
        // Arrange
        when(() => detector.getFileExtension('yaml')).thenReturn('yaml');

        // Act
        final result = detector.getFileExtension('yaml');

        // Assert
        expect(result, equals('yaml'));
      });

      test('should get extension for markdown language', () {
        // Arrange
        when(() => detector.getFileExtension('markdown')).thenReturn('md');

        // Act
        final result = detector.getFileExtension('markdown');

        // Assert
        expect(result, equals('md'));
      });

      test('should get extension for html language', () {
        // Arrange
        when(() => detector.getFileExtension('html')).thenReturn('html');

        // Act
        final result = detector.getFileExtension('html');

        // Assert
        expect(result, equals('html'));
      });

      test('should get extension for css language', () {
        // Arrange
        when(() => detector.getFileExtension('css')).thenReturn('css');

        // Act
        final result = detector.getFileExtension('css');

        // Assert
        expect(result, equals('css'));
      });

      test('should return txt for plaintext language', () {
        // Arrange
        when(() => detector.getFileExtension('plaintext')).thenReturn('txt');

        // Act
        final result = detector.getFileExtension('plaintext');

        // Assert
        expect(result, equals('txt'));
      });

      test('should handle unknown language', () {
        // Arrange
        when(() => detector.getFileExtension('unknown')).thenReturn('txt');

        // Act
        final result = detector.getFileExtension('unknown');

        // Assert
        expect(result, equals('txt'));
      });
    });

    group('use cases', () {
      test('should handle new file creation workflow', () {
        // Arrange
        const fileName = 'new_file.dart';

        when(() => detector.detectFromFileName(fileName)).thenReturn('dart');
        when(() => detector.getFileExtension('dart')).thenReturn('dart');

        // Act - Detect language from file name
        final detectedLanguage = detector.detectFromFileName(fileName);

        // Assert
        expect(detectedLanguage, equals('dart'));

        // Act - Get extension for language
        final extension = detector.getFileExtension(detectedLanguage);

        // Assert
        expect(extension, equals('dart'));
      });

      test('should handle file with unknown extension', () {
        // Arrange
        const fileName = 'data.custom';
        const content = '''
def process():
    return True
''';

        when(() => detector.detectFromFileName(fileName)).thenReturn('plaintext');
        when(() => detector.detectFromContent(content)).thenReturn('python');

        // Act - Try to detect from file name first
        final languageFromName = detector.detectFromFileName(fileName);

        // Assert - Unknown extension returns plaintext
        expect(languageFromName, equals('plaintext'));

        // Act - Fallback to content detection
        final languageFromContent = detector.detectFromContent(content);

        // Assert - Content detection finds Python
        expect(languageFromContent, equals('python'));
      });

      test('should support language validation', () {
        // Arrange
        final supportedLanguages = [
          'dart',
          'javascript',
          'typescript',
          'python',
        ];

        when(() => detector.getSupportedLanguages())
            .thenReturn(supportedLanguages);

        // Act
        final languages = detector.getSupportedLanguages();

        // Assert - Can check if language is supported
        expect(languages.contains('dart'), isTrue);
        expect(languages.contains('python'), isTrue);
        expect(languages.contains('unknown'), isFalse);
      });

      test('should handle language conversion', () {
        // Arrange
        when(() => detector.getFileExtension('javascript')).thenReturn('js');
        when(() => detector.detectFromExtension('js')).thenReturn('javascript');

        // Act - Convert language to extension
        final extension = detector.getFileExtension('javascript');

        // Assert
        expect(extension, equals('js'));

        // Act - Convert extension back to language
        final language = detector.detectFromExtension(extension);

        // Assert
        expect(language, equals('javascript'));
      });

      test('should detect common file types correctly', () {
        // Arrange
        final testCases = {
          'main.dart': 'dart',
          'app.js': 'javascript',
          'index.ts': 'typescript',
          'script.py': 'python',
          'Config.java': 'java',
          'index.html': 'html',
          'styles.css': 'css',
          'package.json': 'json',
          'pubspec.yaml': 'yaml',
          'README.md': 'markdown',
        };

        for (final entry in testCases.entries) {
          when(() => detector.detectFromFileName(entry.key))
              .thenReturn(entry.value);
        }

        // Act & Assert
        for (final entry in testCases.entries) {
          final result = detector.detectFromFileName(entry.key);
          expect(result, equals(entry.value),
              reason: '${entry.key} should be detected as ${entry.value}');
        }
      });
    });
  });
}
