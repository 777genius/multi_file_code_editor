import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import '../data_sources/runtime_storage_data_source.dart';
import '../models/runtime_installation_dto.dart';

/// Runtime Repository Implementation
/// Manages runtime installation state persistence
class RuntimeRepository implements IRuntimeRepository {
  final RuntimeStorageDataSource _dataSource;

  RuntimeRepository(this._dataSource);

  @override
  Future<Either<DomainException, Unit>> saveInstallation(
    RuntimeInstallation installation,
  ) async {
    try {
      final dto = RuntimeInstallationDto.fromDomain(installation);

      await _dataSource.saveInstallation(dto);

      // If installation is completed, save the version
      if (installation.status == InstallationStatus.completed) {
        // Find the highest version from modules
        if (installation.modules.isNotEmpty) {
          final version = installation.modules.first.version.toString();
          await _dataSource.saveInstalledVersion(version);
        }

        // Mark all modules as installed
        for (final moduleId in installation.installedModules) {
          await _dataSource.markModuleInstalled(moduleId.value);
        }
      }

      return right(unit);
    } catch (e) {
      return left(
        DomainException('Failed to save installation: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Option<RuntimeInstallation>>> loadInstallation(
    InstallationId installationId,
    List<RuntimeModule> modules,
  ) async {
    try {
      final dto = await _dataSource.loadInstallation();

      if (dto == null) {
        return right(none());
      }

      // Only return if the ID matches
      if (dto.id != installationId.value) {
        return right(none());
      }

      // Reconstruct the installation from DTO + modules
      final installation = RuntimeInstallation(
        id: InstallationId(value: dto.id),
        modules: modules,
        targetPlatform: dto.toPlatformIdentifier(),
        status: dto.toInstallationStatus(),
        createdAt: dto.createdAt,
        trigger: dto.toInstallationTrigger(),
        installedModules: dto.installedModuleIds.map((id) => ModuleId(value: id)).toList(),
        progress: dto.progress,
        errorMessage: dto.errorMessage,
        completedAt: dto.completedAt,
        failedAt: dto.failedAt,
      );

      return right(some(installation));
    } catch (e) {
      return left(
        DomainException('Failed to load installation: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Option<RuntimeVersion>>> getInstalledVersion() async {
    try {
      final versionString = await _dataSource.getInstalledVersion();

      if (versionString == null) {
        return right(none());
      }

      final version = RuntimeVersion.fromString(versionString);

      return right(some(version));
    } catch (e) {
      return left(
        DomainException('Failed to get installed version: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> isModuleInstalled(
    ModuleId moduleId,
  ) async {
    try {
      final isInstalled = await _dataSource.isModuleInstalled(moduleId.value);

      return right(isInstalled);
    } catch (e) {
      return left(
        DomainException('Failed to check module installation: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, Unit>> deleteInstallation() async {
    try {
      await _dataSource.deleteInstallation();

      return right(unit);
    } catch (e) {
      return left(
        DomainException('Failed to delete installation: ${e.toString()}'),
      );
    }
  }
}
