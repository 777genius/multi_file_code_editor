import 'package:flutter/material.dart';
import 'package:editor_core/editor_core.dart';
import '../../controllers/editor_controller.dart';
import '../../controllers/file_tree_controller.dart';
import '../../state/editor_state.dart';
import '../code_editor/monaco_code_editor.dart';
import '../code_editor/editor_config.dart';
import '../file_tree/file_tree_view.dart';

class EditorScaffold extends StatefulWidget {
  final FileTreeController fileTreeController;
  final EditorController editorController;
  final EditorConfig editorConfig;
  final double treeWidth;
  final Widget? customHeader;
  final Widget? customFooter;

  const EditorScaffold({
    super.key,
    required this.fileTreeController,
    required this.editorController,
    this.editorConfig = const EditorConfig(),
    this.treeWidth = 250,
    this.customHeader,
    this.customFooter,
  });

  @override
  State<EditorScaffold> createState() => _EditorScaffoldState();
}

class _EditorScaffoldState extends State<EditorScaffold> {
  @override
  void initState() {
    super.initState();
    widget.fileTreeController.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (widget.customHeader != null) widget.customHeader!,
          Expanded(
            child: Row(
              children: [
                FileTreeView(
                  controller: widget.fileTreeController,
                  width: widget.treeWidth,
                  onFileSelected: (fileId) async {
                    await widget.editorController.loadFile(fileId);
                  },
                ),
                Expanded(
                  child: ValueListenableBuilder<EditorState>(
                    valueListenable: widget.editorController,
                    builder: (context, state, _) {
                      return state.when(
                        initial: () => _buildEmptyEditor(context),
                        loading: () => _buildLoadingEditor(context),
                        loaded:
                            (file, isDirty, isSaving) => _buildLoadedEditor(
                              context,
                              file,
                              isDirty,
                              isSaving,
                            ),
                        error: (message) => _buildErrorEditor(context, message),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (widget.customFooter != null) widget.customFooter!,
        ],
      ),
    );
  }

  Widget _buildEmptyEditor(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No file selected',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a file from the tree to start editing',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingEditor(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoadedEditor(
    BuildContext context,
    FileDocument file,
    bool isDirty,
    bool isSaving,
  ) {
    return Column(
      children: [
        _buildEditorHeader(context, file, isDirty, isSaving),
        const Divider(height: 1),
        Expanded(
          child: MonacoCodeEditor(
            key: ValueKey('monaco-${file.id}'),
            code: file.content,
            language: file.language,
            config: widget.editorConfig,
            onChanged: (newContent) {
              widget.editorController.updateContent(newContent);
            },
          ),
        ),
        if (isDirty) _buildDirtyIndicator(context),
      ],
    );
  }

  Widget _buildEditorHeader(
    BuildContext context,
    FileDocument file,
    bool isDirty,
    bool isSaving,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file,
            size: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              file.name,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (isDirty) ...[
            Text(
              'Modified',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (isSaving)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (isDirty)
            IconButton(
              icon: const Icon(Icons.save, size: 18),
              tooltip: 'Save (Ctrl+S)',
              onPressed: () async {
                await widget.editorController.save();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            tooltip: 'Close',
            onPressed: () {
              widget.editorController.close();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildDirtyIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            'You have unsaved changes',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () async {
              await widget.editorController.save();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorEditor(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                widget.editorController.close();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
