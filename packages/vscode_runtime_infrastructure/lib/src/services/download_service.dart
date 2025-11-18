import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// Download Service Implementation
/// Handles file downloads with progress tracking and cancellation
class DownloadService implements IDownloadService {
  final Dio _dio;

  DownloadService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(minutes: 10),
                followRedirects: true,
                maxRedirects: 5,
              ),
            );

  @override
  Future<Either<DomainException, File>> download({
    required DownloadUrl url,
    required String targetPath,
    void Function(ByteSize downloaded, ByteSize total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final targetFile = File(targetPath);

      // Ensure parent directory exists
      await targetFile.parent.create(recursive: true);

      // Download with progress tracking
      await _dio.download(
        url.value,
        targetPath,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total != -1) {
            final downloadedSize = ByteSize(bytes: received);
            final totalSize = ByteSize(bytes: total);
            onProgress(downloadedSize, totalSize);
          }
        },
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (!await targetFile.exists()) {
        return left(
          const DomainException('Download completed but file not found'),
        );
      }

      return right(targetFile);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return left(
          const DomainException('Download cancelled'),
        );
      }

      return left(
        DomainException('Download failed: ${e.message ?? e.toString()}'),
      );
    } catch (e) {
      return left(
        DomainException('Download failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, ByteSize>> getRemoteFileSize(
    DownloadUrl url,
  ) async {
    try {
      final response = await _dio.head(url.value);

      final contentLength = response.headers.value('content-length');

      if (contentLength == null) {
        return left(
          const DomainException('Could not determine file size'),
        );
      }

      final bytes = int.parse(contentLength);
      return right(ByteSize(bytes: bytes));
    } on DioException catch (e) {
      return left(
        DomainException('Failed to get file size: ${e.message ?? e.toString()}'),
      );
    } catch (e) {
      return left(
        DomainException('Failed to get file size: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> isUrlAccessible(
    DownloadUrl url,
  ) async {
    try {
      final response = await _dio.head(
        url.value,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return right(response.statusCode != null && response.statusCode! < 400);
    } on DioException catch (_) {
      return right(false);
    } catch (e) {
      return left(
        DomainException('Failed to check URL accessibility: ${e.toString()}'),
      );
    }
  }

  @override
  CancelToken createCancelToken() {
    return CancelToken();
  }

  @override
  void cancelDownload(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel('Download cancelled by user');
    }
  }
}
