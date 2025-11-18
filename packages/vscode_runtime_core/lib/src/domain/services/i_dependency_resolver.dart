import 'package:dartz/dartz.dart';
import '../entities/runtime_module.dart';
import '../value_objects/module_id.dart';
import '../exceptions/domain_exception.dart';

/// Domain Service: Dependency Resolution
/// Stateless service that doesn't belong to any specific entity
/// Resolves module installation order based on dependencies
abstract class IDependencyResolver {
  /// Resolve installation order using topological sort
  /// Returns modules in order where all dependencies come first
  Either<DependencyException, List<RuntimeModule>> resolveOrder(
    List<RuntimeModule> modules,
  );

  /// Detect circular dependencies in module graph
  /// Returns true if circular dependencies exist
  bool hasCircularDependencies(List<RuntimeModule> modules);

  /// Get all transitive dependencies for a module
  /// Includes direct and indirect dependencies
  List<ModuleId> getTransitiveDependencies(
    RuntimeModule module,
    Map<ModuleId, RuntimeModule> moduleMap,
  );

  /// Get modules that depend on the given module
  /// (reverse dependencies)
  List<RuntimeModule> getDependents(
    ModuleId moduleId,
    List<RuntimeModule> allModules,
  );

  /// Validate that all dependencies are resolvable
  /// Checks that all referenced dependencies exist
  Either<DependencyException, Unit> validateDependencies(
    List<RuntimeModule> modules,
  );

  /// Get dependency graph as adjacency list
  Map<ModuleId, List<ModuleId>> buildDependencyGraph(
    List<RuntimeModule> modules,
  );
}
