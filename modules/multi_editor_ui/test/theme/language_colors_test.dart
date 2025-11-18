import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_editor_ui/src/theme/colors/language_colors.dart';
import 'package:multi_editor_ui/src/theme/tokens/primitive/color_primitives.dart';

void main() {
  group('ProgrammingLanguage', () {
    group('enum values', () {
      test('should define Dart', () {
        // Arrange & Act
        final language = ProgrammingLanguage.dart;

        // Assert
        expect(language.color, equals(ColorPrimitives.dartBlue));
        expect(language.displayName, equals('Dart'));
      });

      test('should define JavaScript', () {
        // Arrange & Act
        final language = ProgrammingLanguage.javaScript;

        // Assert
        expect(language.color, equals(ColorPrimitives.javaScriptYellow));
        expect(language.displayName, equals('JavaScript'));
      });

      test('should define TypeScript', () {
        // Arrange & Act
        final language = ProgrammingLanguage.typeScript;

        // Assert
        expect(language.color, equals(ColorPrimitives.typeScriptBlue));
        expect(language.displayName, equals('TypeScript'));
      });

      test('should define Python', () {
        // Arrange & Act
        final language = ProgrammingLanguage.python;

        // Assert
        expect(language.color, equals(ColorPrimitives.pythonGreen));
        expect(language.displayName, equals('Python'));
      });

      test('should define JSON', () {
        // Arrange & Act
        final language = ProgrammingLanguage.json;

        // Assert
        expect(language.color, equals(ColorPrimitives.orange50));
        expect(language.displayName, equals('JSON'));
      });

      test('should define Markdown', () {
        // Arrange & Act
        final language = ProgrammingLanguage.markdown;

        // Assert
        expect(language.color, equals(ColorPrimitives.purple50));
        expect(language.displayName, equals('Markdown'));
      });

      test('should define HTML', () {
        // Arrange & Act
        final language = ProgrammingLanguage.html;

        // Assert
        expect(language.color, equals(ColorPrimitives.htmlOrange));
        expect(language.displayName, equals('HTML'));
      });

      test('should define CSS', () {
        // Arrange & Act
        final language = ProgrammingLanguage.css;

        // Assert
        expect(language.color, equals(ColorPrimitives.cssBlue));
        expect(language.displayName, equals('CSS'));
      });

      test('should define SCSS', () {
        // Arrange & Act
        final language = ProgrammingLanguage.scss;

        // Assert
        expect(language.color, equals(ColorPrimitives.cssBlue));
        expect(language.displayName, equals('SCSS'));
      });

      test('should define YAML', () {
        // Arrange & Act
        final language = ProgrammingLanguage.yaml;

        // Assert
        expect(language.color, equals(ColorPrimitives.gray60));
        expect(language.displayName, equals('YAML'));
      });

      test('should define YML', () {
        // Arrange & Act
        final language = ProgrammingLanguage.yml;

        // Assert
        expect(language.color, equals(ColorPrimitives.gray60));
        expect(language.displayName, equals('YML'));
      });

      test('should define unknown', () {
        // Arrange & Act
        final language = ProgrammingLanguage.unknown;

        // Assert
        expect(language.color, equals(ColorPrimitives.gray60));
        expect(language.displayName, equals('Unknown'));
      });
    });

    group('fromString', () {
      test('should parse dart', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('dart');

        // Assert
        expect(language, equals(ProgrammingLanguage.dart));
      });

      test('should parse javascript', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('javascript');

        // Assert
        expect(language, equals(ProgrammingLanguage.javaScript));
      });

      test('should parse typescript', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('typescript');

        // Assert
        expect(language, equals(ProgrammingLanguage.typeScript));
      });

      test('should parse python', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('python');

        // Assert
        expect(language, equals(ProgrammingLanguage.python));
      });

      test('should be case insensitive', () {
        // Arrange & Act
        final lower = ProgrammingLanguage.fromString('dart');
        final upper = ProgrammingLanguage.fromString('DART');
        final mixed = ProgrammingLanguage.fromString('DaRt');

        // Assert
        expect(lower, equals(ProgrammingLanguage.dart));
        expect(upper, equals(ProgrammingLanguage.dart));
        expect(mixed, equals(ProgrammingLanguage.dart));
      });

      test('should return unknown for null', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString(null);

        // Assert
        expect(language, equals(ProgrammingLanguage.unknown));
      });

      test('should return unknown for unrecognized language', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('fortran');

        // Assert
        expect(language, equals(ProgrammingLanguage.unknown));
      });

      test('should parse all supported languages', () {
        // Arrange
        final languages = [
          'dart',
          'javascript',
          'typescript',
          'python',
          'json',
          'markdown',
          'html',
          'css',
          'scss',
          'yaml',
          'yml',
        ];

        // Act & Assert
        for (final lang in languages) {
          final parsed = ProgrammingLanguage.fromString(lang);
          expect(parsed, isNot(equals(ProgrammingLanguage.unknown)),
              reason: '$lang should be recognized');
        }
      });
    });

    group('getIcon', () {
      test('should return code icon for programming languages', () {
        // Arrange
        final languages = [
          ProgrammingLanguage.dart,
          ProgrammingLanguage.javaScript,
          ProgrammingLanguage.typeScript,
          ProgrammingLanguage.python,
        ];

        // Act & Assert
        for (final lang in languages) {
          expect(lang.getIcon(), equals(Icons.code),
              reason: '${lang.displayName} should use code icon');
        }
      });

      test('should return data_object icon for JSON', () {
        // Arrange & Act
        final icon = ProgrammingLanguage.json.getIcon();

        // Assert
        expect(icon, equals(Icons.data_object));
      });

      test('should return description icon for Markdown', () {
        // Arrange & Act
        final icon = ProgrammingLanguage.markdown.getIcon();

        // Assert
        expect(icon, equals(Icons.description));
      });

      test('should return html icon for HTML', () {
        // Arrange & Act
        final icon = ProgrammingLanguage.html.getIcon();

        // Assert
        expect(icon, equals(Icons.html));
      });

      test('should return css icon for CSS and SCSS', () {
        // Arrange & Act
        final cssIcon = ProgrammingLanguage.css.getIcon();
        final scssIcon = ProgrammingLanguage.scss.getIcon();

        // Assert
        expect(cssIcon, equals(Icons.css));
        expect(scssIcon, equals(Icons.css));
      });

      test('should return settings icon for YAML', () {
        // Arrange & Act
        final yamlIcon = ProgrammingLanguage.yaml.getIcon();
        final ymlIcon = ProgrammingLanguage.yml.getIcon();

        // Assert
        expect(yamlIcon, equals(Icons.settings));
        expect(ymlIcon, equals(Icons.settings));
      });

      test('should return insert_drive_file icon for unknown', () {
        // Arrange & Act
        final icon = ProgrammingLanguage.unknown.getIcon();

        // Assert
        expect(icon, equals(Icons.insert_drive_file));
      });
    });

    group('color associations', () {
      test('should use blue for Dart', () {
        // Arrange & Act
        final color = ProgrammingLanguage.dart.color;

        // Assert
        expect(color.blue, greaterThan(color.red));
        expect(color.blue, greaterThan(color.green));
      });

      test('should use yellow for JavaScript', () {
        // Arrange & Act
        final color = ProgrammingLanguage.javaScript.color;

        // Assert
        expect(color.red, greaterThan(200));
        expect(color.green, greaterThan(200));
      });

      test('should use blue for TypeScript', () {
        // Arrange & Act
        final color = ProgrammingLanguage.typeScript.color;

        // Assert
        expect(color.blue, greaterThan(color.red));
      });

      test('should use green-blue for Python', () {
        // Arrange & Act
        final color = ProgrammingLanguage.python.color;

        // Assert
        expect(color.blue, greaterThan(color.red));
      });

      test('should use orange for HTML', () {
        // Arrange & Act
        final color = ProgrammingLanguage.html.color;

        // Assert
        expect(color.red, greaterThan(color.blue));
      });

      test('should use gray for YAML', () {
        // Arrange & Act
        final color = ProgrammingLanguage.yaml.color;

        // Assert
        expect(color, equals(ColorPrimitives.gray60));
      });

      test('should use same color for CSS variants', () {
        // Arrange & Act
        final cssColor = ProgrammingLanguage.css.color;
        final scssColor = ProgrammingLanguage.scss.color;

        // Assert
        expect(cssColor, equals(scssColor));
      });

      test('should use same color for YAML variants', () {
        // Arrange & Act
        final yamlColor = ProgrammingLanguage.yaml.color;
        final ymlColor = ProgrammingLanguage.yml.color;

        // Assert
        expect(yamlColor, equals(ymlColor));
      });
    });

    group('display names', () {
      test('should have human-readable display names', () {
        // Arrange
        final languages = ProgrammingLanguage.values;

        // Act & Assert
        for (final lang in languages) {
          expect(lang.displayName.isNotEmpty, isTrue,
              reason: 'Display name should not be empty');
          expect(lang.displayName[0], equals(lang.displayName[0].toUpperCase()),
              reason: 'Display name should be capitalized');
        }
      });

      test('should have proper casing for JavaScript', () {
        // Arrange & Act
        final displayName = ProgrammingLanguage.javaScript.displayName;

        // Assert
        expect(displayName, equals('JavaScript'));
        expect(displayName, isNot(equals('Javascript')));
      });

      test('should have proper casing for TypeScript', () {
        // Arrange & Act
        final displayName = ProgrammingLanguage.typeScript.displayName;

        // Assert
        expect(displayName, equals('TypeScript'));
        expect(displayName, isNot(equals('Typescript')));
      });
    });

    group('real-world use cases', () {
      test('should work with file extensions', () {
        // Arrange
        final extensions = {
          'dart': ProgrammingLanguage.dart,
          'js': ProgrammingLanguage.javaScript,
          'ts': ProgrammingLanguage.typeScript,
          'py': ProgrammingLanguage.python,
          'json': ProgrammingLanguage.json,
          'md': ProgrammingLanguage.markdown,
          'html': ProgrammingLanguage.html,
          'css': ProgrammingLanguage.css,
          'scss': ProgrammingLanguage.scss,
          'yaml': ProgrammingLanguage.yaml,
          'yml': ProgrammingLanguage.yml,
        };

        // Act & Assert
        for (final entry in extensions.entries) {
          final language = ProgrammingLanguage.fromString(entry.key);
          expect(language, equals(entry.value),
              reason: 'Extension ${entry.key} should map to ${entry.value}');
        }
      });

      test('should provide color for file tree icons', () {
        // Arrange
        final dartFile = ProgrammingLanguage.fromString('dart');

        // Act
        final color = dartFile.color;
        final icon = dartFile.getIcon();

        // Assert
        expect(color, isNotNull);
        expect(icon, isNotNull);
      });

      test('should provide display name for tooltips', () {
        // Arrange
        final language = ProgrammingLanguage.fromString('typescript');

        // Act
        final tooltip = 'File type: ${language.displayName}';

        // Assert
        expect(tooltip, equals('File type: TypeScript'));
      });

      test('should handle editor tab colors', () {
        // Arrange
        final languages = [
          ProgrammingLanguage.dart,
          ProgrammingLanguage.javaScript,
          ProgrammingLanguage.typeScript,
        ];

        // Act & Assert
        for (final lang in languages) {
          final color = lang.color;
          expect(color, isNotNull);
          expect(color, isNot(equals(Colors.transparent)));
        }
      });

      test('should support syntax highlighting themes', () {
        // Arrange
        final language = ProgrammingLanguage.fromString('dart');

        // Act
        final accentColor = language.color;

        // Assert
        expect(accentColor, equals(ColorPrimitives.dartBlue));
      });
    });

    group('enum completeness', () {
      test('should cover common web languages', () {
        // Arrange
        final webLanguages = [
          'html',
          'css',
          'scss',
          'javascript',
          'typescript',
        ];

        // Act & Assert
        for (final lang in webLanguages) {
          final parsed = ProgrammingLanguage.fromString(lang);
          expect(parsed, isNot(equals(ProgrammingLanguage.unknown)),
              reason: 'Web language $lang should be supported');
        }
      });

      test('should cover common config formats', () {
        // Arrange
        final configFormats = ['json', 'yaml', 'yml'];

        // Act & Assert
        for (final format in configFormats) {
          final parsed = ProgrammingLanguage.fromString(format);
          expect(parsed, isNot(equals(ProgrammingLanguage.unknown)),
              reason: 'Config format $format should be supported');
        }
      });

      test('should cover documentation formats', () {
        // Arrange
        final docFormats = ['markdown'];

        // Act & Assert
        for (final format in docFormats) {
          final parsed = ProgrammingLanguage.fromString(format);
          expect(parsed, isNot(equals(ProgrammingLanguage.unknown)),
              reason: 'Doc format $format should be supported');
        }
      });
    });

    group('edge cases', () {
      test('should handle empty string', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('');

        // Assert
        expect(language, equals(ProgrammingLanguage.unknown));
      });

      test('should handle whitespace', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('   ');

        // Assert
        expect(language, equals(ProgrammingLanguage.unknown));
      });

      test('should handle special characters', () {
        // Arrange & Act
        final language = ProgrammingLanguage.fromString('c++');

        // Assert
        expect(language, equals(ProgrammingLanguage.unknown));
      });
    });

    group('icon consistency', () {
      test('should use same icon for related languages', () {
        // Arrange
        final jsIcon = ProgrammingLanguage.javaScript.getIcon();
        final tsIcon = ProgrammingLanguage.typeScript.getIcon();
        final dartIcon = ProgrammingLanguage.dart.getIcon();
        final pythonIcon = ProgrammingLanguage.python.getIcon();

        // Assert - All programming languages use code icon
        expect(jsIcon, equals(Icons.code));
        expect(tsIcon, equals(Icons.code));
        expect(dartIcon, equals(Icons.code));
        expect(pythonIcon, equals(Icons.code));
      });

      test('should use distinct icons for different file types', () {
        // Arrange
        final codeIcon = ProgrammingLanguage.dart.getIcon();
        final dataIcon = ProgrammingLanguage.json.getIcon();
        final docIcon = ProgrammingLanguage.markdown.getIcon();
        final configIcon = ProgrammingLanguage.yaml.getIcon();

        // Assert - Different file types should have different icons
        expect(codeIcon, isNot(equals(dataIcon)));
        expect(dataIcon, isNot(equals(docIcon)));
        expect(docIcon, isNot(equals(configIcon)));
      });
    });

    group('color visibility', () {
      test('should use visible colors', () {
        // Arrange
        final languages = ProgrammingLanguage.values;

        // Act & Assert
        for (final lang in languages) {
          final color = lang.color;
          expect(color.alpha, equals(255),
              reason: '${lang.displayName} color should be fully opaque');
        }
      });

      test('should use distinct colors for main languages', () {
        // Arrange
        final dart = ProgrammingLanguage.dart.color;
        final js = ProgrammingLanguage.javaScript.color;
        final python = ProgrammingLanguage.python.color;

        // Assert - Main languages should have distinct colors
        expect(dart, isNot(equals(js)));
        expect(js, isNot(equals(python)));
        expect(python, isNot(equals(dart)));
      });
    });
  });
}
