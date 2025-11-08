import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/editor/editor_bloc.dart';
import '../bloc/lsp/lsp_bloc.dart';
import '../widgets/editor_view.dart';

/// IdeScreen
///
/// Main IDE screen that brings together all IDE components.
///
/// Architecture:
/// - Part of Presentation layer
/// - Provides BLoCs to child widgets
/// - Coordinates multiple UI components
///
/// Layout:
/// ```
/// ┌─────────────────────────────────────┐
/// │ AppBar (Title, Actions)             │
/// ├─────────┬───────────────────────────┤
/// │ File    │                           │
/// │ Explorer│   Editor View             │
/// │         │   (Code Editor)           │
/// │         │                           │
/// ├─────────┴───────────────────────────┤
/// │ Status Bar (Language, Diagnostics)  │
/// └─────────────────────────────────────┘
/// ```
///
/// Example:
/// ```dart
/// MaterialApp(
///   home: IdeScreen(),
/// );
/// ```
class IdeScreen extends StatelessWidget {
  const IdeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide EditorBloc
        BlocProvider(
          create: (context) => context.read<EditorBloc>(),
        ),
        // Provide LspBloc
        BlocProvider(
          create: (context) => context.read<LspBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildStatusBar(),
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Flutter IDE'),
      backgroundColor: const Color(0xFF2D2D30), // VS Code dark theme
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        // File menu
        IconButton(
          icon: const Icon(Icons.folder_open),
          tooltip: 'Open File',
          onPressed: () {
            // TODO: Implement file picker
          },
        ),
        // Save button
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Save',
          onPressed: () {
            // TODO: Implement save
          },
        ),
        // Settings
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            // TODO: Implement settings
          },
        ),
      ],
    );
  }

  /// Builds the main body
  Widget _buildBody() {
    return Row(
      children: [
        // File Explorer Sidebar (left)
        _buildSidebar(),

        // Main Editor Area (center)
        const Expanded(
          child: EditorView(),
        ),

        // Optional: Right sidebar for diagnostics/outline
        // _buildRightSidebar(),
      ],
    );
  }

  /// Builds the left sidebar (file explorer)
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF252526),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar header
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'EXPLORER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // File tree
          Expanded(
            child: ListView(
              children: [
                _buildFileTreeItem(
                  icon: Icons.folder,
                  name: 'src',
                  isDirectory: true,
                ),
                _buildFileTreeItem(
                  icon: Icons.insert_drive_file,
                  name: 'main.dart',
                  indent: 1,
                ),
                _buildFileTreeItem(
                  icon: Icons.insert_drive_file,
                  name: 'app.dart',
                  indent: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a file tree item
  Widget _buildFileTreeItem({
    required IconData icon,
    required String name,
    bool isDirectory = false,
    int indent = 0,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Open file
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0 + (indent * 16.0),
          top: 8,
          bottom: 8,
          right: 16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDirectory ? Colors.amber : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the status bar
  Widget _buildStatusBar() {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, editorState) {
        return BlocBuilder<LspBloc, LspState>(
          builder: (context, lspState) {
            return Container(
              height: 24,
              color: const Color(0xFF007ACC), // VS Code blue
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Language indicator
                  if (editorState is EditorReadyState) ...[
                    const Icon(
                      Icons.code,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      editorState.languageId?.value ?? 'Plain Text',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],

                  // Cursor position
                  if (editorState is EditorReadyState) ...[
                    Text(
                      'Ln ${editorState.cursorPosition.line + 1}, '
                      'Col ${editorState.cursorPosition.column + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],

                  const Spacer(),

                  // LSP status
                  _buildLspStatus(lspState),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds LSP status indicator
  Widget _buildLspStatus(LspState lspState) {
    if (lspState is LspReadyState) {
      return const Row(
        children: [
          Icon(Icons.check_circle, size: 14, color: Colors.green),
          SizedBox(width: 4),
          Text(
            'LSP Ready',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      );
    }

    if (lspState is LspInitializingState) {
      return const Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 4),
          Text(
            'Initializing...',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      );
    }

    if (lspState is LspErrorState) {
      return const Row(
        children: [
          Icon(Icons.error, size: 14, color: Colors.red),
          SizedBox(width: 4),
          Text(
            'LSP Error',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
