import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../models/minimap_data.dart';

/// Service for generating minimap data
///
/// This is a placeholder that will be replaced with WASM implementation.
/// For now, uses pure Dart fallback for development without WASM build.
class MinimapService {
  /// Generate minimap data from source code
  ///
  /// Parameters:
  /// - [sourceCode]: The source code to analyze
  /// - [config]: Configuration for minimap generation
  ///
  /// Returns:
  /// - Right(MinimapData) on success
  /// - Left(error) on failure
  Future<Either<String, MinimapData>> generateMinimap({
    required String sourceCode,
    MinimapConfig config = const MinimapConfig(),
  }) async {
    try {
      // TODO: Replace with WASM implementation when available
      // For now, use pure Dart fallback
      final data = _generateMinimapDart(sourceCode, config);
      return right(data);
    } catch (e) {
      return left('Failed to generate minimap: $e');
    }
  }

  /// Pure Dart fallback implementation
  /// This is slower but works without WASM
  MinimapData _generateMinimapDart(String sourceCode, MinimapConfig config) {
    final lines = sourceCode.split('\n');
    final totalLines = lines.length;
    final linesToProcess = totalLines > config.maxLines
        ? config.maxLines
        : totalLines;

    final minimapLines = <MinimapLine>[];
    var maxLength = 0;

    for (var i = 0; i < linesToProcess; i++) {
      if (i % config.sampleRate != 0) {
        continue;
      }

      final line = lines[i];
      final minimapLine = _analyzeLine(line, config);
      final totalLength = minimapLine.indent + minimapLine.length;
      if (totalLength > maxLength) {
        maxLength = totalLength;
      }
      minimapLines.add(minimapLine);
    }

    return MinimapData(
      lines: minimapLines,
      totalLines: totalLines,
      maxLength: maxLength,
      fileSize: sourceCode.length,
    );
  }

  MinimapLine _analyzeLine(String line, MinimapConfig config) {
    final trimmed = line.trim();

    // Empty line
    if (trimmed.isEmpty) {
      return const MinimapLine(
        indent: 0,
        length: 0,
        isComment: false,
        isEmpty: true,
        density: 0,
      );
    }

    // Calculate indent
    var indent = 0;
    for (var i = 0; i < line.length; i++) {
      if (line[i] == ' ') {
        indent++;
      } else if (line[i] == '\t') {
        indent += 4;
      } else {
        break;
      }
    }

    // Check if comment
    final isComment = config.detectComments && _isCommentLine(trimmed);

    // Calculate length (characters)
    final length = trimmed.length;

    // Calculate density
    final alphanumericCount = trimmed.runes
        .where((r) =>
            (r >= 48 && r <= 57) ||  // 0-9
            (r >= 65 && r <= 90) ||  // A-Z
            (r >= 97 && r <= 122))   // a-z
        .length;
    final density = trimmed.isEmpty
        ? 0
        : ((alphanumericCount / trimmed.length) * 100).round();

    return MinimapLine(
      indent: indent,
      length: length,
      isComment: isComment,
      isEmpty: false,
      density: density,
    );
  }

  bool _isCommentLine(String trimmed) {
    return trimmed.startsWith('//') ||
        trimmed.startsWith('#') ||
        trimmed.startsWith('/*') ||
        trimmed.startsWith('*') ||
        trimmed.startsWith('<!--') ||
        trimmed.startsWith('--');
  }
}
