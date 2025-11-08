import 'package:flutter_monaco_crossplatform/flutter_monaco_crossplatform.dart';
import 'package:editor_core/editor_core.dart';

/// Mappers for converting between domain models and Monaco models.
///
/// These mappers isolate Monaco-specific details from the domain layer.
class MonacoMappers {
  // ============================================================
  // Language Mapping
  // ============================================================

  /// Converts domain LanguageId to Monaco language
  static MonacoLanguage toMonacoLanguage(LanguageId languageId) {
    return switch (languageId.value.toLowerCase()) {
      'dart' => MonacoLanguage.dart,
      'javascript' || 'js' => MonacoLanguage.javascript,
      'typescript' || 'ts' => MonacoLanguage.typescript,
      'json' => MonacoLanguage.json,
      'html' => MonacoLanguage.html,
      'css' => MonacoLanguage.css,
      'scss' || 'sass' => MonacoLanguage.scss,
      'python' || 'py' => MonacoLanguage.python,
      'rust' || 'rs' => MonacoLanguage.rust,
      'go' => MonacoLanguage.go,
      'java' => MonacoLanguage.java,
      'cpp' || 'c++' || 'cxx' => MonacoLanguage.cpp,
      'csharp' || 'cs' => MonacoLanguage.csharp,
      'markdown' || 'md' => MonacoLanguage.markdown,
      'yaml' || 'yml' => MonacoLanguage.yaml,
      'xml' => MonacoLanguage.xml,
      'sql' => MonacoLanguage.sql,
      'shell' || 'bash' || 'sh' => MonacoLanguage.shell,
      _ => MonacoLanguage.plaintext,
    };
  }

  /// Converts Monaco language to domain LanguageId
  static LanguageId fromMonacoLanguage(MonacoLanguage language) {
    return switch (language) {
      MonacoLanguage.dart => LanguageId.dart,
      MonacoLanguage.javascript => LanguageId.javascript,
      MonacoLanguage.typescript => LanguageId.typescript,
      MonacoLanguage.json => LanguageId.json,
      MonacoLanguage.html => LanguageId.html,
      MonacoLanguage.css => LanguageId.css,
      MonacoLanguage.scss => LanguageId('scss'),
      MonacoLanguage.python => LanguageId.python,
      MonacoLanguage.rust => LanguageId.rust,
      MonacoLanguage.go => LanguageId.go,
      MonacoLanguage.java => LanguageId.java,
      MonacoLanguage.cpp => LanguageId.cpp,
      MonacoLanguage.csharp => LanguageId.csharp,
      MonacoLanguage.markdown => LanguageId.markdown,
      MonacoLanguage.yaml => LanguageId.yaml,
      MonacoLanguage.xml => LanguageId('xml'),
      MonacoLanguage.sql => LanguageId('sql'),
      MonacoLanguage.shell => LanguageId('shell'),
      _ => LanguageId.plaintext,
    };
  }

  // ============================================================
  // Theme Mapping
  // ============================================================

  /// Converts domain EditorTheme to Monaco theme
  static MonacoTheme toMonacoTheme(EditorTheme theme) {
    return switch (theme.id) {
      'dark' => MonacoTheme.vsDark,
      'light' => MonacoTheme.vs,
      'high-contrast' => MonacoTheme.hcBlack,
      _ => MonacoTheme.vs,
    };
  }

  /// Converts Monaco theme to domain EditorTheme
  static EditorTheme fromMonacoTheme(MonacoTheme theme) {
    return switch (theme) {
      MonacoTheme.vs => EditorTheme.light,
      MonacoTheme.vsDark => EditorTheme.dark,
      MonacoTheme.hcBlack => EditorTheme.highContrast,
      _ => EditorTheme.light,
    };
  }

  // ============================================================
  // Position Mapping (Monaco uses 1-indexed, domain uses 0-indexed)
  // ============================================================

  /// Converts domain CursorPosition to Monaco position (1-indexed)
  static Map<String, int> toMonacoPosition(CursorPosition position) {
    return {
      'lineNumber': position.line + 1, // Monaco is 1-indexed
      'column': position.column + 1,   // Monaco is 1-indexed
    };
  }

  /// Converts Monaco position to domain CursorPosition (0-indexed)
  static CursorPosition fromMonacoPosition(Map<String, dynamic> position) {
    return CursorPosition.create(
      line: (position['lineNumber'] as int) - 1,    // Convert to 0-indexed
      column: (position['column'] as int) - 1,      // Convert to 0-indexed
    );
  }

  // ============================================================
  // Range Mapping
  // ============================================================

  /// Converts domain TextSelection to Monaco range
  static Map<String, dynamic> toMonacoRange(TextSelection selection) {
    final normalized = selection.normalized;
    return {
      'startLineNumber': normalized.start.line + 1,
      'startColumn': normalized.start.column + 1,
      'endLineNumber': normalized.end.line + 1,
      'endColumn': normalized.end.column + 1,
    };
  }

  /// Converts Monaco range to domain TextSelection
  static TextSelection fromMonacoRange(Map<String, dynamic> range) {
    return TextSelection(
      start: CursorPosition.create(
        line: (range['startLineNumber'] as int) - 1,
        column: (range['startColumn'] as int) - 1,
      ),
      end: CursorPosition.create(
        line: (range['endLineNumber'] as int) - 1,
        column: (range['endColumn'] as int) - 1,
      ),
    );
  }
}
