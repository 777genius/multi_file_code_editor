// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditorStore on _EditorStore, Store {
  Computed<bool>? _$hasDocumentComputed;

  @override
  bool get hasDocument => (_$hasDocumentComputed ??= Computed<bool>(
    () => super.hasDocument,
    name: '_EditorStore.hasDocument',
  )).value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_EditorStore.hasError',
  )).value;
  Computed<bool>? _$isReadyComputed;

  @override
  bool get isReady => (_$isReadyComputed ??= Computed<bool>(
    () => super.isReady,
    name: '_EditorStore.isReady',
  )).value;
  Computed<int>? _$lineCountComputed;

  @override
  int get lineCount => (_$lineCountComputed ??= Computed<int>(
    () => super.lineCount,
    name: '_EditorStore.lineCount',
  )).value;
  Computed<String>? _$currentLineComputed;

  @override
  String get currentLine => (_$currentLineComputed ??= Computed<String>(
    () => super.currentLine,
    name: '_EditorStore.currentLine',
  )).value;

  late final _$contentAtom = Atom(
    name: '_EditorStore.content',
    context: context,
  );

  @override
  String get content {
    _$contentAtom.reportRead();
    return super.content;
  }

  @override
  set content(String value) {
    _$contentAtom.reportWrite(value, super.content, () {
      super.content = value;
    });
  }

  late final _$cursorPositionAtom = Atom(
    name: '_EditorStore.cursorPosition',
    context: context,
  );

  @override
  CursorPosition get cursorPosition {
    _$cursorPositionAtom.reportRead();
    return super.cursorPosition;
  }

  @override
  set cursorPosition(CursorPosition value) {
    _$cursorPositionAtom.reportWrite(value, super.cursorPosition, () {
      super.cursorPosition = value;
    });
  }

  late final _$selectionAtom = Atom(
    name: '_EditorStore.selection',
    context: context,
  );

  @override
  TextSelection? get selection {
    _$selectionAtom.reportRead();
    return super.selection;
  }

  @override
  set selection(TextSelection? value) {
    _$selectionAtom.reportWrite(value, super.selection, () {
      super.selection = value;
    });
  }

  late final _$documentUriAtom = Atom(
    name: '_EditorStore.documentUri',
    context: context,
  );

  @override
  DocumentUri? get documentUri {
    _$documentUriAtom.reportRead();
    return super.documentUri;
  }

  @override
  set documentUri(DocumentUri? value) {
    _$documentUriAtom.reportWrite(value, super.documentUri, () {
      super.documentUri = value;
    });
  }

  late final _$languageIdAtom = Atom(
    name: '_EditorStore.languageId',
    context: context,
  );

  @override
  LanguageId? get languageId {
    _$languageIdAtom.reportRead();
    return super.languageId;
  }

  @override
  set languageId(LanguageId? value) {
    _$languageIdAtom.reportWrite(value, super.languageId, () {
      super.languageId = value;
    });
  }

  late final _$hasUnsavedChangesAtom = Atom(
    name: '_EditorStore.hasUnsavedChanges',
    context: context,
  );

  @override
  bool get hasUnsavedChanges {
    _$hasUnsavedChangesAtom.reportRead();
    return super.hasUnsavedChanges;
  }

  @override
  set hasUnsavedChanges(bool value) {
    _$hasUnsavedChangesAtom.reportWrite(value, super.hasUnsavedChanges, () {
      super.hasUnsavedChanges = value;
    });
  }

  late final _$canUndoAtom = Atom(
    name: '_EditorStore.canUndo',
    context: context,
  );

  @override
  bool get canUndo {
    _$canUndoAtom.reportRead();
    return super.canUndo;
  }

  @override
  set canUndo(bool value) {
    _$canUndoAtom.reportWrite(value, super.canUndo, () {
      super.canUndo = value;
    });
  }

  late final _$canRedoAtom = Atom(
    name: '_EditorStore.canRedo',
    context: context,
  );

  @override
  bool get canRedo {
    _$canRedoAtom.reportRead();
    return super.canRedo;
  }

  @override
  set canRedo(bool value) {
    _$canRedoAtom.reportWrite(value, super.canRedo, () {
      super.canRedo = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_EditorStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_EditorStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$errorFailureAtom = Atom(
    name: '_EditorStore.errorFailure',
    context: context,
  );

  @override
  EditorFailure? get errorFailure {
    _$errorFailureAtom.reportRead();
    return super.errorFailure;
  }

  @override
  set errorFailure(EditorFailure? value) {
    _$errorFailureAtom.reportWrite(value, super.errorFailure, () {
      super.errorFailure = value;
    });
  }

  late final _$insertTextAsyncAction = AsyncAction(
    '_EditorStore.insertText',
    context: context,
  );

  @override
  Future<void> insertText(String text) {
    return _$insertTextAsyncAction.run(() => super.insertText(text));
  }

  late final _$deleteTextAsyncAction = AsyncAction(
    '_EditorStore.deleteText',
    context: context,
  );

  @override
  Future<void> deleteText({
    required CursorPosition start,
    required CursorPosition end,
  }) {
    return _$deleteTextAsyncAction.run(
      () => super.deleteText(start: start, end: end),
    );
  }

  late final _$moveCursorAsyncAction = AsyncAction(
    '_EditorStore.moveCursor',
    context: context,
  );

  @override
  Future<void> moveCursor(CursorPosition position) {
    return _$moveCursorAsyncAction.run(() => super.moveCursor(position));
  }

  late final _$undoAsyncAction = AsyncAction(
    '_EditorStore.undo',
    context: context,
  );

  @override
  Future<void> undo() {
    return _$undoAsyncAction.run(() => super.undo());
  }

  late final _$redoAsyncAction = AsyncAction(
    '_EditorStore.redo',
    context: context,
  );

  @override
  Future<void> redo() {
    return _$redoAsyncAction.run(() => super.redo());
  }

  late final _$openDocumentAsyncAction = AsyncAction(
    '_EditorStore.openDocument',
    context: context,
  );

  @override
  Future<void> openDocument({
    required DocumentUri uri,
    required LanguageId language,
    required String initialContent,
  }) {
    return _$openDocumentAsyncAction.run(
      () => super.openDocument(
        uri: uri,
        language: language,
        initialContent: initialContent,
      ),
    );
  }

  late final _$markDocumentSavedAsyncAction = AsyncAction(
    '_EditorStore.markDocumentSaved',
    context: context,
  );

  @override
  Future<void> markDocumentSaved() {
    return _$markDocumentSavedAsyncAction.run(() => super.markDocumentSaved());
  }

  late final _$_refreshEditorStateAsyncAction = AsyncAction(
    '_EditorStore._refreshEditorState',
    context: context,
  );

  @override
  Future<void> _refreshEditorState() {
    return _$_refreshEditorStateAsyncAction.run(
      () => super._refreshEditorState(),
    );
  }

  late final _$_EditorStoreActionController = ActionController(
    name: '_EditorStore',
    context: context,
  );

  @override
  void setSelection(TextSelection newSelection) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore.setSelection',
    );
    try {
      return super.setSelection(newSelection);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelection() {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore.clearSelection',
    );
    try {
      return super.clearSelection();
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeDocument() {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore.closeDocument',
    );
    try {
      return super.closeDocument();
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadContent(String newContent, {DocumentUri? uri}) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore.loadContent',
    );
    try {
      return super.loadContent(newContent, uri: uri);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateContentFromUI(String newContent) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore.updateContentFromUI',
    );
    try {
      return super.updateContentFromUI(newContent);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleError(String message, EditorFailure failure) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
      name: '_EditorStore._handleError',
    );
    try {
      return super._handleError(message, failure);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
content: ${content},
cursorPosition: ${cursorPosition},
selection: ${selection},
documentUri: ${documentUri},
languageId: ${languageId},
hasUnsavedChanges: ${hasUnsavedChanges},
canUndo: ${canUndo},
canRedo: ${canRedo},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
errorFailure: ${errorFailure},
hasDocument: ${hasDocument},
hasError: ${hasError},
isReady: ${isReady},
lineCount: ${lineCount},
currentLine: ${currentLine}
    ''';
  }
}
