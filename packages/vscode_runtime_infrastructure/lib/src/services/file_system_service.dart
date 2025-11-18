import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// File System Service Implementation
/// Handles all file system operations for runtime management
class FileSystemService implements IFileSystemService {
  static const String _runtimeDirectoryName = 'vscode_runtime';

  @override
  Future<Either<DomainException, Directory>> getInstallationDirectory() async {
    try {
      final appSupport = await getApplicationSupportDirectory();
      final runtimeDir = Directory(
        path.join(appSupport.path, _runtimeDirectoryName),
      );

      await runtimeDir.create(recursive: true);

      return right(runtimeDir);
    } catch (e) {
      return left(
        DomainException('Failed to get installation directory: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Directory>> getModuleDirectory(
    ModuleId moduleId,
  ) async {
    try {
      final installDirResult = await getInstallationDirectory();

      return installDirResult.fold(
        (error) => left(error),
        (installDir) async {
          final moduleDir = Directory(
            path.join(installDir.path, 'modules', moduleId.value),
          );

          await moduleDir.create(recursive: true);

          return right(moduleDir);
        },
      );
    } catch (e) {
      return left(
        DomainException(
          'Failed to get module directory for ${moduleId.value}: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, Directory>> getDownloadDirectory() async {
    try {
      final installDirResult = await getInstallationDirectory();

      return installDirResult.fold(
        (error) => left(error),
        (installDir) async {
          final downloadDir = Directory(
            path.join(installDir.path, 'downloads'),
          );

          await downloadDir.create(recursive: true);

          return right(downloadDir);
        },
      );
    } catch (e) {
      return left(
        DomainException('Failed to get download directory: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Directory>> ensureDirectory(
    String dirPath,
  ) async {
    try {
      final dir = Directory(dirPath);

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      return right(dir);
    } catch (e) {
      return left(
        DomainException('Failed to ensure directory $dirPath: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Unit>> deleteDirectory(
    Directory directory,
  ) async {
    try {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }

      return right(unit);
    } catch (e) {
      return left(
        DomainException(
          'Failed to delete directory ${directory.path}: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> directoryExists(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      final exists = await dir.exists();

      return right(exists);
    } catch (e) {
      return left(
        DomainException(
          'Failed to check if directory exists $dirPath: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, int>> getDirectorySize(
    Directory directory,
  ) async {
    try {
      if (!await directory.exists()) {
        return right(0);
      }

      int totalSize = 0;

      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return right(totalSize);
    } catch (e) {
      return left(
        DomainException(
          'Failed to get directory size for ${directory.path}: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, Directory>> moveDirectory({
    required Directory source,
    required String targetPath,
  }) async {
    try {
      if (!await source.exists()) {
        return left(
          NotFoundException('Source directory does not exist: ${source.path}'),
        );
      }

      final target = Directory(targetPath);

      // Ensure parent directory exists
      await target.parent.create(recursive: true);

      // Rename/move directory
      final movedDir = await source.rename(targetPath);

      return right(movedDir);
    } catch (e) {
      // If rename fails (e.g., cross-device), copy and delete
      try {
        final target = Directory(targetPath);
        await target.create(recursive: true);

        await for (final entity in source.list(recursive: false)) {
          if (entity is File) {
            final newPath = path.join(
              targetPath,
              path.basename(entity.path),
            );
            await entity.copy(newPath);
          } else if (entity is Directory) {
            final newPath = path.join(
              targetPath,
              path.basename(entity.path),
            );
            await moveDirectory(source: entity, targetPath: newPath);
          }
        }

        await source.delete(recursive: true);

        return right(target);
      } catch (copyError) {
        return left(
          DomainException(
            'Failed to move directory from ${source.path} to $targetPath: '
            '${copyError.toString()}',
          ),
        );
      }
    }
  }

  @override
  Future<Either<DomainException, File>> copyFile({
    required File source,
    required String targetPath,
  }) async {
    try {
      if (!await source.exists()) {
        return left(
          NotFoundException('Source file does not exist: ${source.path}'),
        );
      }

      // Ensure parent directory exists
      final targetFile = File(targetPath);
      await targetFile.parent.create(recursive: true);

      final copiedFile = await source.copy(targetPath);

      return right(copiedFile);
    } catch (e) {
      return left(
        DomainException(
          'Failed to copy file from ${source.path} to $targetPath: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<DomainException, Unit>> setExecutable(File file) async {
    try {
      if (!await file.exists()) {
        return left(
          NotFoundException('File does not exist: ${file.path}'),
        );
      }

      // Set executable permission on Unix-like systems
      if (Platform.isLinux || Platform.isMacOS) {
        final result = await Process.run('chmod', ['+x', file.path]);

        if (result.exitCode != 0) {
          return left(
            DomainException(
              'Failed to set executable permission: ${result.stderr}',
            ),
          );
        }
      }

      return right(unit);
    } catch (e) {
      return left(
        DomainException(
          'Failed to set executable permission for ${file.path}: ${e.toString()}',
        ),
      );
    }
  }
}
