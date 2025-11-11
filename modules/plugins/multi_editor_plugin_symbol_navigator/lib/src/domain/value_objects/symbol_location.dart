import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbol_location.freezed.dart';
part 'symbol_location.g.dart';

/// Location of a symbol in source code
@freezed
class SymbolLocation with _$SymbolLocation {
  const SymbolLocation._();

  const factory SymbolLocation({
    /// Start line (0-indexed)
    required int startLine,

    /// Start column (0-indexed)
    required int startColumn,

    /// End line (0-indexed)
    required int endLine,

    /// End column (0-indexed)
    required int endColumn,

    /// Start byte offset in file
    required int startOffset,

    /// End byte offset in file
    required int endOffset,
  }) = _SymbolLocation;

  factory SymbolLocation.fromJson(Map<String, dynamic> json) =>
      _$SymbolLocationFromJson(json);

  /// Create location from tree-sitter node data
  factory SymbolLocation.fromTreeSitter({
    required int startRow,
    required int startCol,
    required int endRow,
    required int endCol,
    required int startByte,
    required int endByte,
  }) {
    return SymbolLocation(
      startLine: startRow,
      startColumn: startCol,
      endLine: endRow,
      endColumn: endCol,
      startOffset: startByte,
      endOffset: endByte,
    );
  }

  /// Number of lines spanned by this symbol
  int get lineCount => endLine - startLine + 1;

  /// Check if this location contains a given line
  bool containsLine(int line) => line >= startLine && line <= endLine;

  /// Check if this location contains a given offset
  bool containsOffset(int offset) =>
      offset >= startOffset && offset <= endOffset;
}
