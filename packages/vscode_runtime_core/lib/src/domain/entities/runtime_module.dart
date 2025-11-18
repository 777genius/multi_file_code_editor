import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import '../value_objects/module_id.dart';
import '../value_objects/runtime_version.dart';
import '../value_objects/platform_identifier.dart';
import '../enums/module_type.dart';
import '../exceptions/domain_exception.dart';
import 'platform_artifact.dart';

part 'runtime_module.freezed.dart';
part 'runtime_module.g.dart';

/// Entity: Runtime Module
/// Represents a downloadable runtime component
@freezed
class RuntimeModule with _$RuntimeModule {
  const RuntimeModule._();

  const factory RuntimeModule({
    required ModuleId id,
    required String name,
    required String description,
    required ModuleType type,
    required RuntimeVersion version,
    required Map<PlatformIdentifier, PlatformArtifact> platformArtifacts,
    @Default([]) List<ModuleId> dependencies,
    @Default(false) bool isOptional,
    Map<String, dynamic>? metadata,
  }) = _RuntimeModule;

  factory RuntimeModule.fromJson(Map<String, dynamic> json) =>
      _$RuntimeModuleFromJson(json);

  /// Factory with validation
  factory RuntimeModule.create({
    required ModuleId id,
    required String name,
    required String description,
    required ModuleType type,
    required RuntimeVersion version,
    required Map<PlatformIdentifier, PlatformArtifact> platformArtifacts,
    List<ModuleId>? dependencies,
    bool isOptional = false,
    Map<String, dynamic>? metadata,
  }) {
    // Validate invariants
    if (platformArtifacts.isEmpty) {
      throw const ValidationException(
        'Module must have at least one platform artifact',
      );
    }

    if (name.trim().isEmpty) {
      throw const ValidationException('Module name cannot be empty');
    }

    // Validate all artifacts
    for (final entry in platformArtifacts.entries) {
      if (!entry.value.isValid) {
        throw ValidationException(
          'Invalid artifact for platform ${entry.key}',
        );
      }
    }

    return RuntimeModule(
      id: id,
      name: name,
      description: description,
      type: type,
      version: version,
      platformArtifacts: platformArtifacts,
      dependencies: dependencies ?? [],
      isOptional: isOptional,
      metadata: metadata,
    );
  }

  /// Business Logic: Get artifact for platform
  Option<PlatformArtifact> artifactFor(PlatformIdentifier platform) {
    final artifact = platformArtifacts[platform];
    return optionOf(artifact);
  }

  /// Business Logic: Check if available for platform
  bool isAvailableForPlatform(PlatformIdentifier platform) {
    return platformArtifacts.containsKey(platform);
  }

  /// Business Logic: Check if has dependencies
  bool get hasDependencies => dependencies.isNotEmpty;

  /// Business Logic: Check if critical (non-optional)
  bool get isCritical => !isOptional;

  /// Business Logic: Get total size for platform
  Option<ByteSize> sizeForPlatform(PlatformIdentifier platform) {
    return artifactFor(platform).map((artifact) => artifact.size);
  }

  /// Business Logic: Check if has circular dependency
  bool hasCircularDependency(Set<ModuleId> visited) {
    if (visited.contains(id)) return true;

    visited.add(id);
    // Dependencies would need to be checked recursively with module map
    // This is a partial implementation - full check in DependencyResolver service

    return false;
  }

  /// Business Logic: Check if depends on module
  bool dependsOn(ModuleId moduleId) {
    return dependencies.contains(moduleId);
  }

  /// Validation: Validate all platform artifacts
  bool validateArtifacts() {
    return platformArtifacts.values.every((artifact) => artifact.isValid);
  }

  /// Get supported platforms
  List<PlatformIdentifier> get supportedPlatforms {
    return platformArtifacts.keys.toList();
  }

  /// Get display name with version
  String get displayNameWithVersion => '$name v$version';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuntimeModule &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
