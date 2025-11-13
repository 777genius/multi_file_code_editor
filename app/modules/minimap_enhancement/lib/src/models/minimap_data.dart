/// Data models for minimap visualization
/// Mirrors Rust WASM structures

/// Represents a single line in the minimap
class MinimapLine {
  /// Indentation level (spaces/tabs)
  final int indent;

  /// Visual length of the line
  final int length;

  /// Whether this line is a comment
  final bool isComment;

  /// Whether this line is empty
  final bool isEmpty;

  /// Character density (0-100)
  final int density;

  const MinimapLine({
    required this.indent,
    required this.length,
    required this.isComment,
    required this.isEmpty,
    required this.density,
  });

  factory MinimapLine.fromJson(Map<String, dynamic> json) {
    return MinimapLine(
      indent: json['indent'] as int,
      length: json['length'] as int,
      isComment: json['is_comment'] as bool,
      isEmpty: json['is_empty'] as bool,
      density: json['density'] as int,
    );
  }
}

/// Complete minimap data for a file
class MinimapData {
  /// All lines in the file
  final List<MinimapLine> lines;

  /// Total number of lines in file
  final int totalLines;

  /// Maximum line length (for scaling)
  final int maxLength;

  /// File size in bytes
  final int fileSize;

  const MinimapData({
    required this.lines,
    required this.totalLines,
    required this.maxLength,
    required this.fileSize,
  });

  factory MinimapData.fromJson(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>;
    final lines = linesJson
        .map((line) => MinimapLine.fromJson(line as Map<String, dynamic>))
        .toList();

    return MinimapData(
      lines: lines,
      totalLines: json['total_lines'] as int,
      maxLength: json['max_length'] as int,
      fileSize: json['file_size'] as int,
    );
  }

  /// Empty minimap data
  static const empty = MinimapData(
    lines: [],
    totalLines: 0,
    maxLength: 0,
    fileSize: 0,
  );
}

/// Configuration for minimap generation
class MinimapConfig {
  /// Maximum lines to process
  final int maxLines;

  /// Sample rate: process every Nth line
  final int sampleRate;

  /// Whether to detect comments
  final bool detectComments;

  const MinimapConfig({
    this.maxLines = 50000,
    this.sampleRate = 1,
    this.detectComments = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'max_lines': maxLines,
      'sample_rate': sampleRate,
      'detect_comments': detectComments,
    };
  }
}
