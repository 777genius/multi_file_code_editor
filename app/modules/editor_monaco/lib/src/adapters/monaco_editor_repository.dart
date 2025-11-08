import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_monaco_crossplatform/flutter_monaco_crossplatform.dart';
import 'package:editor_core/editor_core.dart';
import 'package:rxdart/rxdart.dart';
import '../mappers/monaco_mappers.dart';

/// Monaco Editor implementation of [ICodeEditorRepository].
///
/// This is an adapter that translates domain operations to Monaco-specific calls.
/// The domain layer doesn't know about Monaco - it only knows about [ICodeEditorRepository].
///
/// Benefits:
/// - Easy to swap Monaco with a native Rust+Flutter editor
/// - Domain logic remains pure and testable
/// - Monaco complexity is isolated in this adapter
class MonacoEditorRepository implements ICodeEditorRepository {
  MonacoController? _controller;
  EditorDocument? _currentDocument;

  // Event streams
  final _contentChangedController = StreamController<String>.broadcast();
  final _cursorPositionChangedController = StreamController<CursorPosition>.broadcast();
  final _selectionChangedController = StreamController<TextSelection>.broadcast();
  final _focusChangedController = StreamController<bool>.broadcast();

  StreamSubscription? _monacoContentSubscription;
  StreamSubscription? _monacoSelectionSubscription;
  StreamSubscription? _monacoFocusSubscription;

  // ============================================================
  // Lifecycle
  // ============================================================

  /// Sets the Monaco controller (called after Monaco widget is created)
  void setController(MonacoController controller) {
    _controller = controller;
    _setupEventListeners();
  }

  @override
  Future<Either<EditorFailure, Unit>> initialize() async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.onReady;
      return right(unit);
    } catch (e) {
      return left(EditorFailure.unexpected(
        message: 'Failed to initialize Monaco editor',
        error: e,
      ));
    }
  }

  @override
  bool get isReady => _controller != null;

  @override
  Future<void> dispose() async {
    await _monacoContentSubscription?.cancel();
    await _monacoSelectionSubscription?.cancel();
    await _monacoFocusSubscription?.cancel();
    await _contentChangedController.close();
    await _cursorPositionChangedController.close();
    await _selectionChangedController.close();
    await _focusChangedController.close();
    _controller?.dispose();
    _controller = null;
  }

  // ============================================================
  // Document Management
  // ============================================================

  @override
  Future<Either<EditorFailure, Unit>> openDocument(EditorDocument document) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.setValue(document.content);
      await setLanguage(document.languageId);
      _currentDocument = document;
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'openDocument',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, String>> getContent() async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      final content = await _controller!.getValue();
      return right(content);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'getContent',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, Unit>> setContent(String content) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.setValue(content);
      if (_currentDocument != null) {
        _currentDocument = _currentDocument!.updateContent(content);
      }
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'setContent',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, EditorDocument>> getCurrentDocument() async {
    if (_currentDocument == null) {
      return left(const EditorFailure.documentNotFound());
    }
    return right(_currentDocument!);
  }

  @override
  Future<Either<EditorFailure, Unit>> closeDocument() async {
    _currentDocument = null;
    return right(unit);
  }

  // ============================================================
  // Language & Syntax
  // ============================================================

  @override
  Future<Either<EditorFailure, Unit>> setLanguage(LanguageId languageId) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      final monacoLanguage = MonacoMappers.toMonacoLanguage(languageId);
      await _controller!.setLanguage(monacoLanguage);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'setLanguage',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, LanguageId>> getLanguage() async {
    if (_currentDocument == null) {
      return left(const EditorFailure.documentNotFound());
    }
    return right(_currentDocument!.languageId);
  }

  // ============================================================
  // Theme & Appearance
  // ============================================================

  @override
  Future<Either<EditorFailure, Unit>> setTheme(EditorTheme theme) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      final monacoTheme = MonacoMappers.toMonacoTheme(theme);
      await _controller!.setTheme(monacoTheme);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'setTheme',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, EditorTheme>> getTheme() async {
    // Monaco doesn't provide a way to get current theme
    // We could track it internally if needed
    return left(const EditorFailure.unsupportedOperation(
      operation: 'getTheme',
    ));
  }

  // ============================================================
  // Cursor & Selection
  // ============================================================

  @override
  Future<Either<EditorFailure, CursorPosition>> getCursorPosition() async {
    // Monaco doesn't expose cursor position directly
    // Would need JS bridge or track internally
    return left(const EditorFailure.unsupportedOperation(
      operation: 'getCursorPosition',
    ));
  }

  @override
  Future<Either<EditorFailure, Unit>> setCursorPosition(CursorPosition position) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      // Monaco uses 1-indexed lines, our domain uses 0-indexed
      await _controller!.revealLine(position.line + 1);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'setCursorPosition',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, TextSelection>> getSelection() async {
    return left(const EditorFailure.unsupportedOperation(
      operation: 'getSelection',
    ));
  }

  @override
  Future<Either<EditorFailure, Unit>> setSelection(TextSelection selection) async {
    return left(const EditorFailure.unsupportedOperation(
      operation: 'setSelection',
    ));
  }

  // ============================================================
  // Text Operations
  // ============================================================

  @override
  Future<Either<EditorFailure, Unit>> insertText(String text) async {
    // Would need JS bridge to insert at cursor
    return left(const EditorFailure.unsupportedOperation(
      operation: 'insertText',
    ));
  }

  @override
  Future<Either<EditorFailure, Unit>> replaceText({
    required CursorPosition start,
    required CursorPosition end,
    required String text,
  }) async {
    return left(const EditorFailure.unsupportedOperation(
      operation: 'replaceText',
    ));
  }

  @override
  Future<Either<EditorFailure, Unit>> formatDocument() async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.format();
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'formatDocument',
        reason: e.toString(),
      ));
    }
  }

  // ============================================================
  // Editor Actions
  // ============================================================

  @override
  Future<Either<EditorFailure, Unit>> undo() async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.undo();
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'undo',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, Unit>> redo() async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.redo();
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'redo',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, Unit>> find(String searchText) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.find(searchText);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'find',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, Unit>> replace({
    required String searchText,
    required String replaceText,
  }) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.replace(searchText, replaceText);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'replace',
        reason: e.toString(),
      ));
    }
  }

  // ============================================================
  // Navigation
  // ============================================================

  @override
  Future<Either<EditorFailure, Unit>> scrollToLine(int lineNumber) async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      // Monaco uses 1-indexed lines
      await _controller!.revealLine(lineNumber + 1);
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'scrollToLine',
        reason: e.toString(),
      ));
    }
  }

  @override
  Future<Either<EditorFailure, Unit>> revealLine(int lineNumber) async {
    return scrollToLine(lineNumber);
  }

  @override
  Future<Either<EditorFailure, Unit>> focus() async {
    if (_controller == null) {
      return left(const EditorFailure.notInitialized());
    }

    try {
      await _controller!.focus();
      return right(unit);
    } catch (e) {
      return left(EditorFailure.operationFailed(
        operation: 'focus',
        reason: e.toString(),
      ));
    }
  }

  // ============================================================
  // Events
  // ============================================================

  @override
  Stream<String> get onContentChanged => _contentChangedController.stream;

  @override
  Stream<CursorPosition> get onCursorPositionChanged =>
      _cursorPositionChangedController.stream;

  @override
  Stream<TextSelection> get onSelectionChanged =>
      _selectionChangedController.stream;

  @override
  Stream<bool> get onFocusChanged => _focusChangedController.stream;

  // ============================================================
  // Private Methods
  // ============================================================

  void _setupEventListeners() {
    if (_controller == null) return;

    // Content changed
    _monacoContentSubscription = _controller!.onContentChanged
        .debounceTime(const Duration(milliseconds: 300))
        .asyncMap((_) => _controller!.getValue())
        .listen((content) {
      _contentChangedController.add(content);
      if (_currentDocument != null) {
        _currentDocument = _currentDocument!.updateContent(content);
      }
    });

    // Selection changed (if available in future Monaco versions)
    _monacoSelectionSubscription = _controller!.onSelectionChanged?.listen((selection) {
      // Map Monaco selection to domain TextSelection
      // Not implemented yet in flutter_monaco_crossplatform
    });

    // Focus changed
    _monacoFocusSubscription = _controller!.onFocus.listen((_) {
      _focusChangedController.add(true);
    });

    _controller!.onBlur.listen((_) {
      _focusChangedController.add(false);
    });
  }
}
