import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/value_objects/sha256_hash.dart';
import '../../domain/value_objects/byte_size.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: Verification Service
/// Interface for verifying file integrity
abstract class IVerificationService {
  /// Verify file hash matches expected hash
  Future<Either<VerificationException, Unit>> verifyHash({
    required File file,
    required SHA256Hash expectedHash,
  });

  /// Verify file size matches expected size
  Future<Either<VerificationException, Unit>> verifySize({
    required File file,
    required ByteSize expectedSize,
  });

  /// Compute hash of file
  Future<Either<DomainException, SHA256Hash>> computeHash(File file);

  /// Verify both hash and size
  Future<Either<VerificationException, Unit>> verify({
    required File file,
    required SHA256Hash expectedHash,
    required ByteSize expectedSize,
  });

  /// Verify file exists and is readable
  Future<Either<DomainException, Unit>> verifyFileReadable(File file);
}
