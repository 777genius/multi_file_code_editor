import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/value_objects/module_id.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: File System Service
/// Interface for file system operations
abstract class IFileSystemService {
  /// Get runtime installation root directory
  Future<Either<DomainException, Directory>> getInstallationDirectory();

  /// Get directory for specific module
  Future<Either<DomainException, Directory>> getModuleDirectory(
    ModuleId moduleId,
  );

  /// Get download directory (temp)
  Future<Either<DomainException, Directory>> getDownloadDirectory();

  /// Create directory if not exists
  Future<Either<DomainException, Directory>> ensureDirectory(String path);

  /// Delete directory recursively
  Future<Either<DomainException, Unit>> deleteDirectory(Directory directory);

  /// Check if directory exists
  Future<Either<DomainException, bool>> directoryExists(String path);

  /// Get directory size
  Future<Either<DomainException, int>> getDirectorySize(Directory directory);

  /// Move directory
  Future<Either<DomainException, Directory>> moveDirectory({
    required Directory source,
    required String targetPath,
  });

  /// Copy file
  Future<Either<DomainException, File>> copyFile({
    required File source,
    required String targetPath,
  });

  /// Set file executable permissions (Unix/macOS)
  Future<Either<DomainException, Unit>> setExecutable(File file);
}
