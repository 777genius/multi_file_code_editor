import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// Verification Service Implementation
/// Handles file integrity verification using SHA256 hashing
class VerificationService implements IVerificationService {
  @override
  Future<Either<VerificationException, Unit>> verifyHash({
    required File file,
    required SHA256Hash expectedHash,
  }) async {
    try {
      final computedHashResult = await computeHash(file);

      return computedHashResult.fold(
        (error) => left(
          VerificationException('Failed to compute hash: ${error.message}'),
        ),
        (computedHash) {
          if (!computedHash.matches(expectedHash)) {
            return left(
              VerificationException(
                'Hash mismatch: expected ${expectedHash.truncate(16)}, '
                'got ${computedHash.truncate(16)}',
              ),
            );
          }

          return right(unit);
        },
      );
    } catch (e) {
      return left(
        VerificationException('Hash verification failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<VerificationException, Unit>> verifySize({
    required File file,
    required ByteSize expectedSize,
  }) async {
    try {
      final verifyFileResult = await verifyFileReadable(file);

      return verifyFileResult.fold(
        (error) => left(
          VerificationException('File verification failed: ${error.message}'),
        ),
        (_) async {
          final stat = await file.stat();
          final actualSize = ByteSize(stat.size);

          if (actualSize.bytes != expectedSize.bytes) {
            return left(
              VerificationException(
                'Size mismatch: expected ${expectedSize.toHumanReadable()}, '
                'got ${actualSize.toHumanReadable()}',
              ),
            );
          }

          return right(unit);
        },
      );
    } catch (e) {
      return left(
        VerificationException('Size verification failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, SHA256Hash>> computeHash(File file) async {
    try {
      final verifyFileResult = await verifyFileReadable(file);

      return verifyFileResult.fold(
        (error) => left(error),
        (_) async {
          final bytes = await file.readAsBytes();
          final digest = sha256.convert(bytes);
          final hashString = digest.toString();

          final hash = SHA256Hash.fromString(hashString);

          return right(hash);
        },
      );
    } catch (e) {
      return left(
        DomainException('Failed to compute hash: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<VerificationException, Unit>> verify({
    required File file,
    required SHA256Hash expectedHash,
    required ByteSize expectedSize,
  }) async {
    try {
      // Verify size first (faster)
      final sizeResult = await verifySize(file: file, expectedSize: expectedSize);

      return sizeResult.fold(
        (error) => left(error),
        (_) async {
          // Then verify hash
          final hashResult = await verifyHash(file: file, expectedHash: expectedHash);

          return hashResult.fold(
            (error) => left(error),
            (_) => right(unit),
          );
        },
      );
    } catch (e) {
      return left(
        VerificationException('Verification failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Unit>> verifyFileReadable(File file) async {
    try {
      if (!await file.exists()) {
        return left(
          NotFoundException('File does not exist: ${file.path}'),
        );
      }

      // Try to read the file to ensure it's readable
      final stat = await file.stat();

      if (stat.size == 0) {
        return left(
          const ValidationException('File is empty'),
        );
      }

      // Try to open the file for reading
      final randomAccessFile = await file.open(mode: FileMode.read);
      await randomAccessFile.close();

      return right(unit);
    } catch (e) {
      return left(
        DomainException('File is not readable: ${e.toString()}'),
      );
    }
  }
}
