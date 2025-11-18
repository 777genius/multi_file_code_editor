import '../entities/runtime_module.dart';
import '../value_objects/module_id.dart';
import 'specification.dart';

/// Specification: Dependencies Met
/// Business rule: All module dependencies must be installed
class DependenciesMetSpecification extends Specification<RuntimeModule> {
  final Set<ModuleId> installedModules;

  DependenciesMetSpecification(this.installedModules);

  @override
  bool isSatisfiedBy(RuntimeModule candidate) {
    return candidate.dependencies.every(
      (dep) => installedModules.contains(dep),
    );
  }

  @override
  String get description => 'All dependencies must be installed';
}

/// Specification: Can Install Module
/// Composite: Module must be compatible AND dependencies met
class CanInstallModuleSpecification extends Specification<RuntimeModule> {
  final PlatformCompatibleSpecification platformSpec;
  final DependenciesMetSpecification depsSpec;

  CanInstallModuleSpecification({
    required PlatformIdentifier platform,
    required Set<ModuleId> installedModules,
  })  : platformSpec = PlatformCompatibleSpecification(platform),
        depsSpec = DependenciesMetSpecification(installedModules);

  @override
  bool isSatisfiedBy(RuntimeModule candidate) {
    return platformSpec.isSatisfiedBy(candidate) &&
        depsSpec.isSatisfiedBy(candidate);
  }

  @override
  String get description =>
      '${platformSpec.description} AND ${depsSpec.description}';
}
