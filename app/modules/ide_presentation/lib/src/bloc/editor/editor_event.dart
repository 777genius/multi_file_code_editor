import 'package:equatable/equatable.dart';
import 'package:editor_core/editor_core.dart';

/// Events for EditorBloc
///
/// Represents user interactions and external triggers for the editor.
///
/// Architecture:
/// - Part of Presentation layer
/// - Triggers use cases from Application layer
/// - Never directly accesses Infrastructure
abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object?> get props => [];
}

/// User typed or inserted text
class TextInsertedEvent extends EditorEvent {
  final String text;
  final int position;

  const TextInsertedEvent({
    required this.text,
    required this.position,
  });

  @override
  List<Object?> get props => [text, position];
}

/// User deleted text
class TextDeletedEvent extends EditorEvent {
  final int start;
  final int end;

  const TextDeletedEvent({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}

/// User moved cursor
class CursorMovedEvent extends EditorEvent {
  final CursorPosition position;

  const CursorMovedEvent({required this.position});

  @override
  List<Object?> get props => [position];
}

/// User selected text
class TextSelectedEvent extends EditorEvent {
  final TextSelection selection;

  const TextSelectedEvent({required this.selection});

  @override
  List<Object?> get props => [selection];
}

/// User requested undo
class UndoRequestedEvent extends EditorEvent {
  const UndoRequestedEvent();
}

/// User requested redo
class RedoRequestedEvent extends EditorEvent {
  const RedoRequestedEvent();
}

/// Open a document
class DocumentOpenedEvent extends EditorEvent {
  final DocumentUri uri;
  final LanguageId languageId;

  const DocumentOpenedEvent({
    required this.uri,
    required this.languageId,
  });

  @override
  List<Object?> get props => [uri, languageId];
}

/// Close current document
class DocumentClosedEvent extends EditorEvent {
  const DocumentClosedEvent();
}

/// Save current document
class DocumentSaveRequestedEvent extends EditorEvent {
  const DocumentSaveRequestedEvent();
}

/// Content loaded from external source
class ContentLoadedEvent extends EditorEvent {
  final String content;
  final DocumentUri? documentUri;

  const ContentLoadedEvent({
    required this.content,
    this.documentUri,
  });

  @override
  List<Object?> get props => [content, documentUri];
}
