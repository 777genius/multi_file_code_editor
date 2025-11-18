import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multi_editor_core/src/domain/failures/domain_failure.dart';
import 'package:multi_editor_core/src/domain/value_objects/file_name.dart';
import 'package:multi_editor_core/src/ports/services/validation_service.dart';

class MockValidationService extends Mock implements ValidationService {}

void main() {
  group('ValidationService', () {
    late MockValidationService service;

    setUp(() {
      service = MockValidationService();
    });

    group('validateFileName', () {
      test('should validate valid file name', () {
        // Arrange
        when(() => service.validateFileName('main.dart'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileName('main.dart');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => service.validateFileName('main.dart')).called(1);
      });

      test('should validate file name with underscores', () {
        // Arrange
        when(() => service.validateFileName('my_file.dart'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileName('my_file.dart');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate file name with hyphens', () {
        // Arrange
        when(() => service.validateFileName('my-file.dart'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileName('my-file.dart');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate file name with numbers', () {
        // Arrange
        when(() => service.validateFileName('file123.dart'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileName('file123.dart');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate dotfile', () {
        // Arrange
        when(() => service.validateFileName('.gitignore'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileName('.gitignore');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should reject empty file name', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'fileName',
          reason: 'File name cannot be empty',
          value: '',
        );

        when(() => service.validateFileName('')).thenReturn(Left(failure));

        // Act
        final result = service.validateFileName('');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('fileName'));
        expect(result.left.reason, contains('empty'));
      });

      test('should reject file name with spaces', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'fileName',
          reason: 'File name contains invalid characters',
          value: 'my file.txt',
        );

        when(() => service.validateFileName('my file.txt'))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFileName('my file.txt');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('invalid characters'));
      });

      test('should reject file name with slashes', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'fileName',
          reason: 'File name contains invalid characters',
          value: 'folder/file.txt',
        );

        when(() => service.validateFileName('folder/file.txt'))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFileName('folder/file.txt');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('invalid characters'));
      });

      test('should reject file name with special characters', () {
        // Arrange
        final invalidNames = [
          'file<name>.txt',
          'file>name.txt',
          'file:name.txt',
          'file|name.txt',
          'file?name.txt',
          'file*name.txt',
        ];

        for (final name in invalidNames) {
          final failure = DomainFailure.validationError(
            field: 'fileName',
            reason: 'File name contains invalid characters',
            value: name,
          );

          when(() => service.validateFileName(name)).thenReturn(Left(failure));
        }

        // Act & Assert
        for (final name in invalidNames) {
          final result = service.validateFileName(name);
          expect(result.isLeft, isTrue,
              reason: '$name should be invalid');
        }
      });

      test('should reject file name exceeding max length', () {
        // Arrange
        final longName = 'a' * 256 + '.txt';
        final failure = DomainFailure.validationError(
          field: 'fileName',
          reason: 'File name exceeds maximum length',
          value: longName,
        );

        when(() => service.validateFileName(longName))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFileName(longName);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('maximum length'));
      });

      test('should reject reserved Windows names', () {
        // Arrange
        final reservedNames = ['CON', 'PRN', 'AUX', 'NUL', 'COM1', 'LPT1'];

        for (final name in reservedNames) {
          final failure = DomainFailure.validationError(
            field: 'fileName',
            reason: 'File name is reserved by the system',
            value: name,
          );

          when(() => service.validateFileName(name)).thenReturn(Left(failure));
        }

        // Act & Assert
        for (final name in reservedNames) {
          final result = service.validateFileName(name);
          expect(result.isLeft, isTrue,
              reason: '$name should be reserved');
        }
      });

      test('should reject just a dot', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'fileName',
          reason: 'File name cannot be just a dot',
          value: '.',
        );

        when(() => service.validateFileName('.')).thenReturn(Left(failure));

        // Act
        final result = service.validateFileName('.');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('just a dot'));
      });
    });

    group('validateFilePath', () {
      test('should validate valid file path', () {
        // Arrange
        when(() => service.validateFilePath('/home/user/file.txt'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFilePath('/home/user/file.txt');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => service.validateFilePath('/home/user/file.txt')).called(1);
      });

      test('should validate relative path', () {
        // Arrange
        when(() => service.validateFilePath('src/main.dart'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFilePath('src/main.dart');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate path with multiple directories', () {
        // Arrange
        when(() => service.validateFilePath('/home/user/projects/app/main.dart'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFilePath('/home/user/projects/app/main.dart');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should reject empty path', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'filePath',
          reason: 'File path cannot be empty',
          value: '',
        );

        when(() => service.validateFilePath('')).thenReturn(Left(failure));

        // Act
        final result = service.validateFilePath('');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('filePath'));
      });

      test('should reject path with invalid characters', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'filePath',
          reason: 'File path contains invalid characters',
          value: '/path/with<invalid>chars',
        );

        when(() => service.validateFilePath('/path/with<invalid>chars'))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFilePath('/path/with<invalid>chars');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('invalid characters'));
      });

      test('should reject path exceeding max length', () {
        // Arrange
        final longPath = '/' + ('a' * 300) + '/file.txt';
        final failure = DomainFailure.validationError(
          field: 'filePath',
          reason: 'File path exceeds maximum length',
          value: longPath,
        );

        when(() => service.validateFilePath(longPath))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFilePath(longPath);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('maximum length'));
      });
    });

    group('validateFolderName', () {
      test('should validate valid folder name', () {
        // Arrange
        when(() => service.validateFolderName('src'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFolderName('src');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => service.validateFolderName('src')).called(1);
      });

      test('should validate folder name with underscores', () {
        // Arrange
        when(() => service.validateFolderName('my_folder'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFolderName('my_folder');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate folder name with hyphens', () {
        // Arrange
        when(() => service.validateFolderName('my-folder'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFolderName('my-folder');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should reject empty folder name', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'folderName',
          reason: 'Folder name cannot be empty',
          value: '',
        );

        when(() => service.validateFolderName('')).thenReturn(Left(failure));

        // Act
        final result = service.validateFolderName('');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('folderName'));
      });

      test('should reject folder name with spaces', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'folderName',
          reason: 'Folder name contains invalid characters',
          value: 'my folder',
        );

        when(() => service.validateFolderName('my folder'))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFolderName('my folder');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('invalid characters'));
      });

      test('should reject folder name with slashes', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'folderName',
          reason: 'Folder name contains invalid characters',
          value: 'folder/subfolder',
        );

        when(() => service.validateFolderName('folder/subfolder'))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFolderName('folder/subfolder');

        // Assert
        expect(result.isLeft, isTrue);
      });
    });

    group('validateProjectName', () {
      test('should validate valid project name', () {
        // Arrange
        when(() => service.validateProjectName('My Project'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateProjectName('My Project');

        // Assert
        expect(result.isRight, isTrue);
        verify(() => service.validateProjectName('My Project')).called(1);
      });

      test('should validate project name with numbers', () {
        // Arrange
        when(() => service.validateProjectName('Project 123'))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateProjectName('Project 123');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should reject empty project name', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'projectName',
          reason: 'Project name cannot be empty',
          value: '',
        );

        when(() => service.validateProjectName('')).thenReturn(Left(failure));

        // Act
        final result = service.validateProjectName('');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.field, equals('projectName'));
      });

      test('should reject project name exceeding max length', () {
        // Arrange
        final longName = 'a' * 101;
        final failure = DomainFailure.validationError(
          field: 'projectName',
          reason: 'Project name exceeds maximum length',
          value: longName,
        );

        when(() => service.validateProjectName(longName))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateProjectName(longName);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('maximum length'));
      });

      test('should reject project name with special characters', () {
        // Arrange
        final failure = DomainFailure.validationError(
          field: 'projectName',
          reason: 'Project name contains invalid characters',
          value: 'Project<Test>',
        );

        when(() => service.validateProjectName('Project<Test>'))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateProjectName('Project<Test>');

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('invalid characters'));
      });
    });

    group('validateFileContent', () {
      test('should validate valid file content', () {
        // Arrange
        const content = 'void main() {}';
        when(() => service.validateFileContent(content))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileContent(content);

        // Assert
        expect(result.isRight, isTrue);
        verify(() => service.validateFileContent(content)).called(1);
      });

      test('should validate empty content', () {
        // Arrange
        when(() => service.validateFileContent(''))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileContent('');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate multiline content', () {
        // Arrange
        const content = '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
''';
        when(() => service.validateFileContent(content))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileContent(content);

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should validate content with special characters', () {
        // Arrange
        const content = 'String text = "Hello, <World>!";';
        when(() => service.validateFileContent(content))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateFileContent(content);

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should reject content exceeding max size', () {
        // Arrange
        final largeContent = 'a' * 10000000; // 10MB
        final failure = DomainFailure.validationError(
          field: 'content',
          reason: 'File content exceeds maximum size',
        );

        when(() => service.validateFileContent(largeContent))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFileContent(largeContent);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('maximum size'));
      });

      test('should reject content with null characters', () {
        // Arrange
        final content = 'text\x00content';
        final failure = DomainFailure.validationError(
          field: 'content',
          reason: 'File content contains null characters',
        );

        when(() => service.validateFileContent(content))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFileContent(content);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('null characters'));
      });
    });

    group('isValidLanguage', () {
      test('should validate dart language', () {
        // Arrange
        when(() => service.isValidLanguage('dart')).thenReturn(true);

        // Act
        final result = service.isValidLanguage('dart');

        // Assert
        expect(result, isTrue);
        verify(() => service.isValidLanguage('dart')).called(1);
      });

      test('should validate javascript language', () {
        // Arrange
        when(() => service.isValidLanguage('javascript')).thenReturn(true);

        // Act
        final result = service.isValidLanguage('javascript');

        // Assert
        expect(result, isTrue);
      });

      test('should validate python language', () {
        // Arrange
        when(() => service.isValidLanguage('python')).thenReturn(true);

        // Act
        final result = service.isValidLanguage('python');

        // Assert
        expect(result, isTrue);
      });

      test('should validate json language', () {
        // Arrange
        when(() => service.isValidLanguage('json')).thenReturn(true);

        // Act
        final result = service.isValidLanguage('json');

        // Assert
        expect(result, isTrue);
      });

      test('should validate plaintext language', () {
        // Arrange
        when(() => service.isValidLanguage('plaintext')).thenReturn(true);

        // Act
        final result = service.isValidLanguage('plaintext');

        // Assert
        expect(result, isTrue);
      });

      test('should reject unknown language', () {
        // Arrange
        when(() => service.isValidLanguage('unknown')).thenReturn(false);

        // Act
        final result = service.isValidLanguage('unknown');

        // Assert
        expect(result, isFalse);
      });

      test('should reject empty language', () {
        // Arrange
        when(() => service.isValidLanguage('')).thenReturn(false);

        // Act
        final result = service.isValidLanguage('');

        // Assert
        expect(result, isFalse);
      });
    });

    group('hasValidExtension', () {
      test('should validate file with dart extension', () {
        // Arrange
        when(() => service.hasValidExtension('main.dart')).thenReturn(true);

        // Act
        final result = service.hasValidExtension('main.dart');

        // Assert
        expect(result, isTrue);
        verify(() => service.hasValidExtension('main.dart')).called(1);
      });

      test('should validate file with js extension', () {
        // Arrange
        when(() => service.hasValidExtension('app.js')).thenReturn(true);

        // Act
        final result = service.hasValidExtension('app.js');

        // Assert
        expect(result, isTrue);
      });

      test('should validate file with json extension', () {
        // Arrange
        when(() => service.hasValidExtension('config.json')).thenReturn(true);

        // Act
        final result = service.hasValidExtension('config.json');

        // Assert
        expect(result, isTrue);
      });

      test('should validate file with multiple extensions', () {
        // Arrange
        when(() => service.hasValidExtension('archive.tar.gz')).thenReturn(true);

        // Act
        final result = service.hasValidExtension('archive.tar.gz');

        // Assert
        expect(result, isTrue);
      });

      test('should allow files without extension', () {
        // Arrange
        when(() => service.hasValidExtension('README')).thenReturn(true);

        // Act
        final result = service.hasValidExtension('README');

        // Assert
        expect(result, isTrue);
      });

      test('should allow dotfiles', () {
        // Arrange
        when(() => service.hasValidExtension('.gitignore')).thenReturn(true);

        // Act
        final result = service.hasValidExtension('.gitignore');

        // Assert
        expect(result, isTrue);
      });

      test('should reject file with invalid extension format', () {
        // Arrange
        when(() => service.hasValidExtension('file.')).thenReturn(false);

        // Act
        final result = service.hasValidExtension('file.');

        // Assert
        expect(result, isFalse);
      });
    });

    group('use cases', () {
      test('should validate complete file creation', () {
        // Arrange
        const fileName = 'main.dart';
        const content = 'void main() {}';
        const language = 'dart';

        when(() => service.validateFileName(fileName))
            .thenReturn(const Right(null));
        when(() => service.validateFileContent(content))
            .thenReturn(const Right(null));
        when(() => service.isValidLanguage(language)).thenReturn(true);
        when(() => service.hasValidExtension(fileName)).thenReturn(true);

        // Act - Validate file name
        final nameResult = service.validateFileName(fileName);

        // Assert
        expect(nameResult.isRight, isTrue);

        // Act - Validate content
        final contentResult = service.validateFileContent(content);

        // Assert
        expect(contentResult.isRight, isTrue);

        // Act - Validate language
        final languageValid = service.isValidLanguage(language);

        // Assert
        expect(languageValid, isTrue);

        // Act - Validate extension
        final extensionValid = service.hasValidExtension(fileName);

        // Assert
        expect(extensionValid, isTrue);
      });

      test('should validate folder structure', () {
        // Arrange
        const folderName = 'src';
        const subfolderName = 'components';

        when(() => service.validateFolderName(folderName))
            .thenReturn(const Right(null));
        when(() => service.validateFolderName(subfolderName))
            .thenReturn(const Right(null));

        // Act - Validate folder names
        final folder1Result = service.validateFolderName(folderName);
        final folder2Result = service.validateFolderName(subfolderName);

        // Assert
        expect(folder1Result.isRight, isTrue);
        expect(folder2Result.isRight, isTrue);
      });

      test('should validate project setup', () {
        // Arrange
        const projectName = 'My Flutter App';

        when(() => service.validateProjectName(projectName))
            .thenReturn(const Right(null));

        // Act
        final result = service.validateProjectName(projectName);

        // Assert
        expect(result.isRight, isTrue);
      });

      test('should reject invalid file creation attempt', () {
        // Arrange
        const invalidFileName = 'invalid/file.txt';
        final failure = DomainFailure.validationError(
          field: 'fileName',
          reason: 'File name contains invalid characters',
          value: invalidFileName,
        );

        when(() => service.validateFileName(invalidFileName))
            .thenReturn(Left(failure));

        // Act
        final result = service.validateFileName(invalidFileName);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left.reason, contains('invalid characters'));
      });

      test('should validate batch file operations', () {
        // Arrange
        final validFileNames = [
          'file1.dart',
          'file2.js',
          'file3.py',
        ];

        for (final name in validFileNames) {
          when(() => service.validateFileName(name))
              .thenReturn(const Right(null));
        }

        // Act & Assert
        for (final name in validFileNames) {
          final result = service.validateFileName(name);
          expect(result.isRight, isTrue,
              reason: '$name should be valid');
        }
      });
    });
  });
}

extension on Either<DomainFailure, void> {
  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
  DomainFailure get left => fold((l) => l, (_) => throw StateError('Right'));
}
