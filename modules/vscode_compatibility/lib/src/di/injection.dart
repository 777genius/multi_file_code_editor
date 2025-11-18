import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Import all layer DI modules
import 'package:vscode_runtime_infrastructure/vscode_runtime_infrastructure.dart'
    as infrastructure;
import 'package:vscode_runtime_application/vscode_runtime_application.dart'
    as application;
import 'package:vscode_runtime_presentation/vscode_runtime_presentation.dart'
    as presentation;

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Configure all VS Code runtime dependencies in the correct order
///
/// This initializes all layers:
/// 1. Infrastructure Layer (repositories, services)
/// 2. Application Layer (commands, queries, handlers)
/// 3. Presentation Layer (stores, widgets)
/// 4. Facade Layer (coordination, external modules)
///
/// Usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await configureVSCodeRuntimeDependencies();
///   runApp(MyApp());
/// }
/// ```
Future<void> configureVSCodeRuntimeDependencies({
  Environment? environment,
}) async {
  final env = environment ?? Environment.prod;

  // 1. Infrastructure Layer
  await infrastructure.configureInfrastructureDependencies();

  // 2. Application Layer
  await application.configureApplicationDependencies();

  // 3. Presentation Layer
  await presentation.configurePresentationDependencies();

  // 4. Facade Layer (this module's additional bindings)
  await getIt.init(environment: env.name);
}

/// Configure dependencies for testing with mocks
Future<void> configureTestDependencies() async {
  await configureVSCodeRuntimeDependencies(
    environment: Environment.test,
  );
}

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureFacadeDependencies() => getIt.init();
