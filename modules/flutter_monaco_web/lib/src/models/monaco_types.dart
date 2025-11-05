import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monaco_types.freezed.dart';

/// Represents a position in the editor
@freezed
sealed class Position with _$Position {
  const factory Position({
    required int line,
    required int column,
  }) = _Position;

  const Position._();

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      line: json.getInt(
        'lineNumber',
        altKeys: ['line', 'ln', 'row'],
        defaultValue: 1,
      ),
      column: json.getInt(
        'column',
        altKeys: ['col', 'character', 'ch'],
        defaultValue: 1,
      ),
    );
  }

  /// Create position from zero-based coordinates
  factory Position.fromZeroBased(int line, int column) {
    return Position(line: line + 1, column: column + 1);
  }

  /// Get zero-based line number
  int get lineZeroBased => line - 1;

  /// Get zero-based column number
  int get columnZeroBased => column - 1;

  Map<String, dynamic> toJson() => {
        'lineNumber': line,
        'column': column,
      };
}

/// Represents a range in the editor
@freezed
sealed class Range with _$Range {
  const factory Range({
    required int startLine,
    required int startColumn,
    required int endLine,
    required int endColumn,
  }) = _Range;

  const Range._();

  /// Create range from positions
  factory Range.fromPositions(Position start, Position end) {
    return Range(
      startLine: start.line,
      startColumn: start.column,
      endLine: end.line,
      endColumn: end.column,
    );
  }

  /// Create a range for a single line
  factory Range.singleLine(int line, {int startColumn = 1, int? endColumn}) {
    return Range(
      startLine: line,
      startColumn: startColumn,
      endLine: line,
      endColumn: endColumn ?? startColumn,
    );
  }

  /// Create a range for entire lines
  factory Range.lines(int startLine, int endLine) {
    return Range(
      startLine: startLine,
      startColumn: 1,
      endLine: endLine,
      endColumn: 2147483647, // Max int32, effectively end of line
    );
  }

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      startLine: json.getInt(
        'startLineNumber',
        altKeys: ['startLine', 'start_line', 'from_line'],
        defaultValue: 1,
      ),
      startColumn: json.getInt(
        'startColumn',
        altKeys: ['startCol', 'start_column', 'from_column'],
        defaultValue: 1,
      ),
      endLine: json.getInt(
        'endLineNumber',
        altKeys: ['endLine', 'end_line', 'to_line'],
        defaultValue: 1,
      ),
      endColumn: json.getInt(
        'endColumn',
        altKeys: ['endCol', 'end_column', 'to_column'],
        defaultValue: 1,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'startLineNumber': startLine,
        'startColumn': startColumn,
        'endLineNumber': endLine,
        'endColumn': endColumn,
      };

  /// Get the start position
  Position get startPosition => Position(line: startLine, column: startColumn);

  /// Get the end position
  Position get endPosition => Position(line: endLine, column: endColumn);

  /// Check if the range is collapsed (zero-width)
  bool get isCollapsed => startLine == endLine && startColumn == endColumn;

  /// Check if the range contains a position
  bool containsPosition(Position position) {
    if (position.line < startLine || position.line > endLine) {
      return false;
    }
    if (position.line == startLine && position.column < startColumn) {
      return false;
    }
    if (position.line == endLine && position.column > endColumn) {
      return false;
    }
    return true;
  }

  /// Check if the range intersects with another range
  bool intersects(Range other) {
    return !(endLine < other.startLine ||
        other.endLine < startLine ||
        (endLine == other.startLine && endColumn < other.startColumn) ||
        (other.endLine == startLine && other.endColumn < startColumn));
  }
}

/// Severity levels for markers (diagnostics)
enum MarkerSeverity {
  hint(1),
  info(2),
  warning(4),
  error(8);

  const MarkerSeverity(this.value);

  final int value;

  static MarkerSeverity fromValue(int value) {
    return MarkerSeverity.values.firstWhere(
      (s) => s.value == value,
      orElse: () => MarkerSeverity.info,
    );
  }
}

/// Represents a marker (diagnostic) in the editor
@freezed
sealed class MarkerData with _$MarkerData {
  const factory MarkerData({
    required Range range,
    required String message,
    @Default(MarkerSeverity.info) MarkerSeverity severity,
    String? code,
    String? source,
    List<String>? tags,
    List<RelatedInformation>? relatedInformation,
  }) = _MarkerData;

  /// Create an error marker
  factory MarkerData.error({
    required Range range,
    required String message,
    String? code,
    String? source,
  }) {
    return MarkerData(
      range: range,
      message: message,
      severity: MarkerSeverity.error,
      code: code,
      source: source,
    );
  }

  /// Create a warning marker
  factory MarkerData.warning({
    required Range range,
    required String message,
    String? code,
    String? source,
  }) {
    return MarkerData(
      range: range,
      message: message,
      severity: MarkerSeverity.warning,
      code: code,
      source: source,
    );
  }

  const MarkerData._();

  factory MarkerData.fromJson(Map<String, dynamic> json) {
    return MarkerData(
      range: Range.fromJson(json),
      message: json.getString(
        'message',
        altKeys: ['msg', 'text'],
        defaultValue: '',
      ),
      severity: MarkerSeverity.fromValue(
        json.getInt('severity', defaultValue: 2),
      ),
      code: json.tryGetString('code', altKeys: ['errorCode']),
      source: json.tryGetString('source', altKeys: ['src']),
      tags: json.tryGetList<String>('tags'),
      relatedInformation: json
          .tryGetList<Map<String, dynamic>>('relatedInformation')
          ?.map(RelatedInformation.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      ...range.toJson(),
      'message': message,
      'severity': severity.value,
    };

    if (code != null) json['code'] = code;
    if (source != null) json['source'] = source;
    if (tags != null && tags!.isNotEmpty) json['tags'] = tags;
    if (relatedInformation != null && relatedInformation!.isNotEmpty) {
      json['relatedInformation'] =
          relatedInformation!.map((info) => info.toJson()).toList();
    }

    return json;
  }
}

/// Related information for markers
@freezed
sealed class RelatedInformation with _$RelatedInformation {
  const factory RelatedInformation({
    required Uri resource,
    required Range range,
    required String message,
  }) = _RelatedInformation;

  const RelatedInformation._();

  factory RelatedInformation.fromJson(Map<String, dynamic> json) {
    return RelatedInformation(
      resource: json.getUri(
        'resource',
        altKeys: ['uri', 'file'],
        defaultValue: Uri.parse('file:///unknown'),
      ),
      range: Range.fromJson(json),
      message: json.getString('message', defaultValue: ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'resource': resource.toString(),
        ...range.toJson(),
        'message': message,
      };
}

/// Options for decorations
@freezed
sealed class DecorationOptions with _$DecorationOptions {
  const factory DecorationOptions({
    required Range range,
    @Default({}) Map<String, dynamic> options,
  }) = _DecorationOptions;

  /// Create a decoration with inline class name
  factory DecorationOptions.inlineClass({
    required Range range,
    required String className,
    String? hoverMessage,
    Map<String, dynamic>? additionalOptions,
  }) {
    return DecorationOptions(
      range: range,
      options: {
        'inlineClassName': className,
        if (hoverMessage != null) 'hoverMessage': hoverMessage,
        ...?additionalOptions,
      },
    );
  }

  /// Create a decoration with glyph margin class
  factory DecorationOptions.glyphMargin({
    required Range range,
    required String className,
    String? hoverMessage,
    Map<String, dynamic>? additionalOptions,
  }) {
    return DecorationOptions(
      range: range,
      options: {
        'glyphMarginClassName': className,
        if (hoverMessage != null) 'glyphMarginHoverMessage': hoverMessage,
        ...?additionalOptions,
      },
    );
  }

  /// Create a decoration with line class
  factory DecorationOptions.line({
    required Range range,
    required String className,
    bool isWholeLine = true,
    Map<String, dynamic>? additionalOptions,
  }) {
    return DecorationOptions(
      range: range,
      options: {
        'className': className,
        'isWholeLine': isWholeLine,
        ...?additionalOptions,
      },
    );
  }

  const DecorationOptions._();

  factory DecorationOptions.fromJson(Map<String, dynamic> json) {
    return DecorationOptions(
      range: json.parse('range', Range.fromJson),
      options: json.getMap<String, dynamic>(
        'options',
        defaultValue: {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'range': range.toJson(),
        'options': options,
      };
}

/// Edit operation for applying changes
@freezed
sealed class EditOperation with _$EditOperation {
  const factory EditOperation({
    required Range range,
    required String text,
    bool? forceMoveMarkers,
  }) = _EditOperation;

  const EditOperation._();

  /// Create an insertion operation
  factory EditOperation.insert({
    required Position position,
    required String text,
    bool? forceMoveMarkers,
  }) {
    return EditOperation(
      range: Range.fromPositions(position, position),
      text: text,
      forceMoveMarkers: forceMoveMarkers,
    );
  }

  /// Create a deletion operation
  factory EditOperation.delete({
    required Range range,
    bool? forceMoveMarkers,
  }) {
    return EditOperation(
      range: range,
      text: '',
      forceMoveMarkers: forceMoveMarkers,
    );
  }

  factory EditOperation.fromJson(Map<String, dynamic> json) {
    return EditOperation(
      range: json.parse('range', Range.fromJson),
      text: json.getString(
        'text',
        altKeys: ['newText', 'value'],
        defaultValue: '',
      ),
      forceMoveMarkers: json.tryGetBool('forceMoveMarkers'),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'range': range.toJson(),
      'text': text,
    };
    if (forceMoveMarkers != null) {
      json['forceMoveMarkers'] = forceMoveMarkers;
    }
    return json;
  }
}

/// Find match options
@freezed
sealed class FindOptions with _$FindOptions {
  const factory FindOptions({
    @Default(false) bool isRegex,
    @Default(false) bool matchCase,
    @Default(false) bool wholeWord,
    bool? searchOnlyEditableRange,
    int? limitResultCount,
  }) = _FindOptions;

  /// Create options for case-sensitive search
  factory FindOptions.caseSensitive({
    bool isRegex = false,
    bool wholeWord = false,
  }) {
    return FindOptions(
      isRegex: isRegex,
      matchCase: true,
      wholeWord: wholeWord,
    );
  }

  /// Create options for regex search
  factory FindOptions.regex({
    bool matchCase = false,
  }) {
    return FindOptions(
      isRegex: true,
      matchCase: matchCase,
      wholeWord: false,
    );
  }

  const FindOptions._();

  factory FindOptions.fromJson(Map<String, dynamic> json) {
    return FindOptions(
      isRegex: json.getBool(
        'isRegex',
        altKeys: ['regex', 'useRegex'],
        defaultValue: false,
      ),
      matchCase: json.getBool(
        'matchCase',
        altKeys: ['caseSensitive'],
        defaultValue: false,
      ),
      wholeWord: json.getBool(
        'wholeWord',
        altKeys: ['word'],
        defaultValue: false,
      ),
      searchOnlyEditableRange: json.tryGetBool('searchOnlyEditableRange'),
      limitResultCount: json.tryGetInt(
        'limitResultCount',
        altKeys: ['limit', 'maxResults'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'isRegex': isRegex,
      'matchCase': matchCase,
      'wholeWord': wholeWord,
    };
    if (searchOnlyEditableRange != null) {
      json['searchOnlyEditableRange'] = searchOnlyEditableRange;
    }
    if (limitResultCount != null) {
      json['limitResultCount'] = limitResultCount;
    }
    return json;
  }
}

/// Live statistics from the editor with labeled values
@freezed
sealed class LiveStats with _$LiveStats {
  const factory LiveStats({
    required ({int value, String label}) lineCount,
    required ({int value, String label}) charCount,
    required ({int value, String label}) selectedLines,
    required ({int value, String label}) selectedCharacters,
    required ({int value, String label}) caretCount,
    ({int value, String label})? cursorPosition,
    String? language,
  }) = _LiveStats;

  const LiveStats._();

  factory LiveStats.defaults() {
    return const LiveStats(
      lineCount: (value: 0, label: 'Ln'),
      charCount: (value: 0, label: 'Ch'),
      selectedLines: (value: 0, label: 'Sel Ln'),
      selectedCharacters: (value: 0, label: 'Sel Ch'),
      caretCount: (value: 1, label: 'Cursors'),
    );
  }

  factory LiveStats.fromJson(Map<String, dynamic> json) {
    return LiveStats(
      lineCount: (
        value: json.getInt(
          'lineCount',
          altKeys: ['lines', 'totalLines', 'linesCount'],
          defaultValue: 0,
        ),
        label: 'Ln',
      ),
      charCount: (
        value: json.getInt(
          'charCount',
          altKeys: ['chars', 'characters', 'totalChars'],
          defaultValue: 0,
        ),
        label: 'Ch',
      ),
      selectedLines: (
        value: json.getInt(
          'selLines',
          altKeys: ['selectedLines', 'selectionLines'],
          defaultValue: 0,
        ),
        label: 'Sel Ln',
      ),
      selectedCharacters: (
        value: json.getInt(
          'selChars',
          altKeys: ['selectedChars', 'selectionLength', 'selectedCharacters'],
          defaultValue: 0,
        ),
        label: 'Sel Ch',
      ),
      caretCount: (
        value: json.getInt(
          'caretCount',
          altKeys: ['cursors', 'cursorCount', 'carets'],
          defaultValue: 1,
        ),
        label: 'Cursors',
      ),
      cursorPosition: _extractCursorPosition(json),
      language: json.tryGetString(
        'language',
        altKeys: ['lang', 'mode', 'languageId'],
      ),
    );
  }

  static ({int value, String label})? _extractCursorPosition(
      Map<String, dynamic> json) {
    final line = json.tryGetInt(
      'cursorLine',
      altKeys: ['line', 'currentLine'],
    );
    final column = json.tryGetInt(
      'cursorColumn',
      altKeys: ['column', 'col', 'currentColumn'],
    );

    if (line != null && column != null) {
      return (value: line * 1000 + column, label: '$line:$column');
    }
    return null;
  }

  bool get hasSelection => selectedCharacters.value > 0;

  bool get hasMultipleCursors => caretCount.value > 1;

  /// Get all stats as a list for easy UI iteration
  List<({int value, String label})> get allStats => [
        lineCount,
        charCount,
        selectedLines,
        selectedCharacters,
        caretCount,
        if (cursorPosition != null) cursorPosition!,
      ];

  Map<String, dynamic> toJson() => {
        'lineCount': lineCount.value,
        'charCount': charCount.value,
        'selLines': selectedLines.value,
        'selChars': selectedCharacters.value,
        'caretCount': caretCount.value,
        if (cursorPosition != null) 'cursorPosition': cursorPosition!.label,
        if (language != null) 'language': language,
      };
}

/// Editor state snapshot
@freezed
sealed class EditorState with _$EditorState {
  const factory EditorState({
    required String content,
    Range? selection,
    Position? cursorPosition,
    required int lineCount,
    required bool hasUnsavedChanges,
    String? language,
    String? theme,
    LiveStats? stats,
  }) = _EditorState;

  const EditorState._();

  factory EditorState.fromJson(Map<String, dynamic> json) {
    return EditorState(
      content: json.getString(
        'content',
        altKeys: ['text', 'value'],
        defaultValue: '',
      ),
      selection: json.tryParse('selection', Range.fromJson),
      cursorPosition: json.tryParse('cursorPosition', Position.fromJson),
      lineCount: json.getInt(
        'lineCount',
        altKeys: ['lines', 'totalLines'],
        defaultValue: 0,
      ),
      hasUnsavedChanges: json.getBool(
        'hasUnsavedChanges',
        altKeys: ['dirty', 'modified', 'isDirty'],
        defaultValue: false,
      ),
      language: json.tryGetString(
        'language',
        altKeys: ['lang', 'mode', 'languageId'],
      ),
      theme: json.tryGetString('theme', altKeys: ['themeName']),
      stats: json.tryParse('stats', LiveStats.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        if (selection != null) 'selection': selection!.toJson(),
        if (cursorPosition != null) 'cursorPosition': cursorPosition!.toJson(),
        'lineCount': lineCount,
        'hasUnsavedChanges': hasUnsavedChanges,
        if (language != null) 'language': language,
        if (theme != null) 'theme': theme,
        if (stats != null) 'stats': stats!.toJson(),
      };

  /// Check if the editor is empty
  bool get isEmpty => content.isEmpty;

  /// Get word count
  int get wordCount =>
      content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}

/// Find match result
@freezed
sealed class FindMatch with _$FindMatch {
  const factory FindMatch({
    required Range range,
    String? match,
  }) = _FindMatch;

  const FindMatch._();

  factory FindMatch.fromJson(Map<String, dynamic> json) {
    return FindMatch(
      range: json.parse('range', Range.fromJson),
      match: json.tryGetString('match', altKeys: ['text', 'value']),
    );
  }

  Map<String, dynamic> toJson() => {
        'range': range.toJson(),
        if (match != null) 'match': match,
      };
}
