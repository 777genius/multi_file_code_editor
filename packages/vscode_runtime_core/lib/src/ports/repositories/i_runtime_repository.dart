import 'package:dartz/dartz.dart';
import '../../domain/aggregates/runtime_installation.dart';
import '../../domain/value_objects/runtime_version.dart';
import '../../domain/value_objects/installation_id.dart';
import '../../domain/value_objects/module_id.dart';
import '../../domain/exceptions/domain_exception.dart';

/// Port: Runtime Repository
/// Interface for runtime persistence operations
abstract class IRuntimeRepository {
  /// Get currently installed runtime version
  /// Returns None if not installed
  Future<Either<DomainException, Option<RuntimeVersion>>> getInstalledVersion();

  /// Save installation state
  Future<Either<DomainException, Unit>> saveInstallation(
    RuntimeInstallation installation,
  );

  /// Load installation by ID
  /// Requires modules to reconstruct the aggregate
  Future<Either<DomainException, Option<RuntimeInstallation>>> loadInstallation(
    InstallationId installationId,
    List<RuntimeModule> modules,
  );

  /// Get all installation history
  Future<Either<DomainException, List<RuntimeInstallation>>> getInstallationHistory();

  /// Check if specific module is installed
  Future<Either<DomainException, bool>> isModuleInstalled(ModuleId moduleId);

  /// Get installation directory path
  Future<Either<DomainException, String>> getInstallationDirectory();

  /// Get module directory path
  Future<Either<DomainException, String>> getModuleDirectory(ModuleId moduleId);

  /// Delete installation (cleanup)
  /// If installationId is null, deletes all installations
  Future<Either<DomainException, Unit>> deleteInstallation([
    InstallationId? installationId,
  ]);

  /// Save installed version
  Future<Either<DomainException, Unit>> saveInstalledVersion(
    RuntimeVersion version,
  );

  /// Get latest completed installation
  Future<Either<DomainException, Option<RuntimeInstallation>>> getLatestInstallation();
}
