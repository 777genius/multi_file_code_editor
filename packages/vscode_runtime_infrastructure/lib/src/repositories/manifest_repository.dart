import 'package:dartz/dartz.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';
import '../data_sources/manifest_data_source.dart';

/// Manifest Repository Implementation
/// Fetches and manages runtime module manifests
class ManifestRepository implements IManifestRepository {
  final ManifestDataSource _dataSource;
  String? _cachedVersion;

  ManifestRepository(this._dataSource);

  @override
  Future<Either<DomainException, List<RuntimeModule>>> fetchManifest() async {
    try {
      final manifestDto = await _dataSource.fetchManifest();

      _cachedVersion = manifestDto.version;

      final modules = manifestDto.toDomain();

      return right(modules);
    } catch (e) {
      return left(
        DomainException('Failed to fetch manifest: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, List<RuntimeModule>>> getModules(
    PlatformIdentifier platform,
  ) async {
    try {
      final manifestResult = await fetchManifest();

      return manifestResult.fold(
        (error) => left(error),
        (modules) {
          // Filter modules that support the target platform
          final compatibleModules = modules
              .where((m) => m.isAvailableForPlatform(platform))
              .toList();

          return right(compatibleModules);
        },
      );
    } catch (e) {
      return left(
        DomainException('Failed to get modules: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<DomainException, bool>> hasManifestUpdate(
    String currentVersion,
  ) async {
    try {
      final hasUpdate = await _dataSource.hasUpdate(currentVersion);

      return right(hasUpdate);
    } catch (e) {
      return left(
        DomainException('Failed to check for updates: ${e.toString()}'),
      );
    }
  }
}
