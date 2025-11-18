# VS Code Runtime Manager - Example App

Example Flutter application demonstrating the VS Code runtime management system.

## Features

This example demonstrates:

✅ **Facade API Usage**: Direct usage of `VSCodeCompatibilityFacade`
✅ **MobX Integration**: Using reactive stores for state management
✅ **UI Components**: Pre-built widgets from presentation layer
✅ **Installation Flow**: Complete runtime installation with progress tracking
✅ **Status Monitoring**: Real-time status updates
✅ **Platform Detection**: Automatic platform compatibility checking
✅ **Module Management**: Selective module installation
✅ **Update Checking**: Check for runtime updates

## Running the Example

### 1. Generate Code

First, generate code for all packages:

```bash
# From the root of multi_editor_flutter
cd packages/vscode_runtime_application
dart run build_runner build --delete-conflicting-outputs

cd ../vscode_runtime_presentation
dart run build_runner build --delete-conflicting-outputs

cd ../../modules/vscode_compatibility
dart run build_runner build --delete-conflicting-outputs
```

### 2. Get Dependencies

```bash
cd modules/vscode_compatibility_example
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## Code Walkthrough

### main.dart

The example demonstrates two approaches:

#### Approach 1: Using Pre-built UI Components

```dart
// Use the RuntimeInstallationDialog from presentation layer
final result = await RuntimeInstallationDialog.show(
  context,
  installationStore: getIt<RuntimeInstallationStore>(),
  moduleListStore: getIt<ModuleListStore>(),
  trigger: InstallationTrigger.manual,
);
```

This provides a complete installation UI with:
- Module selection
- Progress tracking
- Error handling
- Cancellation support

#### Approach 2: Using the Facade Directly

```dart
// Use the facade for programmatic installation
final facade = getIt<VSCodeCompatibilityFacade>();

await facade.installAllCriticalModules(
  onProgress: (moduleId, progress) {
    print('Installing $moduleId: ${(progress * 100).toStringAsFixed(1)}%');
  },
);
```

This gives you full control over the installation process and UI.

### Key Components

**RuntimeStatusWidget**
```dart
RuntimeStatusWidget(
  store: getIt<RuntimeStatusStore>(),
  onInstallRequested: _showInstallDialog,
  onUpdateRequested: _showInstallDialog,
)
```
Displays current runtime status with action buttons.

**PlatformInfoWidget**
```dart
Observer(
  builder: (_) => _moduleListStore.platformInfo != null
      ? PlatformInfoWidget(platformInfo: _moduleListStore.platformInfo!)
      : CircularProgressIndicator(),
)
```
Shows platform information and compatibility.

**VSCodeCompatibilityFacade**
```dart
final facade = getIt<VSCodeCompatibilityFacade>();

// Check status
final summary = await facade.getStatusSummary();

// Install runtime
await facade.installAllCriticalModules();

// Check if ready
final isReady = await facade.isRuntimeReady();
```
Main entry point for all runtime operations.

## Architecture

The example follows Clean Architecture principles:

```
UI (main.dart)
    ↓
Facade (VSCodeCompatibilityFacade)
    ↓
┌─────────────┬──────────────┬────────────────┐
│Presentation │ Application  │ Infrastructure │
│  (Stores)   │  (Handlers)  │  (Services)    │
└─────────────┴──────────────┴────────────────┘
                      ↓
                   Domain
              (Business Logic)
```

## Extending the Example

### Add Custom Installation Logic

```dart
// Get available modules
final modulesResult = await facade.getAvailableModules();

modulesResult.fold(
  (error) => print(error.message),
  (modules) {
    // Filter modules based on your criteria
    final selectedModules = modules
        .where((m) => /* your condition */)
        .map((m) => m.id)
        .toList();

    // Install selected modules
    facade.installRuntime(modules: selectedModules);
  },
);
```

### Add Custom Progress UI

```dart
class CustomProgressDialog extends StatefulWidget {
  @override
  State<CustomProgressDialog> createState() => _CustomProgressDialogState();
}

class _CustomProgressDialogState extends State<CustomProgressDialog> {
  String currentModule = '';
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Installing Runtime'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Current: $currentModule'),
          LinearProgressIndicator(value: progress),
          Text('${(progress * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}
```

### Monitor Installation Progress

```dart
final facade = getIt<VSCodeCompatibilityFacade>();

await facade.installRuntime(
  modules: selectedModules,
  onProgress: (moduleId, progress) {
    setState(() {
      currentModule = moduleId.value;
      this.progress = progress;
    });
  },
);
```

## Error Handling

The example demonstrates proper error handling:

```dart
final result = await facade.installAllCriticalModules();

result.fold(
  (error) {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${error.message}'),
        backgroundColor: Colors.red,
      ),
    );
  },
  (_) {
    // Handle success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Installation complete!'),
        backgroundColor: Colors.green,
      ),
    );
  },
);
```

## Testing

To test the example:

```dart
void main() {
  testWidgets('shows runtime status', (tester) async {
    await configureTestDependencies();

    await tester.pumpWidget(const VSCodeRuntimeExampleApp());

    expect(find.byType(RuntimeStatusWidget), findsOneWidget);
  });
}
```

## Next Steps

1. Customize the UI to match your app's design
2. Add additional features (logging, analytics, etc.)
3. Integrate with your existing plugin system
4. Add error recovery and retry logic
5. Implement offline mode support

## Resources

- [Facade Module Documentation](../vscode_compatibility/README.md)
- [Presentation Layer Documentation](../../packages/vscode_runtime_presentation/README.md)
- [Application Layer Documentation](../../packages/vscode_runtime_application/README.md)
- [Architecture Plan](/docs/plans/vscode-compatibility-architecture.md)
