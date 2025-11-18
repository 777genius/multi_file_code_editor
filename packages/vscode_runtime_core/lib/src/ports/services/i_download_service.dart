import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/value_objects/download_url.dart';
import '../../domain/value_objects/byte_size.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: Download Service
/// Interface for downloading files
abstract class IDownloadService {
  /// Download file from URL
  /// Returns downloaded file
  Future<Either<DomainException, File>> download({
    required DownloadUrl url,
    required ByteSize expectedSize,
    void Function(ByteSize received, ByteSize total)? onProgress,
    CancelToken? cancelToken,
  });

  /// Cancel ongoing download
  Future<Either<DomainException, Unit>> cancelDownload(CancelToken token);

  /// Get download progress
  Stream<DownloadProgress> getProgressStream(CancelToken token);
}

/// Cancel Token for downloads
class CancelToken {
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  void cancel() {
    _isCancelled = true;
  }
}

/// Download Progress
class DownloadProgress {
  final ByteSize received;
  final ByteSize total;
  final double percentage;

  const DownloadProgress({
    required this.received,
    required this.total,
    required this.percentage,
  });

  factory DownloadProgress.fromBytes(int received, int total) {
    final receivedSize = ByteSize(received);
    final totalSize = ByteSize(total);
    final percentage = receivedSize.progressTo(totalSize);

    return DownloadProgress(
      received: receivedSize,
      total: totalSize,
      percentage: percentage,
    );
  }
}
