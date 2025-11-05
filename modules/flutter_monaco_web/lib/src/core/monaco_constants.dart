import 'package:flutter_monaco/flutter_monaco.dart';

/// Unified constants for the Monaco editor
class MonacoConstants {
  // Prevent instantiation
  MonacoConstants._();

  /// Font size range
  static const double minFontSize = 8;
  static const double maxFontSize = 48;
  static const double defaultFontSize = 14;

  /// Tab size range
  static const int minTabSize = 1;
  static const int maxTabSize = 8;
  static const int defaultTabSize = 2;

  /// Common ruler positions
  static const List<List<int>> commonRulers = [
    [],
    [80],
    [100],
    [120],
    [80, 120],
    [80, 100, 120],
  ];

  /// File size limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const int warningFileSize = 1 * 1024 * 1024; // 1 MB

  /// Default settings
  static const String defaultTheme = 'vs-dark';
  static const String defaultLanguage = 'markdown';

  /// Default EditorOptions configuration
  static const defaultOptions = EditorOptions(
    fontSize: defaultFontSize,
    theme: MonacoTheme.vsDark,
    language: MonacoLanguage.markdown,
    wordWrap: true,
    lineNumbers: true,
    minimap: false,
    automaticLayout: true,
    tabSize: defaultTabSize,
    insertSpaces: true,
    bracketPairColorization: true,
    formatOnPaste: false,
    formatOnType: false,
    smoothScrolling: true,
    mouseWheelZoom: true,
    cursorBlinking: CursorBlinking.blink,
    cursorStyle: CursorStyle.line,
    fontFamily: 'Cascadia Code, Fira Code, Consolas, monospace',
  );
}
