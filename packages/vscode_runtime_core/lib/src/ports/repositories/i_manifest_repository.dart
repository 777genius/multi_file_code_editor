import 'package:dartz/dartz.dart';
import '../../domain/entities/runtime_module.dart';
import '../../domain/value_objects/runtime_version.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: Manifest Repository
/// Interface for fetching runtime module manifests
abstract class IManifestRepository {
  /// Fetch latest manifest from remote
  Future<Either<DomainException, RuntimeManifest>> fetchManifest();

  /// Get cached manifest (if available)
  Future<Either<DomainException, Option<RuntimeManifest>>> getCachedManifest();

  /// Get all available modules from manifest
  Future<Either<DomainException, List<RuntimeModule>>> getModules();

  /// Get specific module by ID
  Future<Either<DomainException, Option<RuntimeModule>>> getModule(
    String moduleId,
  );

  /// Check for manifest updates
  Future<Either<DomainException, bool>> hasManifestUpdate();

  /// Get manifest version
  Future<Either<DomainException, RuntimeVersion>> getManifestVersion();
}

/// Manifest Data
class RuntimeManifest {
  final RuntimeVersion version;
  final List<RuntimeModule> modules;
  final DateTime publishedAt;
  final Map<String, dynamic>? metadata;

  const RuntimeManifest({
    required this.version,
    required this.modules,
    required this.publishedAt,
    this.metadata,
  });
}
