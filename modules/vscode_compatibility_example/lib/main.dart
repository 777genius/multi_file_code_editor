import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vscode_compatibility/vscode_compatibility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all VS Code runtime dependencies
  await configureVSCodeRuntimeDependencies();

  runApp(const VSCodeRuntimeExampleApp());
}

class VSCodeRuntimeExampleApp extends StatelessWidget {
  const VSCodeRuntimeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VS Code Runtime Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RuntimeManagementPage(),
    );
  }
}

class RuntimeManagementPage extends StatefulWidget {
  const RuntimeManagementPage({super.key});

  @override
  State<RuntimeManagementPage> createState() => _RuntimeManagementPageState();
}

class _RuntimeManagementPageState extends State<RuntimeManagementPage> {
  late final VSCodeCompatibilityFacade _facade;
  late final RuntimeStatusStore _statusStore;
  late final RuntimeInstallationStore _installationStore;
  late final ModuleListStore _moduleListStore;

  String _statusSummary = 'Loading...';

  @override
  void initState() {
    super.initState();

    // Get dependencies from DI container
    _facade = getIt<VSCodeCompatibilityFacade>();
    _statusStore = getIt<RuntimeStatusStore>();
    _installationStore = getIt<RuntimeInstallationStore>();
    _moduleListStore = getIt<ModuleListStore>();

    // Load initial state
    _loadStatus();
    _moduleListStore.initialize();
  }

  Future<void> _loadStatus() async {
    await _statusStore.loadStatus();

    final summary = await _facade.getStatusSummary();
    setState(() {
      _statusSummary = summary;
    });
  }

  Future<void> _showInstallDialog() async {
    final result = await RuntimeInstallationDialog.show(
      context,
      installationStore: _installationStore,
      moduleListStore: _moduleListStore,
      trigger: InstallationTrigger.manual,
    );

    if (result == true) {
      // Refresh status after installation
      await _loadStatus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Runtime installed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _checkForUpdates() async {
    final result = await _facade.checkForUpdates();

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.message}')),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No updates available')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VS Code Runtime Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatus,
            tooltip: 'Refresh status',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_statusSummary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Runtime Status Widget (reactive with MobX)
            RuntimeStatusWidget(
              store: _statusStore,
              onInstallRequested: _showInstallDialog,
              onUpdateRequested: _showInstallDialog,
            ),

            const SizedBox(height: 16),

            // Platform Info Widget
            Observer(
              builder: (_) {
                if (_moduleListStore.platformInfo != null) {
                  return PlatformInfoWidget(
                    platformInfo: _moduleListStore.platformInfo!,
                  );
                }
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Loading platform information...'),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _showInstallDialog,
                      icon: const Icon(Icons.download),
                      label: const Text('Install/Manage Runtime'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _checkForUpdates,
                      icon: const Icon(Icons.update),
                      label: const Text('Check for Updates'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Facade API Example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Facade API Example',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _installUsingFacade,
                      child: const Text('Install All Critical Modules'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This demonstrates using the facade directly without UI components',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _installUsingFacade() async {
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const FacadeInstallationDialog(),
    );

    // Install using facade
    final result = await _facade.installAllCriticalModules(
      onProgress: (moduleId, progress) {
        // Progress is handled by the dialog
        debugPrint('Installing ${moduleId.value}: ${(progress * 100).toStringAsFixed(1)}%');
      },
    );

    // Close progress dialog
    if (mounted) {
      Navigator.of(context).pop();
    }

    // Show result
    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Installation failed: ${error.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        _loadStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Installation completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }
}

/// Simple dialog showing installation progress when using facade directly
class FacadeInstallationDialog extends StatelessWidget {
  const FacadeInstallationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Installing Runtime'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Installing VS Code runtime components...'),
        ],
      ),
    );
  }
}
