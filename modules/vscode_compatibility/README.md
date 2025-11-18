# VS Code Compatibility - Facade Module

Integration layer that coordinates all VS Code runtime management packages into a unified system.

## Overview

This facade module provides:

- **Unified API**: Single entry point through `VSCodeCompatibilityFacade`
- **Dependency Injection**: Coordinated initialization of all layers
- **Clean Integration**: Hides architectural complexity
- **Type Safety**: Full type safety across all layers
- **Testability**: Easy mocking and testing support

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│              VSCodeCompatibilityFacade                  │
│              (Simple, Clean API)                        │
└──────────────────────┬──────────────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         │             │             │
┌────────▼────────┐ ┌──▼──────────┐ ┌▼─────────────┐
│  Presentation   │ │ Application │ │Infrastructure│
│  (MobX Stores)  │ │ (Commands)  │ │ (Services)   │
└────────┬────────┘ └──┬──────────┘ └┬─────────────┘
         │             │              │
         └─────────────┼──────────────┘
                       │
              ┌────────▼────────┐
              │     Domain      │
              │  (Business      │
              │     Logic)      │
              └─────────────────┘
```

## Quick Start

### 1. Add Dependency

```yaml
dependencies:
  vscode_compatibility:
    path: ../../modules/vscode_compatibility
```

### 2. Initialize

```dart
import 'package:flutter/material.dart';
import 'package:vscode_compatibility/vscode_compatibility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all layers
  await configureVSCodeRuntimeDependencies();

  runApp(MyApp());
}
```

### 3. Use the Facade

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final facade = getIt<VSCodeCompatibilityFacade>();

    return MaterialApp(
      home: RuntimeSetupScreen(facade: facade),
    );
  }
}

class RuntimeSetupScreen extends StatefulWidget {
  final VSCodeCompatibilityFacade facade;

  const RuntimeSetupScreen({required this.facade});

  @override
  State<RuntimeSetupScreen> createState() => _RuntimeSetupScreenState();
}

class _RuntimeSetupScreenState extends State<RuntimeSetupScreen> {
  @override
  void initState() {
    super.initState();
    _checkRuntimeStatus();
  }

  Future<void> _checkRuntimeStatus() async {
    final isReady = await widget.facade.isRuntimeReady();

    if (!isReady) {
      _showInstallDialog();
    }
  }

  Future<void> _showInstallDialog() async {
    // Option 1: Use the facade directly
    await widget.facade.installAllCriticalModules(
      onProgress: (moduleId, progress) {
        setState(() {
          // Update UI with progress
        });
      },
    );

    // Option 2: Use the presentation layer dialog
    final result = await RuntimeInstallationDialog.show(
      context,
      installationStore: getIt<RuntimeInstallationStore>(),
      moduleListStore: getIt<ModuleListStore>(),
      trigger: InstallationTrigger.firstRun,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... UI implementation
    return Scaffold(
      appBar: AppBar(title: const Text('VS Code Runtime')),
      body: RuntimeStatusWidget(
        store: getIt<RuntimeStatusStore>(),
        onInstallRequested: _showInstallDialog,
      ),
    );
  }
}
```

## API Reference

### VSCodeCompatibilityFacade

#### Runtime Management

**`getRuntimeStatus()`**
```dart
Future<Either<ApplicationException, RuntimeStatusDto>> getRuntimeStatus()
```
Get current runtime installation status.

**`installRuntime()`**
```dart
Future<Either<ApplicationException, Unit>> installRuntime({
  List<ModuleId> modules = const [],
  InstallationTrigger trigger = InstallationTrigger.manual,
  void Function(ModuleId moduleId, double progress)? onProgress,
  Object? cancelToken,
})
```
Install VS Code runtime with specified modules.

**`cancelInstallation()`**
```dart
Future<Either<ApplicationException, Unit>> cancelInstallation({
  required InstallationId installationId,
  String? reason,
})
```
Cancel an ongoing installation.

**`uninstallRuntime()`**
```dart
Future<Either<ApplicationException, Unit>> uninstallRuntime({
  List<ModuleId> modules = const [],
  bool keepDownloads = false,
})
```
Uninstall runtime modules.

**`checkForUpdates()`**
```dart
Future<Either<ApplicationException, Unit>> checkForUpdates()
```
Check for available runtime updates.

#### Information Queries

**`getInstallationProgress()`**
```dart
Future<Either<ApplicationException, InstallationProgressDto>>
    getInstallationProgress({
  required InstallationId installationId,
})
```
Get detailed progress for a specific installation.

**`getAvailableModules()`**
```dart
Future<Either<ApplicationException, List<ModuleInfoDto>>>
    getAvailableModules({
  PlatformIdentifier? platformFilter,
  bool includeOptional = true,
})
```
Get list of available modules with metadata.

**`getPlatformInfo()`**
```dart
Future<Either<ApplicationException, PlatformInfoDto>> getPlatformInfo()
```
Get current platform information and compatibility.

#### Convenience Methods

**`installAllCriticalModules()`**
```dart
Future<Either<ApplicationException, Unit>> installAllCriticalModules({
  void Function(ModuleId moduleId, double progress)? onProgress,
})
```
Install all critical (non-optional) modules for current platform.

**`isRuntimeReady()`**
```dart
Future<bool> isRuntimeReady()
```
Check if runtime is installed and ready to use.

**`getStatusSummary()`**
```dart
Future<String> getStatusSummary()
```
Get human-readable summary of current status.

## Usage Examples

### Example 1: Check and Install Runtime

```dart
final facade = getIt<VSCodeCompatibilityFacade>();

// Check status
final summary = await facade.getStatusSummary();
print(summary); // "VS Code runtime is not installed"

// Install with progress
await facade.installAllCriticalModules(
  onProgress: (moduleId, progress) {
    print('${moduleId.value}: ${(progress * 100).toStringAsFixed(1)}%');
  },
);

// Verify
final isReady = await facade.isRuntimeReady();
print('Runtime ready: $isReady'); // true
```

### Example 2: Selective Module Installation

```dart
final facade = getIt<VSCodeCompatibilityFacade>();

// Get available modules
final modulesResult = await facade.getAvailableModules();

modulesResult.fold(
  (error) => print('Error: ${error.message}'),
  (modules) {
    // Show modules to user, let them select

    final selectedModules = modules
        .where((m) => !m.isOptional)
        .map((m) => m.id)
        .toList();

    // Install selected modules
    facade.installRuntime(
      modules: selectedModules,
      onProgress: (moduleId, progress) {
        // Update UI
      },
    );
  },
);
```

### Example 3: Handle Installation with UI

```dart
class InstallationPage extends StatefulWidget {
  @override
  State<InstallationPage> createState() => _InstallationPageState();
}

class _InstallationPageState extends State<InstallationPage> {
  final facade = getIt<VSCodeCompatibilityFacade>();
  String currentModule = '';
  double progress = 0.0;
  bool isInstalling = false;

  Future<void> _install() async {
    setState(() => isInstalling = true);

    final result = await facade.installAllCriticalModules(
      onProgress: (moduleId, prog) {
        setState(() {
          currentModule = moduleId.value;
          progress = prog;
        });
      },
    );

    result.fold(
      (error) {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.message}')),
        );
      },
      (_) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Installation complete!')),
        );
      },
    );

    setState(() => isInstalling = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Runtime Installation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isInstalling) ...[
              Text('Installing: $currentModule'),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
            ] else ...[
              ElevatedButton(
                onPressed: _install,
                child: const Text('Install Runtime'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Example 4: Using MobX Stores Directly

```dart
class RuntimeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statusStore = getIt<RuntimeStatusStore>();
    final installationStore = getIt<RuntimeInstallationStore>();
    final moduleListStore = getIt<ModuleListStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Runtime Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status widget (reactive with MobX)
            RuntimeStatusWidget(
              store: statusStore,
              onInstallRequested: () => _showInstallDialog(
                context,
                installationStore,
                moduleListStore,
              ),
            ),

            const SizedBox(height: 16),

            // Platform info
            Observer(
              builder: (_) {
                if (moduleListStore.platformInfo != null) {
                  return PlatformInfoWidget(
                    platformInfo: moduleListStore.platformInfo!,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInstallDialog(
    BuildContext context,
    RuntimeInstallationStore installationStore,
    ModuleListStore moduleListStore,
  ) async {
    await RuntimeInstallationDialog.show(
      context,
      installationStore: installationStore,
      moduleListStore: moduleListStore,
      trigger: InstallationTrigger.settings,
    );
  }
}
```

## Dependency Injection

### Initialization Order

The facade initializes all layers in the correct dependency order:

1. **Infrastructure Layer**: Repositories and services
2. **Application Layer**: Command and query handlers
3. **Presentation Layer**: MobX stores
4. **Facade Layer**: Coordination and external modules

```dart
await configureVSCodeRuntimeDependencies();
```

### Available Dependencies

After initialization, you can get any registered dependency:

```dart
// Facade
final facade = getIt<VSCodeCompatibilityFacade>();

// Stores (Presentation)
final statusStore = getIt<RuntimeStatusStore>();
final installationStore = getIt<RuntimeInstallationStore>();
final moduleListStore = getIt<ModuleListStore>();

// Handlers (Application)
final installHandler = getIt<InstallRuntimeCommandHandler>();
final statusHandler = getIt<GetRuntimeStatusQueryHandler>();

// Services (Infrastructure)
final downloadService = getIt<IDownloadService>();
final platformService = getIt<IPlatformService>();

// Repositories (Infrastructure)
final runtimeRepo = getIt<IRuntimeRepository>();
final manifestRepo = getIt<IManifestRepository>();
```

## Testing

### Unit Testing

```dart
void main() {
  test('facade returns runtime status', () async {
    await configureTestDependencies();

    final facade = getIt<VSCodeCompatibilityFacade>();
    final result = await facade.getRuntimeStatus();

    expect(result.isRight(), isTrue);
  });
}
```

### Widget Testing

```dart
void main() {
  testWidgets('shows installation dialog', (tester) async {
    await configureTestDependencies();

    await tester.pumpWidget(
      MaterialApp(
        home: RuntimeSettingsPage(),
      ),
    );

    expect(find.byType(RuntimeStatusWidget), findsOneWidget);
  });
}
```

## Error Handling

All facade methods return `Either<ApplicationException, T>`:

```dart
final result = await facade.installRuntime(modules: [...]);

result.fold(
  (error) {
    // Handle error
    print('Installation failed: ${error.message}');
  },
  (_) {
    // Success
    print('Installation completed successfully');
  },
);
```

## Packages Integrated

This facade integrates the following packages:

| Package | Layer | Purpose |
|---------|-------|---------|
| `vscode_runtime_core` | Domain | Business logic, entities, value objects |
| `vscode_runtime_infrastructure` | Infrastructure | Repositories, services, external integrations |
| `vscode_runtime_application` | Application | Commands, queries, use cases |
| `vscode_runtime_presentation` | Presentation | MobX stores, Flutter widgets |

## Key Features

✅ Clean, unified API for runtime management
✅ Automatic dependency initialization
✅ Type-safe command and query handling
✅ Real-time progress tracking
✅ Platform compatibility checking
✅ Modular installation support
✅ Update management
✅ Complete error handling
✅ Testable architecture
✅ Production-ready

## Architecture Benefits

1. **Separation of Concerns**: Each layer has clear responsibilities
2. **Dependency Rule**: Dependencies point inward (toward domain)
3. **Testability**: Easy to mock and test each layer
4. **Flexibility**: Swap implementations without changing domain
5. **Maintainability**: Changes are localized to specific layers
6. **Scalability**: Easy to add new features following the same pattern

## Next Steps

1. **Run code generation**: `dart run build_runner build --delete-conflicting-outputs`
2. **Use in your app**: Import and initialize the facade
3. **Customize**: Extend the facade for your specific needs
4. **Test**: Write tests using the provided test configuration
