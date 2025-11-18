import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:vscode_runtime_application/vscode_runtime_application.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// VS Code Compatibility Facade
///
/// Provides a clean, simplified API for managing VS Code runtime installation
/// and extensions. This facade hides the complexity of the layered architecture
/// and provides a single entry point for common operations.
///
/// Usage:
/// ```dart
/// final facade = getIt<VSCodeCompatibilityFacade>();
///
/// // Check runtime status
/// final status = await facade.getRuntimeStatus();
///
/// // Install runtime
/// await facade.installRuntime(
///   modules: [ModuleId.nodejs, ModuleId.openVSCodeServer],
///   onProgress: (moduleId, progress) {
///     print('Installing $moduleId: ${(progress * 100).toStringAsFixed(1)}%');
///   },
/// );
/// ```
@lazySingleton
class VSCodeCompatibilityFacade {
  // Command Handlers
  final InstallRuntimeCommandHandler _installHandler;
  final CancelInstallationCommandHandler _cancelHandler;
  final UninstallRuntimeCommandHandler _uninstallHandler;
  final CheckRuntimeUpdatesCommandHandler _checkUpdatesHandler;

  // Query Handlers
  final GetRuntimeStatusQueryHandler _getRuntimeStatusHandler;
  final GetInstallationProgressQueryHandler _getProgressHandler;
  final GetAvailableModulesQueryHandler _getModulesHandler;
  final GetPlatformInfoQueryHandler _getPlatformInfoHandler;

  VSCodeCompatibilityFacade(
    this._installHandler,
    this._cancelHandler,
    this._uninstallHandler,
    this._checkUpdatesHandler,
    this._getRuntimeStatusHandler,
    this._getProgressHandler,
    this._getModulesHandler,
    this._getPlatformInfoHandler,
  );

  // ==========================================================================
  // Runtime Management
  // ==========================================================================

  /// Get the current runtime installation status
  ///
  /// Returns:
  /// - `RuntimeStatusDto` with current status (installed, not installed, etc.)
  Future<Either<ApplicationException, RuntimeStatusDto>> getRuntimeStatus() {
    return _getRuntimeStatusHandler.handle(const GetRuntimeStatusQuery());
  }

  /// Install VS Code runtime with specified modules
  ///
  /// Parameters:
  /// - `modules`: List of module IDs to install (defaults to all critical modules)
  /// - `trigger`: What triggered the installation (manual, first run, etc.)
  /// - `onProgress`: Optional callback for progress updates
  /// - `cancelToken`: Optional token to cancel the installation
  ///
  /// Returns:
  /// - `Right(unit)` on success
  /// - `Left(ApplicationException)` on failure
  Future<Either<ApplicationException, Unit>> installRuntime({
    List<ModuleId> modules = const [],
    InstallationTrigger trigger = InstallationTrigger.manual,
    void Function(ModuleId moduleId, double progress)? onProgress,
    Object? cancelToken,
  }) {
    final command = InstallRuntimeCommand(
      moduleIds: modules,
      trigger: trigger,
      onProgress: onProgress,
      cancelToken: cancelToken,
    );

    return _installHandler.handle(command);
  }

  /// Cancel an ongoing installation
  ///
  /// Parameters:
  /// - `installationId`: The ID of the installation to cancel
  /// - `reason`: Optional reason for cancellation
  Future<Either<ApplicationException, Unit>> cancelInstallation({
    required InstallationId installationId,
    String? reason,
  }) {
    final command = CancelInstallationCommand(
      installationId: installationId,
      reason: reason,
    );

    return _cancelHandler.handle(command);
  }

  /// Uninstall VS Code runtime modules
  ///
  /// Parameters:
  /// - `modules`: List of module IDs to uninstall (empty = uninstall all)
  /// - `keepDownloads`: Whether to keep downloaded archives
  Future<Either<ApplicationException, Unit>> uninstallRuntime({
    List<ModuleId> modules = const [],
    bool keepDownloads = false,
  }) {
    final command = UninstallRuntimeCommand(
      moduleIds: modules,
      keepDownloads: keepDownloads,
    );

    return _uninstallHandler.handle(command);
  }

  /// Check for runtime updates
  ///
  /// Returns:
  /// - Information about available updates
  Future<Either<ApplicationException, Unit>> checkForUpdates() {
    return _checkUpdatesHandler.handle(const CheckRuntimeUpdatesCommand());
  }

  // ==========================================================================
  // Information Queries
  // ==========================================================================

  /// Get installation progress for a specific installation
  ///
  /// Parameters:
  /// - `installationId`: The installation to query
  ///
  /// Returns:
  /// - Detailed progress information
  Future<Either<ApplicationException, InstallationProgressDto>>
      getInstallationProgress({
    required InstallationId installationId,
  }) {
    final query = GetInstallationProgressQuery(
      installationId: installationId,
    );

    return _getProgressHandler.handle(query);
  }

  /// Get list of available modules
  ///
  /// Parameters:
  /// - `platformFilter`: Only show modules for this platform
  /// - `includeOptional`: Include optional modules
  ///
  /// Returns:
  /// - List of available modules with metadata
  Future<Either<ApplicationException, List<ModuleInfoDto>>>
      getAvailableModules({
    PlatformIdentifier? platformFilter,
    bool includeOptional = true,
  }) {
    final query = GetAvailableModulesQuery(
      platformFilter: platformFilter,
      includeOptional: includeOptional,
    );

    return _getModulesHandler.handle(query);
  }

  /// Get current platform information
  ///
  /// Returns:
  /// - Platform details and compatibility information
  Future<Either<ApplicationException, PlatformInfoDto>> getPlatformInfo() {
    return _getPlatformInfoHandler.handle(const GetPlatformInfoQuery());
  }

  // ==========================================================================
  // Convenience Methods
  // ==========================================================================

  /// Install all critical modules for current platform
  ///
  /// This is a convenience method that:
  /// 1. Gets current platform
  /// 2. Gets all critical (non-optional) modules
  /// 3. Installs them with progress tracking
  Future<Either<ApplicationException, Unit>> installAllCriticalModules({
    void Function(ModuleId moduleId, double progress)? onProgress,
  }) async {
    // Get available modules
    final modulesResult = await getAvailableModules(includeOptional: false);

    return modulesResult.fold(
      (error) => left(error),
      (modules) {
        final moduleIds = modules.map((m) => m.id).toList();

        return installRuntime(
          modules: moduleIds,
          trigger: InstallationTrigger.firstRun,
          onProgress: onProgress,
        );
      },
    );
  }

  /// Check if runtime is installed and ready
  ///
  /// Returns `true` if runtime is fully installed, `false` otherwise
  Future<bool> isRuntimeReady() async {
    final statusResult = await getRuntimeStatus();

    return statusResult.fold(
      (_) => false,
      (status) => status.maybeMap(
        installed: (_) => true,
        orElse: () => false,
      ),
    );
  }

  /// Get a summary of the current state as a human-readable string
  Future<String> getStatusSummary() async {
    final statusResult = await getRuntimeStatus();

    return statusResult.fold(
      (error) => 'Error: ${error.message}',
      (status) => status.map(
        notInstalled: (_) => 'VS Code runtime is not installed',
        installed: (s) => 'VS Code runtime v${s.version} is installed',
        partiallyInstalled: (s) =>
            'Runtime partially installed (${s.missingModules.length} modules missing)',
        installing: (s) =>
            'Installation in progress (${(s.progress * 100).toStringAsFixed(1)}%)',
        failed: (s) => 'Installation failed: ${s.error}',
        updateAvailable: (s) =>
            'Update available: ${s.currentVersion} → ${s.availableVersion}',
      ),
    );
  }
}
