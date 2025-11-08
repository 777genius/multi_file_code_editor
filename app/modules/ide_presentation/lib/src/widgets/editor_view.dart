import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/editor/editor_bloc.dart';
import '../bloc/editor/editor_state.dart';
import '../bloc/editor/editor_event.dart';

/// EditorView
///
/// Main code editor widget that displays and edits text content.
///
/// Architecture:
/// - Part of Presentation layer
/// - Uses EditorBloc for state management
/// - Dispatches events on user interactions
/// - Rebuilds on state changes
///
/// Responsibilities:
/// - Displays editor content
/// - Handles text input and editing
/// - Shows cursor and selection
/// - Displays line numbers
/// - Handles keyboard shortcuts
///
/// Example:
/// ```dart
/// BlocProvider(
///   create: (context) => getIt<EditorBloc>(),
///   child: EditorView(),
/// );
/// ```
class EditorView extends StatefulWidget {
  const EditorView({super.key});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditorBloc, EditorState>(
      listener: (context, state) {
        // Update text controller when state changes
        if (state is EditorReadyState) {
          if (_controller.text != state.content) {
            _controller.text = state.content;
          }
        }
      },
      child: BlocBuilder<EditorBloc, EditorState>(
        builder: (context, state) {
          if (state is EditorInitialState) {
            return _buildEmptyState();
          }

          if (state is EditorLoadingState) {
            return _buildLoadingState(state.message);
          }

          if (state is EditorErrorState) {
            return _buildErrorState(state.message);
          }

          if (state is EditorReadyState) {
            return _buildEditor(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Builds empty state (no document opened)
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No document opened',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Builds loading state
  Widget _buildLoadingState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message),
          ],
        ],
      ),
    );
  }

  /// Builds error state
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message),
        ],
      ),
    );
  }

  /// Builds the main editor
  Widget _buildEditor(BuildContext context, EditorReadyState state) {
    return Container(
      color: const Color(0xFF1E1E1E), // VS Code dark background
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers
          _buildLineNumbers(state),

          // Editor content
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (text) {
                // Dispatch text changed event
                context.read<EditorBloc>().add(TextInsertedEvent(
                  text: text,
                  position: _controller.selection.baseOffset,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds line numbers column
  Widget _buildLineNumbers(EditorReadyState state) {
    final lineCount = state.content.split('\n').length;

    return Container(
      width: 60,
      color: const Color(0xFF252525), // Slightly lighter than editor
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          lineCount,
          (index) => Text(
            '${index + 1}',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: Color(0xFF858585),
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
