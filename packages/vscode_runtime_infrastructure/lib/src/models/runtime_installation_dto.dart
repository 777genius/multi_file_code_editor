import 'package:json_annotation/json_annotation.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

part 'runtime_installation_dto.g.dart';

/// Runtime Installation DTO for persistence
@JsonSerializable()
class RuntimeInstallationDto {
  final String id;
  final String status;
  final String platform;
  final String trigger;
  final DateTime createdAt;
  final List<String> installedModuleIds;
  final double progress;
  final String? errorMessage;
  final DateTime? completedAt;
  final DateTime? failedAt;

  const RuntimeInstallationDto({
    required this.id,
    required this.status,
    required this.platform,
    required this.trigger,
    required this.createdAt,
    required this.installedModuleIds,
    required this.progress,
    this.errorMessage,
    this.completedAt,
    this.failedAt,
  });

  factory RuntimeInstallationDto.fromJson(Map<String, dynamic> json) =>
      _$RuntimeInstallationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RuntimeInstallationDtoToJson(this);

  /// Create from domain aggregate
  /// Note: This only persists state, not the full modules list
  factory RuntimeInstallationDto.fromDomain(RuntimeInstallation installation) {
    return RuntimeInstallationDto(
      id: installation.id.value,
      status: installation.status.toString().split('.').last,
      platform: installation.targetPlatform.toString(),
      trigger: installation.trigger.toString().split('.').last,
      createdAt: installation.createdAt,
      installedModuleIds: installation.installedModules.map((id) => id.value).toList(),
      progress: installation.progress,
      errorMessage: installation.errorMessage,
      completedAt: installation.completedAt,
      failedAt: installation.failedAt,
    );
  }

  /// Convert to platform identifier
  PlatformIdentifier toPlatformIdentifier() {
    final parts = platform.split('-');
    return PlatformIdentifier(os: parts[0], architecture: parts[1]);
  }

  /// Convert to installation status
  InstallationStatus toInstallationStatus() {
    return InstallationStatus.values.firstWhere(
      (s) => s.toString().split('.').last == status,
    );
  }

  /// Convert to installation trigger
  InstallationTrigger toInstallationTrigger() {
    return InstallationTrigger.values.firstWhere(
      (t) => t.toString().split('.').last == trigger,
    );
  }
}
