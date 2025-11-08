import 'package:freezed_annotation/freezed_annotation.dart';
import 'cursor_position.dart';

part 'text_selection.freezed.dart';

/// Represents a text selection range in the editor.
/// Platform-agnostic - works with Monaco, native editors, etc.
@freezed
class TextSelection with _$TextSelection {
  const factory TextSelection({
    required CursorPosition start,
    required CursorPosition end,
  }) = _TextSelection;

  const TextSelection._();

  /// Creates an empty selection at a position (cursor with no selection)
  factory TextSelection.collapsed(CursorPosition position) {
    return TextSelection(start: position, end: position);
  }

  /// Checks if the selection is empty (cursor only, no text selected)
  bool get isEmpty => start.isEqual(end);

  /// Checks if the selection has text selected
  bool get isNotEmpty => !isEmpty;

  /// Gets the normalized selection (start always before end)
  TextSelection get normalized {
    if (start.isBefore(end)) {
      return this;
    }
    return TextSelection(start: end, end: start);
  }

  /// Checks if this selection contains a position
  bool contains(CursorPosition position) {
    final norm = normalized;
    return (position.isEqual(norm.start) || position.isAfter(norm.start)) &&
        (position.isEqual(norm.end) || position.isBefore(norm.end));
  }
}
