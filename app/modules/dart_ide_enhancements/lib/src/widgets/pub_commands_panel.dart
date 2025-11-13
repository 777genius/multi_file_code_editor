import 'package:flutter/material.dart';
import '../commands/pub_commands.dart';

/// UI panel for executing Dart pub commands.
///
/// Provides a simple interface for common pub operations:
/// - pub get
/// - pub upgrade
/// - pub outdated
/// - analyze
/// - format
///
/// This is a minimal UI that integrates with the IDE.
class PubCommandsPanel extends StatefulWidget {
  final String projectRoot;
  final bool isFlutterProject;

  const PubCommandsPanel({
    super.key,
    required this.projectRoot,
    this.isFlutterProject = false,
  });

  @override
  State<PubCommandsPanel> createState() => _PubCommandsPanelState();
}

class _PubCommandsPanelState extends State<PubCommandsPanel> {
  late PubCommands _pubCommands;
  String _output = '';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _pubCommands = PubCommands(projectRoot: widget.projectRoot);
  }

  Future<void> _executeCommand(
    Future<Either<String, String>> Function() command,
    String commandName,
  ) async {
    setState(() {
      _isRunning = true;
      _output = 'Executing $commandName...\n';
    });

    final result = await command();

    result.fold(
      (error) {
        setState(() {
          _output += '\n❌ Error:\n$error';
          _isRunning = false;
        });
      },
      (output) {
        setState(() {
          _output += '\n✅ Success:\n$output';
          _isRunning = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dart/Flutter Commands',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning
                      ? null
                      : () => _executeCommand(
                            () => _pubCommands.pubGet(
                              useFlutter: widget.isFlutterProject,
                            ),
                            'pub get',
                          ),
                  icon: const Icon(Icons.download),
                  label: const Text('pub get'),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning
                      ? null
                      : () => _executeCommand(
                            () => _pubCommands.pubUpgrade(
                              useFlutter: widget.isFlutterProject,
                            ),
                            'pub upgrade',
                          ),
                  icon: const Icon(Icons.upgrade),
                  label: const Text('pub upgrade'),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning
                      ? null
                      : () => _executeCommand(
                            () => _pubCommands.pubOutdated(
                              useFlutter: widget.isFlutterProject,
                            ),
                            'pub outdated',
                          ),
                  icon: const Icon(Icons.warning_amber),
                  label: const Text('pub outdated'),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning
                      ? null
                      : () => _executeCommand(
                            () => _pubCommands.analyze(
                              useFlutter: widget.isFlutterProject,
                            ),
                            'analyze',
                          ),
                  icon: const Icon(Icons.search),
                  label: const Text('analyze'),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning
                      ? null
                      : () => _executeCommand(
                            () => _pubCommands.format(fix: true),
                            'format',
                          ),
                  icon: const Icon(Icons.format_align_left),
                  label: const Text('format'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isRunning)
              const LinearProgressIndicator()
            else
              const SizedBox(height: 4),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _output.isEmpty ? 'Output will appear here...' : _output,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
