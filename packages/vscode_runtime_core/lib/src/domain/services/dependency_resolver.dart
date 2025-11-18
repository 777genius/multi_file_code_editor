import 'package:dartz/dartz.dart';
import '../entities/runtime_module.dart';
import '../value_objects/module_id.dart';
import '../exceptions/domain_exception.dart';
import 'i_dependency_resolver.dart';

/// Dependency Resolver Implementation
/// Resolves module dependencies and determines installation order
class DependencyResolver implements IDependencyResolver {
  @override
  Either<DependencyException, List<RuntimeModule>> resolveOrder(
    List<RuntimeModule> modules,
  ) {
    try {
      final moduleMap = {for (var m in modules) m.id: m};

      // Check for circular dependencies first
      if (hasCircularDependencies(modules)) {
        return left(
          const DependencyException('Circular dependencies detected'),
        );
      }

      // Topological sort using Kahn's algorithm
      final result = <RuntimeModule>[];
      final inDegree = <ModuleId, int>{};
      final adjList = <ModuleId, List<ModuleId>>{};

      // Initialize in-degree and adjacency list
      for (final module in modules) {
        inDegree[module.id] = 0;
        adjList[module.id] = [];
      }

      // Build graph and calculate in-degrees
      for (final module in modules) {
        for (final depId in module.dependencies) {
          // Check if dependency exists in the module list
          if (!moduleMap.containsKey(depId)) {
            return left(
              DependencyException(
                'Missing dependency: ${module.id.value} depends on '
                '${depId.value}, but it is not in the module list',
              ),
            );
          }

          adjList[depId]!.add(module.id);
          inDegree[module.id] = (inDegree[module.id] ?? 0) + 1;
        }
      }

      // Queue of modules with no dependencies
      final queue = <ModuleId>[];
      for (final entry in inDegree.entries) {
        if (entry.value == 0) {
          queue.add(entry.key);
        }
      }

      // Process modules in dependency order
      while (queue.isNotEmpty) {
        final currentId = queue.removeAt(0);
        final currentModule = moduleMap[currentId];

        if (currentModule != null) {
          result.add(currentModule);
        }

        // Reduce in-degree for dependent modules
        for (final dependentId in adjList[currentId]!) {
          inDegree[dependentId] = inDegree[dependentId]! - 1;

          if (inDegree[dependentId] == 0) {
            queue.add(dependentId);
          }
        }
      }

      // If result doesn't contain all modules, there was a cycle
      if (result.length != modules.length) {
        return left(
          const DependencyException(
            'Unresolvable dependencies or circular dependency detected',
          ),
        );
      }

      return right(result);
    } catch (e) {
      return left(
        DependencyException('Failed to resolve dependencies: ${e.toString()}'),
      );
    }
  }

  @override
  bool hasCircularDependencies(List<RuntimeModule> modules) {
    final moduleMap = {for (var m in modules) m.id: m};
    final visited = <ModuleId>{};

    for (final module in modules) {
      if (_hasCircularDependency(module, moduleMap, visited, {})) {
        return true;
      }
    }

    return false;
  }

  @override
  List<ModuleId> getTransitiveDependencies(
    RuntimeModule module,
    Map<ModuleId, RuntimeModule> moduleMap,
  ) {
    final result = <ModuleId>{};
    final visited = <ModuleId>{};

    _collectTransitiveDependencies(module, moduleMap, result, visited);

    return result.toList();
  }

  // Private helper methods

  bool _hasCircularDependency(
    RuntimeModule module,
    Map<ModuleId, RuntimeModule> moduleMap,
    Set<ModuleId> globalVisited,
    Set<ModuleId> currentPath,
  ) {
    // If module is in current path, we have a cycle
    if (currentPath.contains(module.id)) {
      return true;
    }

    // If already fully processed, skip
    if (globalVisited.contains(module.id)) {
      return false;
    }

    // Add to current path
    currentPath.add(module.id);

    // Check all dependencies
    for (final depId in module.dependencies) {
      final dep = moduleMap[depId];

      if (dep != null) {
        if (_hasCircularDependency(dep, moduleMap, globalVisited, currentPath)) {
          return true;
        }
      }
    }

    // Remove from current path and mark as visited
    currentPath.remove(module.id);
    globalVisited.add(module.id);

    return false;
  }

  void _collectTransitiveDependencies(
    RuntimeModule module,
    Map<ModuleId, RuntimeModule> moduleMap,
    Set<ModuleId> result,
    Set<ModuleId> visited,
  ) {
    // Prevent infinite recursion
    if (visited.contains(module.id)) {
      return;
    }

    visited.add(module.id);

    // Add direct dependencies
    for (final depId in module.dependencies) {
      result.add(depId);

      // Recursively add transitive dependencies
      final dep = moduleMap[depId];
      if (dep != null) {
        _collectTransitiveDependencies(dep, moduleMap, result, visited);
      }
    }
  }
}
