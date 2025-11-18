import 'package:dartz/dartz.dart';
import '../../domain/value_objects/platform_identifier.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: Platform Service
/// Interface for platform detection and information
abstract class IPlatformService {
  /// Get current platform identifier
  Future<Either<DomainException, PlatformIdentifier>> getCurrentPlatform();

  /// Check if platform is supported
  Future<Either<DomainException, bool>> isPlatformSupported(
    PlatformIdentifier platform,
  );

  /// Get platform information
  Future<Either<DomainException, PlatformInfo>> getPlatformInfo();

  /// Get available disk space
  Future<Either<DomainException, int>> getAvailableDiskSpace();

  /// Check if running with required permissions
  Future<Either<DomainException, bool>> hasRequiredPermissions();
}

/// Platform Information
class PlatformInfo {
  final PlatformIdentifier identifier;
  final String osName;
  final String osVersion;
  final String architecture;
  final int numberOfProcessors;

  const PlatformInfo({
    required this.identifier,
    required this.osName,
    required this.osVersion,
    required this.architecture,
    required this.numberOfProcessors,
  });
}
