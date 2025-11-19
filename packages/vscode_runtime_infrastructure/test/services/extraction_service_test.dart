import 'dart:io';
import 'package:test/test.dart';
import 'package:archive/archive_io.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import 'package:vscode_runtime_infrastructure/src/services/extraction_service.dart';
import 'package:path/path.dart' as path;

void main() {
  late ExtractionService service;
  late Directory tempDir;

  setUp(() {
    service = ExtractionService();
  });

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('extraction_service_test_');
  });

  tearDownAll() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('ExtractionService', () {
    group('detectFormat', () {
      test('should detect zip format', () {
        expect(service.detectFormat('file.zip'), equals('zip'));
        expect(service.detectFormat('FILE.ZIP'), equals('zip'));
      });

      test('should detect tar.gz format', () {
        expect(service.detectFormat('file.tar.gz'), equals('tar.gz'));
        expect(service.detectFormat('file.tgz'), equals('tar.gz'));
      });

      test('should detect tar.xz format', () {
        expect(service.detectFormat('file.tar.xz'), equals('tar.xz'));
      });

      test('should detect tar.bz2 format', () {
        expect(service.detectFormat('file.tar.bz2'), equals('tar.bz2'));
      });

      test('should return unknown for unsupported format', () {
        expect(service.detectFormat('file.rar'), equals('unknown'));
        expect(service.detectFormat('file.7z'), equals('unknown'));
        expect(service.detectFormat('file.txt'), equals('unknown'));
      });
    });

    group('isFormatSupported', () {
      test('should return true for supported formats', () {
        expect(service.isFormatSupported('file.zip'), isTrue);
        expect(service.isFormatSupported('file.tar.gz'), isTrue);
        expect(service.isFormatSupported('file.tgz'), isTrue);
        expect(service.isFormatSupported('file.tar.xz'), isTrue);
        expect(service.isFormatSupported('file.tar.bz2'), isTrue);
      });

      test('should return false for unsupported formats', () {
        expect(service.isFormatSupported('file.rar'), isFalse);
        expect(service.isFormatSupported('file.7z'), isFalse);
        expect(service.isFormatSupported('file.txt'), isFalse);
      });
    });

    group('extract - ZIP', () {
      late File zipFile;
      late String targetDir;

      setUp(() async {
        // Create a zip archive for testing
        final archive = Archive();

        // Add file
        final fileContent = 'Hello, World!'.codeUnits;
        archive.addFile(ArchiveFile('test.txt', fileContent.length, fileContent));

        // Add directory
        archive.addFile(ArchiveFile('subdir/', 0, []));

        // Add file in directory
        final nestedContent = 'Nested file'.codeUnits;
        archive.addFile(ArchiveFile('subdir/nested.txt', nestedContent.length, nestedContent));

        // Write zip file
        zipFile = File('${tempDir.path}/test.zip');
        final zipEncoder = ZipEncoder();
        final zipData = zipEncoder.encode(archive);
        await zipFile.writeAsBytes(zipData!);

        targetDir = '${tempDir.path}/extracted_zip';
      });

      tearDown() async {
        if (await zipFile.exists()) await zipFile.delete();
        final dir = Directory(targetDir);
        if (await dir.exists()) await dir.delete(recursive: true);
      });

      test('should extract zip archive successfully', () async {
        // Act
        final result = await service.extract(
          archiveFile: zipFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isRight(), isTrue);

        result.fold(
          (_) => fail('Should succeed'),
          (extractedDir) async {
            expect(await extractedDir.exists(), isTrue);

            // Verify extracted files
            final testFile = File(path.join(targetDir, 'test.txt'));
            expect(await testFile.exists(), isTrue);
            expect(await testFile.readAsString(), equals('Hello, World!'));

            final nestedFile = File(path.join(targetDir, 'subdir', 'nested.txt'));
            expect(await nestedFile.exists(), isTrue);
            expect(await nestedFile.readAsString(), equals('Nested file'));
          },
        );
      });

      test('should report progress during extraction', () async {
        // Arrange
        final progressReports = <double>[];

        // Act
        final result = await service.extract(
          archiveFile: zipFile,
          targetDirectory: targetDir,
          onProgress: (progress) => progressReports.add(progress),
        );

        // Assert
        expect(result.isRight(), isTrue);
        expect(progressReports, isNotEmpty);
        expect(progressReports.last, equals(1.0));
      });

      test('should create target directory if it does not exist', () async {
        // Arrange
        final nonExistentTarget = '${tempDir.path}/new_directory/nested/deep';

        // Act
        final result = await service.extract(
          archiveFile: zipFile,
          targetDirectory: nonExistentTarget,
        );

        // Assert
        expect(result.isRight(), isTrue);

        final dir = Directory(nonExistentTarget);
        expect(await dir.exists(), isTrue);

        // Cleanup
        await Directory('${tempDir.path}/new_directory').delete(recursive: true);
      });
    });

    group('extract - TAR.GZ', () {
      late File tarGzFile;
      late String targetDir;

      setUp(() async {
        // Create a tar.gz archive for testing
        final archive = Archive();

        // Add file
        final fileContent = 'TAR GZ content'.codeUnits;
        archive.addFile(ArchiveFile('test.txt', fileContent.length, fileContent));

        // Encode to tar
        final tarEncoder = TarEncoder();
        final tarData = tarEncoder.encode(archive);

        // Compress with gzip
        final gzipEncoder = GZipEncoder();
        final gzipData = gzipEncoder.encode(tarData!);

        // Write file
        tarGzFile = File('${tempDir.path}/test.tar.gz');
        await tarGzFile.writeAsBytes(gzipData!);

        targetDir = '${tempDir.path}/extracted_targz';
      });

      tearDown() async {
        if (await tarGzFile.exists()) await tarGzFile.delete();
        final dir = Directory(targetDir);
        if (await dir.exists()) await dir.delete(recursive: true);
      });

      test('should extract tar.gz archive successfully', () async {
        // Act
        final result = await service.extract(
          archiveFile: tarGzFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isRight(), isTrue);

        result.fold(
          (_) => fail('Should succeed'),
          (extractedDir) async {
            expect(await extractedDir.exists(), isTrue);

            final testFile = File(path.join(targetDir, 'test.txt'));
            expect(await testFile.exists(), isTrue);
            expect(await testFile.readAsString(), equals('TAR GZ content'));
          },
        );
      });
    });

    group('extractFiles - selective extraction', () {
      late File zipFile;
      late String targetDir;

      setUp() async {
        // Create zip with multiple files
        final archive = Archive();

        archive.addFile(ArchiveFile('file1.txt', 6, 'file1\n'.codeUnits));
        archive.addFile(ArchiveFile('file2.txt', 6, 'file2\n'.codeUnits));
        archive.addFile(ArchiveFile('file3.txt', 6, 'file3\n'.codeUnits));

        zipFile = File('${tempDir.path}/multi.zip');
        final zipData = ZipEncoder().encode(archive);
        await zipFile.writeAsBytes(zipData!);

        targetDir = '${tempDir.path}/extracted_selective';
      });

      tearDown() async {
        if (await zipFile.exists()) await zipFile.delete();
        final dir = Directory(targetDir);
        if (await dir.exists()) await dir.delete(recursive: true);
      });

      test('should extract only specified files', () async {
        // Act
        final result = await service.extractFiles(
          archiveFile: zipFile,
          filePaths: ['file1.txt', 'file3.txt'],
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isRight(), isTrue);

        result.fold(
          (_) => fail('Should succeed'),
          (extractedFiles) async {
            expect(extractedFiles.length, equals(2));

            final file1 = File(path.join(targetDir, 'file1.txt'));
            final file2 = File(path.join(targetDir, 'file2.txt'));
            final file3 = File(path.join(targetDir, 'file3.txt'));

            expect(await file1.exists(), isTrue);
            expect(await file2.exists(), isFalse);
            expect(await file3.exists(), isTrue);
          },
        );
      });

      test('should handle non-existent files gracefully', () async {
        // Act
        final result = await service.extractFiles(
          archiveFile: zipFile,
          filePaths: ['file1.txt', 'nonexistent.txt'],
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isRight(), isTrue);

        result.fold(
          (_) => fail('Should succeed'),
          (extractedFiles) {
            // Should only extract files that exist in archive
            expect(extractedFiles.length, equals(1));
            expect(extractedFiles[0].path, contains('file1.txt'));
          },
        );
      });
    });

    group('Error handling', () {
      test('should fail for non-existent archive file', () async {
        // Arrange
        final nonExistentFile = File('${tempDir.path}/nonexistent.zip');
        final targetDir = '${tempDir.path}/target';

        // Act
        final result = await service.extract(
          archiveFile: nonExistentFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<NotFoundException>());
            expect(error.message, contains('not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('should fail for unsupported format', () async {
        // Arrange
        final unsupportedFile = File('${tempDir.path}/test.rar');
        await unsupportedFile.writeAsString('fake rar content');
        final targetDir = '${tempDir.path}/target';

        // Act
        final result = await service.extract(
          archiveFile: unsupportedFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<DomainException>());
            expect(error.message, contains('Unsupported archive format'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await unsupportedFile.delete();
      });

      test('should fail for corrupted zip file', () async {
        // Arrange
        final corruptedFile = File('${tempDir.path}/corrupted.zip');
        await corruptedFile.writeAsString('not a valid zip file');
        final targetDir = '${tempDir.path}/target';

        // Act
        final result = await service.extract(
          archiveFile: corruptedFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) {
            expect(error, isA<DomainException>());
            expect(error.message, contains('Extraction failed'));
          },
          (_) => fail('Should fail'),
        );

        // Cleanup
        await corruptedFile.delete();
      });
    });

    group('Real-world scenarios', () {
      test('should handle large archive with many files', () async {
        // Arrange - Create archive with many files
        final archive = Archive();
        for (var i = 0; i < 100; i++) {
          final content = 'File $i content\n'.codeUnits;
          archive.addFile(ArchiveFile('file_$i.txt', content.length, content));
        }

        final zipFile = File('${tempDir.path}/large.zip');
        final zipData = ZipEncoder().encode(archive);
        await zipFile.writeAsBytes(zipData!);

        final targetDir = '${tempDir.path}/large_extracted';

        // Act
        final result = await service.extract(
          archiveFile: zipFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isRight(), isTrue);

        result.fold(
          (_) => fail('Should succeed'),
          (dir) async {
            // Verify some files
            final file0 = File(path.join(targetDir, 'file_0.txt'));
            final file99 = File(path.join(targetDir, 'file_99.txt'));

            expect(await file0.exists(), isTrue);
            expect(await file99.exists(), isTrue);
          },
        );

        // Cleanup
        await zipFile.delete();
        await Directory(targetDir).delete(recursive: true);
      });

      test('should handle nested directory structure', () async {
        // Arrange - Create archive with nested directories
        final archive = Archive();

        archive.addFile(ArchiveFile('a/', 0, []));
        archive.addFile(ArchiveFile('a/b/', 0, []));
        archive.addFile(ArchiveFile('a/b/c/', 0, []));

        final deepContent = 'Deep file'.codeUnits;
        archive.addFile(ArchiveFile('a/b/c/deep.txt', deepContent.length, deepContent));

        final zipFile = File('${tempDir.path}/nested.zip');
        final zipData = ZipEncoder().encode(archive);
        await zipFile.writeAsBytes(zipData!);

        final targetDir = '${tempDir.path}/nested_extracted';

        // Act
        final result = await service.extract(
          archiveFile: zipFile,
          targetDirectory: targetDir,
        );

        // Assert
        expect(result.isRight(), isTrue);

        final deepFile = File(path.join(targetDir, 'a', 'b', 'c', 'deep.txt'));
        expect(await deepFile.exists(), isTrue);
        expect(await deepFile.readAsString(), equals('Deep file'));

        // Cleanup
        await zipFile.delete();
        await Directory(targetDir).delete(recursive: true);
      });
    });
  });
}
