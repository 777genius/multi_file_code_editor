import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: Extraction Service
/// Interface for extracting compressed archives
abstract class IExtractionService {
  /// Extract archive to target directory
  Future<Either<DomainException, Directory>> extract({
    required File archiveFile,
    required String targetDirectory,
    void Function(double progress)? onProgress,
  });

  /// Check if file format is supported
  bool isFormatSupported(String filename);

  /// Get detected format from filename
  String detectFormat(String filename);

  /// Extract specific files from archive
  Future<Either<DomainException, List<File>>> extractFiles({
    required File archiveFile,
    required List<String> filePaths,
    required String targetDirectory,
  });
}
