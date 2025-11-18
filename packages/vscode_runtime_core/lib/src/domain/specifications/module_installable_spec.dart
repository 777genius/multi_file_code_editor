import '../entities/runtime_module.dart';
import '../value_objects/module_id.dart';
import 'specification.dart';

/// Specification: Module Not Already Installed
class ModuleNotInstalledSpecification extends Specification<RuntimeModule> {
  final Set<ModuleId> installedModules;

  ModuleNotInstalledSpecification(this.installedModules);

  @override
  bool isSatisfiedBy(RuntimeModule candidate) {
    return !installedModules.contains(candidate.id);
  }

  @override
  String get description => 'Module must not be already installed';
}

/// Specification: Module Has Valid Artifacts
class ModuleHasValidArtifactsSpecification extends Specification<RuntimeModule> {
  @override
  bool isSatisfiedBy(RuntimeModule candidate) {
    return candidate.validateArtifacts();
  }

  @override
  String get description => 'Module must have valid artifacts';
}

/// Specification: Module Is Critical (Required)
class ModuleIsCriticalSpecification extends Specification<RuntimeModule> {
  @override
  bool isSatisfiedBy(RuntimeModule candidate) {
    return candidate.isCritical;
  }

  @override
  String get description => 'Module must be critical (non-optional)';
}
