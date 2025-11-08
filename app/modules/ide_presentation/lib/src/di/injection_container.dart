import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lsp_application/lsp_application.dart';
import 'package:lsp_infrastructure/lsp_infrastructure.dart';
import 'package:lsp_domain/lsp_domain.dart';
import 'package:editor_core/editor_core.dart';

import '../bloc/editor/editor_bloc.dart';
import '../bloc/lsp/lsp_bloc.dart';

/// Dependency Injection Container
///
/// Configures and provides all dependencies for the IDE Presentation layer.
///
/// Architecture (Dependency Inversion Principle):
/// ```
/// Presentation Layer
///     ↓ depends on
/// Application Layer (Use Cases, Services)
///     ↓ depends on
/// Domain Layer (Interfaces/Ports)
///     ↑ implemented by
/// Infrastructure Layer (Adapters)
/// ```
///
/// Using:
/// - GetIt: Service locator for dependency injection
/// - Injectable: Code generation for dependency registration
///
/// Layers and their dependencies:
/// 1. **Infrastructure** (Adapters):
///    - WebSocketLspClientRepository implements ILspClientRepository
///    - NativeEditorRepository implements ICodeEditorRepository
///
/// 2. **Application** (Use Cases & Services):
///    - Use Cases depend on ILspClientRepository
///    - Services coordinate multiple use cases
///
/// 3. **Presentation** (BLoCs):
///    - BLoCs depend on Use Cases
///    - UI widgets depend on BLoCs
///
/// Example:
/// ```dart
/// // In main.dart
/// void main() async {
///   await configureDependencies();
///   runApp(MyApp());
/// }
///
/// // In widget
/// final bloc = getIt<EditorBloc>();
/// ```

final getIt = GetIt.instance;

/// Configures all dependencies
///
/// Must be called before using any dependencies.
/// Typically called in main() before runApp().
Future<void> configureDependencies() async {
  // ================================================================
  // Infrastructure Layer (Adapters)
  // ================================================================

  // LSP Infrastructure
  getIt.registerLazySingleton<ILspClientRepository>(
    () => WebSocketLspClientRepository(
      bridgeUrl: 'ws://localhost:9999',
      connectionTimeout: const Duration(seconds: 10),
      requestTimeout: const Duration(seconds: 30),
    ),
  );

  // Editor Infrastructure
  // TODO: Register NativeEditorRepository when editor_native FFI is ready
  // For now, we'll need a mock or in-memory implementation
  // getIt.registerLazySingleton<ICodeEditorRepository>(
  //   () => NativeEditorRepository(),
  // );

  // ================================================================
  // Application Layer (Use Cases & Services)
  // ================================================================

  // LSP Services
  getIt.registerLazySingleton<LspSessionService>(
    () => LspSessionService(
      lspRepository: getIt<ILspClientRepository>(),
    ),
  );

  // LSP Use Cases
  getIt.registerLazySingleton<InitializeLspSessionUseCase>(
    () => InitializeLspSessionUseCase(
      sessionService: getIt<LspSessionService>(),
    ),
  );

  getIt.registerLazySingleton<ShutdownLspSessionUseCase>(
    () => ShutdownLspSessionUseCase(
      sessionService: getIt<LspSessionService>(),
    ),
  );

  getIt.registerLazySingleton<GetCompletionsUseCase>(
    () => GetCompletionsUseCase(
      lspRepository: getIt<ILspClientRepository>(),
      // editorRepository: getIt<ICodeEditorRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetHoverInfoUseCase>(
    () => GetHoverInfoUseCase(
      lspRepository: getIt<ILspClientRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetDiagnosticsUseCase>(
    () => GetDiagnosticsUseCase(
      lspRepository: getIt<ILspClientRepository>(),
    ),
  );

  getIt.registerLazySingleton<GoToDefinitionUseCase>(
    () => GoToDefinitionUseCase(
      lspRepository: getIt<ILspClientRepository>(),
    ),
  );

  getIt.registerLazySingleton<FindReferencesUseCase>(
    () => FindReferencesUseCase(
      lspRepository: getIt<ILspClientRepository>(),
    ),
  );

  // ================================================================
  // Presentation Layer (BLoCs)
  // ================================================================

  // Editor BLoC
  // getIt.registerFactory<EditorBloc>(
  //   () => EditorBloc(
  //     editorRepository: getIt<ICodeEditorRepository>(),
  //   ),
  // );

  // LSP BLoC
  getIt.registerFactory<LspBloc>(
    () => LspBloc(
      initializeSessionUseCase: getIt<InitializeLspSessionUseCase>(),
      shutdownSessionUseCase: getIt<ShutdownLspSessionUseCase>(),
      getCompletionsUseCase: getIt<GetCompletionsUseCase>(),
      getHoverInfoUseCase: getIt<GetHoverInfoUseCase>(),
      getDiagnosticsUseCase: getIt<GetDiagnosticsUseCase>(),
      goToDefinitionUseCase: getIt<GoToDefinitionUseCase>(),
      findReferencesUseCase: getIt<FindReferencesUseCase>(),
    ),
  );
}

/// Resets all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
