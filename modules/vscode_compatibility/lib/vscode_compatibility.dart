/// VS Code Extension Compatibility - Facade Module
///
/// This module provides a unified interface for VS Code runtime management,
/// integrating all architectural layers into a cohesive system.
///
/// ## Features
///
/// - **Runtime Installation**: Download and install Node.js + OpenVSCode Server
/// - **Module Management**: Selectively install runtime components
/// - **Progress Tracking**: Real-time installation progress
/// - **Platform Detection**: Automatic platform compatibility checking
/// - **Update Management**: Check and install runtime updates
/// - **Clean Architecture**: Layered design with clear boundaries
///
/// ## Quick Start
///
/// ```dart
/// import 'package:vscode_compatibility/vscode_compatibility.dart';
///
/// void main() async {
///   // Initialize dependency injection
///   await configureVSCodeRuntimeDependencies();
///
///   // Get the facade
///   final facade = getIt<VSCodeCompatibilityFacade>();
///
///   // Check if runtime is installed
///   final isReady = await facade.isRuntimeReady();
///
///   if (!isReady) {
///     // Install all critical modules
///     await facade.installAllCriticalModules(
///       onProgress: (moduleId, progress) {
///         print('$moduleId: ${(progress * 100).toStringAsFixed(1)}%');
///       },
///     );
///   }
/// }
/// ```
///
/// ## Architecture
///
/// This facade integrates the following layers:
///
/// - **Domain Layer** (`vscode_runtime_core`): Business logic and domain model
/// - **Infrastructure Layer** (`vscode_runtime_infrastructure`): Services and repositories
/// - **Application Layer** (`vscode_runtime_application`): Use cases and commands
/// - **Presentation Layer** (`vscode_runtime_presentation`): UI components and state
///
/// ## Dependency Injection
///
/// The module uses `get_it` and `injectable` for dependency injection:
///
/// ```dart
/// // Initialize all layers
/// await configureVSCodeRuntimeDependencies();
///
/// // Get any dependency
/// final facade = getIt<VSCodeCompatibilityFacade>();
/// final statusStore = getIt<RuntimeStatusStore>();
/// ```
///
/// ## Testing
///
/// For testing, use the test configuration:
///
/// ```dart
/// await configureTestDependencies();
/// ```
library vscode_compatibility;

// Core exports
export 'package:vscode_runtime_core/vscode_runtime_core.dart';
export 'package:vscode_runtime_application/vscode_runtime_application.dart';
export 'package:vscode_runtime_infrastructure/vscode_runtime_infrastructure.dart';
export 'package:vscode_runtime_presentation/vscode_runtime_presentation.dart';

// Facade exports
export 'src/di/injection.dart';
export 'src/vscode_compatibility_facade.dart';
