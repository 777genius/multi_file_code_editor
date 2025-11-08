import 'package:dartz/dartz.dart';
import '../entities/editor_document.dart';
import '../entities/cursor_position.dart';
import '../entities/text_selection.dart';
import '../entities/editor_theme.dart';
import '../value_objects/language_id.dart';
import '../failures/editor_failure.dart';

/// Platform-agnostic code editor repository interface.
///
/// This abstraction allows switching between different editor implementations:
/// - Monaco Editor (WebView-based)
/// - Native Rust+Flutter editor
/// - Any other editor implementation
///
/// The domain layer only depends on this interface, never on concrete implementations.
abstract class ICodeEditorRepository {
  // ============================================================
  // Document Management
  // ============================================================

  /// Opens a document in the editor
  Future<Either<EditorFailure, Unit>> openDocument(EditorDocument document);

  /// Gets the current document content
  Future<Either<EditorFailure, String>> getContent();

  /// Sets the document content
  Future<Either<EditorFailure, Unit>> setContent(String content);

  /// Gets the current document
  Future<Either<EditorFailure, EditorDocument>> getCurrentDocument();

  /// Closes the current document
  Future<Either<EditorFailure, Unit>> closeDocument();

  // ============================================================
  // Language & Syntax
  // ============================================================

  /// Sets the programming language for syntax highlighting
  Future<Either<EditorFailure, Unit>> setLanguage(LanguageId languageId);

  /// Gets the current language
  Future<Either<EditorFailure, LanguageId>> getLanguage();

  // ============================================================
  // Theme & Appearance
  // ============================================================

  /// Sets the editor theme
  Future<Either<EditorFailure, Unit>> setTheme(EditorTheme theme);

  /// Gets the current theme
  Future<Either<EditorFailure, EditorTheme>> getTheme();

  // ============================================================
  // Cursor & Selection
  // ============================================================

  /// Gets the current cursor position
  Future<Either<EditorFailure, CursorPosition>> getCursorPosition();

  /// Sets the cursor position
  Future<Either<EditorFailure, Unit>> setCursorPosition(CursorPosition position);

  /// Gets the current text selection
  Future<Either<EditorFailure, TextSelection>> getSelection();

  /// Sets the text selection
  Future<Either<EditorFailure, Unit>> setSelection(TextSelection selection);

  // ============================================================
  // Text Operations
  // ============================================================

  /// Inserts text at the current cursor position
  Future<Either<EditorFailure, Unit>> insertText(String text);

  /// Replaces text in the given range
  Future<Either<EditorFailure, Unit>> replaceText({
    required CursorPosition start,
    required CursorPosition end,
    required String text,
  });

  /// Formats the document
  Future<Either<EditorFailure, Unit>> formatDocument();

  // ============================================================
  // Editor Actions
  // ============================================================

  /// Undo last action
  Future<Either<EditorFailure, Unit>> undo();

  /// Redo last undone action
  Future<Either<EditorFailure, Unit>> redo();

  /// Find text in document
  Future<Either<EditorFailure, Unit>> find(String searchText);

  /// Replace text in document
  Future<Either<EditorFailure, Unit>> replace({
    required String searchText,
    required String replaceText,
  });

  // ============================================================
  // Navigation
  // ============================================================

  /// Scroll to a specific line
  Future<Either<EditorFailure, Unit>> scrollToLine(int lineNumber);

  /// Reveal a specific line in the viewport
  Future<Either<EditorFailure, Unit>> revealLine(int lineNumber);

  /// Focus the editor
  Future<Either<EditorFailure, Unit>> focus();

  // ============================================================
  // Events
  // ============================================================

  /// Stream of content change events
  Stream<String> get onContentChanged;

  /// Stream of cursor position change events
  Stream<CursorPosition> get onCursorPositionChanged;

  /// Stream of selection change events
  Stream<TextSelection> get onSelectionChanged;

  /// Stream of focus events
  Stream<bool> get onFocusChanged;

  // ============================================================
  // Lifecycle
  // ============================================================

  /// Initialize the editor
  Future<Either<EditorFailure, Unit>> initialize();

  /// Check if editor is ready
  bool get isReady;

  /// Dispose the editor
  Future<void> dispose();
}
