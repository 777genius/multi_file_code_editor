import 'package:equatable/equatable.dart';
import 'package:editor_core/editor_core.dart';

/// States for EditorBloc
///
/// Represents the current state of the editor UI.
///
/// Architecture:
/// - Part of Presentation layer
/// - Immutable state objects
/// - UI rebuilds when state changes
abstract class EditorState extends Equatable {
  const EditorState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no document loaded
class EditorInitialState extends EditorState {
  const EditorInitialState();
}

/// Loading document or performing operation
class EditorLoadingState extends EditorState {
  final String? message;

  const EditorLoadingState({this.message});

  @override
  List<Object?> get props => [message];
}

/// Document loaded and ready for editing
class EditorReadyState extends EditorState {
  final String content;
  final CursorPosition cursorPosition;
  final TextSelection? selection;
  final DocumentUri? documentUri;
  final LanguageId? languageId;
  final bool hasUnsavedChanges;
  final bool canUndo;
  final bool canRedo;

  const EditorReadyState({
    required this.content,
    required this.cursorPosition,
    this.selection,
    this.documentUri,
    this.languageId,
    this.hasUnsavedChanges = false,
    this.canUndo = false,
    this.canRedo = false,
  });

  /// Creates a copy with updated fields
  EditorReadyState copyWith({
    String? content,
    CursorPosition? cursorPosition,
    TextSelection? selection,
    DocumentUri? documentUri,
    LanguageId? languageId,
    bool? hasUnsavedChanges,
    bool? canUndo,
    bool? canRedo,
  }) {
    return EditorReadyState(
      content: content ?? this.content,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      selection: selection ?? this.selection,
      documentUri: documentUri ?? this.documentUri,
      languageId: languageId ?? this.languageId,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
    );
  }

  @override
  List<Object?> get props => [
        content,
        cursorPosition,
        selection,
        documentUri,
        languageId,
        hasUnsavedChanges,
        canUndo,
        canRedo,
      ];
}

/// Error occurred
class EditorErrorState extends EditorState {
  final String message;
  final EditorFailure? failure;

  const EditorErrorState({
    required this.message,
    this.failure,
  });

  @override
  List<Object?> get props => [message, failure];
}
