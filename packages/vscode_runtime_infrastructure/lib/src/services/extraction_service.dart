import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// Extraction Service Implementation
/// Handles extraction of compressed archives
class ExtractionService implements IExtractionService {
  @override
  Future<Either<DomainException, Directory>> extract({
    required File archiveFile,
    required String targetDirectory,
    void Function(double progress)? onProgress,
  }) async {
    try {
      if (!await archiveFile.exists()) {
        return left(
          NotFoundException('Archive file not found: ${archiveFile.path}'),
        );
      }

      final targetDir = Directory(targetDirectory);
      await targetDir.create(recursive: true);

      final format = detectFormat(archiveFile.path);

      switch (format) {
        case 'zip':
          await _extractZip(archiveFile, targetDir, onProgress);
          break;

        case 'tar.gz':
        case 'tgz':
          await _extractTarGz(archiveFile, targetDir, onProgress);
          break;

        case 'tar.xz':
          await _extractTarXz(archiveFile, targetDir, onProgress);
          break;

        case 'tar.bz2':
          await _extractTarBz2(archiveFile, targetDir, onProgress);
          break;

        default:
          return left(
            DomainException('Unsupported archive format: $format'),
          );
      }

      return right(targetDir);
    } catch (e) {
      return left(
        DomainException('Extraction failed: ${e.toString()}'),
      );
    }
  }

  @override
  bool isFormatSupported(String filename) {
    final format = detectFormat(filename);
    return format != 'unknown';
  }

  @override
  String detectFormat(String filename) {
    final lower = filename.toLowerCase();

    if (lower.endsWith('.zip')) return 'zip';
    if (lower.endsWith('.tar.gz') || lower.endsWith('.tgz')) return 'tar.gz';
    if (lower.endsWith('.tar.xz')) return 'tar.xz';
    if (lower.endsWith('.tar.bz2')) return 'tar.bz2';

    return 'unknown';
  }

  @override
  Future<Either<DomainException, List<File>>> extractFiles({
    required File archiveFile,
    required List<String> filePaths,
    required String targetDirectory,
  }) async {
    try {
      if (!await archiveFile.exists()) {
        return left(
          NotFoundException('Archive file not found: ${archiveFile.path}'),
        );
      }

      final targetDir = Directory(targetDirectory);
      await targetDir.create(recursive: true);

      final format = detectFormat(archiveFile.path);

      if (format == 'zip') {
        return await _extractSpecificZipFiles(
          archiveFile,
          filePaths,
          targetDir,
        );
      }

      // For tar formats, extract all and filter
      // (archive library doesn't support selective extraction for tar)
      await extract(
        archiveFile: archiveFile,
        targetDirectory: targetDirectory,
      );

      final extractedFiles = <File>[];
      for (final filePath in filePaths) {
        final file = File(path.join(targetDirectory, filePath));
        if (await file.exists()) {
          extractedFiles.add(file);
        }
      }

      return right(extractedFiles);
    } catch (e) {
      return left(
        DomainException('Selective extraction failed: ${e.toString()}'),
      );
    }
  }

  // Private extraction methods

  Future<void> _extractZip(
    File archiveFile,
    Directory targetDir,
    void Function(double)? onProgress,
  ) async {
    final bytes = await archiveFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final totalFiles = archive.length;
    var processedFiles = 0;

    for (final file in archive) {
      final filename = file.name;

      if (file.isFile) {
        final data = file.content as List<int>;
        final outputFile = File(path.join(targetDir.path, filename));

        await outputFile.create(recursive: true);
        await outputFile.writeAsBytes(data);
      } else {
        final dir = Directory(path.join(targetDir.path, filename));
        await dir.create(recursive: true);
      }

      processedFiles++;
      onProgress?.call(processedFiles / totalFiles);
    }
  }

  Future<void> _extractTarGz(
    File archiveFile,
    Directory targetDir,
    void Function(double)? onProgress,
  ) async {
    final bytes = await archiveFile.readAsBytes();
    final gzipBytes = GZipDecoder().decodeBytes(bytes);
    final archive = TarDecoder().decodeBytes(gzipBytes);

    await _extractTarArchive(archive, targetDir, onProgress);
  }

  Future<void> _extractTarXz(
    File archiveFile,
    Directory targetDir,
    void Function(double)? onProgress,
  ) async {
    final bytes = await archiveFile.readAsBytes();
    final xzBytes = XZDecoder().decodeBytes(bytes);
    final archive = TarDecoder().decodeBytes(xzBytes);

    await _extractTarArchive(archive, targetDir, onProgress);
  }

  Future<void> _extractTarBz2(
    File archiveFile,
    Directory targetDir,
    void Function(double)? onProgress,
  ) async {
    final bytes = await archiveFile.readAsBytes();
    final bz2Bytes = BZip2Decoder().decodeBytes(bytes);
    final archive = TarDecoder().decodeBytes(bz2Bytes);

    await _extractTarArchive(archive, targetDir, onProgress);
  }

  Future<void> _extractTarArchive(
    Archive archive,
    Directory targetDir,
    void Function(double)? onProgress,
  ) async {
    final totalFiles = archive.length;
    var processedFiles = 0;

    for (final file in archive) {
      final filename = file.name;

      if (file.isFile) {
        final data = file.content as List<int>;
        final outputFile = File(path.join(targetDir.path, filename));

        await outputFile.create(recursive: true);
        await outputFile.writeAsBytes(data);

        // Set executable permission if needed (Unix)
        if (Platform.isLinux || Platform.isMacOS) {
          final mode = file.mode ?? 0;
          if (mode & 0x49 != 0) {
            // Check if executable bit is set
            await Process.run('chmod', ['+x', outputFile.path]);
          }
        }
      } else {
        final dir = Directory(path.join(targetDir.path, filename));
        await dir.create(recursive: true);
      }

      processedFiles++;
      onProgress?.call(processedFiles / totalFiles);
    }
  }

  Future<Either<DomainException, List<File>>> _extractSpecificZipFiles(
    File archiveFile,
    List<String> filePaths,
    Directory targetDir,
  ) async {
    final bytes = await archiveFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final extractedFiles = <File>[];
    final filePathSet = filePaths.toSet();

    for (final file in archive) {
      if (filePathSet.contains(file.name) && file.isFile) {
        final data = file.content as List<int>;
        final outputFile = File(path.join(targetDir.path, file.name));

        await outputFile.create(recursive: true);
        await outputFile.writeAsBytes(data);

        extractedFiles.add(outputFile);
      }
    }

    return right(extractedFiles);
  }
}
