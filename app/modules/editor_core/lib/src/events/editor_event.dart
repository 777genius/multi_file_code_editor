import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/cursor_position.dart';
import '../entities/text_selection.dart';
import '../value_objects/document_uri.dart';

part 'editor_event.freezed.dart';

/// Events emitted by the editor.
/// Platform-agnostic - used by all editor implementations.
@freezed
class EditorEvent with _$EditorEvent {
  const factory EditorEvent.contentChanged({
    required DocumentUri documentUri,
    required String newContent,
  }) = _ContentChanged;

  const factory EditorEvent.cursorPositionChanged({
    required DocumentUri documentUri,
    required CursorPosition position,
  }) = _CursorPositionChanged;

  const factory EditorEvent.selectionChanged({
    required DocumentUri documentUri,
    required TextSelection selection,
  }) = _SelectionChanged;

  const factory EditorEvent.focusChanged({
    required DocumentUri documentUri,
    required bool hasFocus,
  }) = _FocusChanged;

  const factory EditorEvent.documentOpened({
    required DocumentUri documentUri,
  }) = _DocumentOpened;

  const factory EditorEvent.documentClosed({
    required DocumentUri documentUri,
  }) = _DocumentClosed;

  const factory EditorEvent.documentSaved({
    required DocumentUri documentUri,
  }) = _DocumentSaved;
}
