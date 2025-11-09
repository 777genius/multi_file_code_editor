// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lsp_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LspStore on _LspStore, Store {
  Computed<bool>? _$isReadyComputed;

  @override
  bool get isReady => (_$isReadyComputed ??= Computed<bool>(
    () => super.isReady,
    name: '_LspStore.isReady',
  )).value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_LspStore.hasError',
  )).value;
  Computed<bool>? _$hasCompletionsComputed;

  @override
  bool get hasCompletions => (_$hasCompletionsComputed ??= Computed<bool>(
    () => super.hasCompletions,
    name: '_LspStore.hasCompletions',
  )).value;
  Computed<bool>? _$hasHoverInfoComputed;

  @override
  bool get hasHoverInfo => (_$hasHoverInfoComputed ??= Computed<bool>(
    () => super.hasHoverInfo,
    name: '_LspStore.hasHoverInfo',
  )).value;
  Computed<bool>? _$hasDiagnosticsComputed;

  @override
  bool get hasDiagnostics => (_$hasDiagnosticsComputed ??= Computed<bool>(
    () => super.hasDiagnostics,
    name: '_LspStore.hasDiagnostics',
  )).value;
  Computed<int>? _$errorCountComputed;

  @override
  int get errorCount => (_$errorCountComputed ??= Computed<int>(
    () => super.errorCount,
    name: '_LspStore.errorCount',
  )).value;
  Computed<int>? _$warningCountComputed;

  @override
  int get warningCount => (_$warningCountComputed ??= Computed<int>(
    () => super.warningCount,
    name: '_LspStore.warningCount',
  )).value;
  Computed<List<Diagnostic>>? _$errorsComputed;

  @override
  List<Diagnostic> get errors =>
      (_$errorsComputed ??= Computed<List<Diagnostic>>(
        () => super.errors,
        name: '_LspStore.errors',
      )).value;
  Computed<List<Diagnostic>>? _$warningsComputed;

  @override
  List<Diagnostic> get warnings =>
      (_$warningsComputed ??= Computed<List<Diagnostic>>(
        () => super.warnings,
        name: '_LspStore.warnings',
      )).value;
  Computed<String>? _$statusTextComputed;

  @override
  String get statusText => (_$statusTextComputed ??= Computed<String>(
    () => super.statusText,
    name: '_LspStore.statusText',
  )).value;

  late final _$sessionAtom = Atom(name: '_LspStore.session', context: context);

  @override
  LspSession? get session {
    _$sessionAtom.reportRead();
    return super.session;
  }

  @override
  set session(LspSession? value) {
    _$sessionAtom.reportWrite(value, super.session, () {
      super.session = value;
    });
  }

  late final _$languageIdAtom = Atom(
    name: '_LspStore.languageId',
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

  late final _$completionsAtom = Atom(
    name: '_LspStore.completions',
    context: context,
  );

  @override
  CompletionList? get completions {
    _$completionsAtom.reportRead();
    return super.completions;
  }

  @override
  set completions(CompletionList? value) {
    _$completionsAtom.reportWrite(value, super.completions, () {
      super.completions = value;
    });
  }

  late final _$completionsPositionAtom = Atom(
    name: '_LspStore.completionsPosition',
    context: context,
  );

  @override
  CursorPosition? get completionsPosition {
    _$completionsPositionAtom.reportRead();
    return super.completionsPosition;
  }

  @override
  set completionsPosition(CursorPosition? value) {
    _$completionsPositionAtom.reportWrite(value, super.completionsPosition, () {
      super.completionsPosition = value;
    });
  }

  late final _$hoverInfoAtom = Atom(
    name: '_LspStore.hoverInfo',
    context: context,
  );

  @override
  HoverInfo? get hoverInfo {
    _$hoverInfoAtom.reportRead();
    return super.hoverInfo;
  }

  @override
  set hoverInfo(HoverInfo? value) {
    _$hoverInfoAtom.reportWrite(value, super.hoverInfo, () {
      super.hoverInfo = value;
    });
  }

  late final _$hoverPositionAtom = Atom(
    name: '_LspStore.hoverPosition',
    context: context,
  );

  @override
  CursorPosition? get hoverPosition {
    _$hoverPositionAtom.reportRead();
    return super.hoverPosition;
  }

  @override
  set hoverPosition(CursorPosition? value) {
    _$hoverPositionAtom.reportWrite(value, super.hoverPosition, () {
      super.hoverPosition = value;
    });
  }

  late final _$diagnosticsAtom = Atom(
    name: '_LspStore.diagnostics',
    context: context,
  );

  @override
  ObservableList<Diagnostic>? get diagnostics {
    _$diagnosticsAtom.reportRead();
    return super.diagnostics;
  }

  @override
  set diagnostics(ObservableList<Diagnostic>? value) {
    _$diagnosticsAtom.reportWrite(value, super.diagnostics, () {
      super.diagnostics = value;
    });
  }

  late final _$diagnosticsDocumentUriAtom = Atom(
    name: '_LspStore.diagnosticsDocumentUri',
    context: context,
  );

  @override
  DocumentUri? get diagnosticsDocumentUri {
    _$diagnosticsDocumentUriAtom.reportRead();
    return super.diagnosticsDocumentUri;
  }

  @override
  set diagnosticsDocumentUri(DocumentUri? value) {
    _$diagnosticsDocumentUriAtom.reportWrite(
      value,
      super.diagnosticsDocumentUri,
      () {
        super.diagnosticsDocumentUri = value;
      },
    );
  }

  late final _$definitionLocationsAtom = Atom(
    name: '_LspStore.definitionLocations',
    context: context,
  );

  @override
  ObservableList<Location>? get definitionLocations {
    _$definitionLocationsAtom.reportRead();
    return super.definitionLocations;
  }

  @override
  set definitionLocations(ObservableList<Location>? value) {
    _$definitionLocationsAtom.reportWrite(value, super.definitionLocations, () {
      super.definitionLocations = value;
    });
  }

  late final _$referenceLocationsAtom = Atom(
    name: '_LspStore.referenceLocations',
    context: context,
  );

  @override
  ObservableList<Location>? get referenceLocations {
    _$referenceLocationsAtom.reportRead();
    return super.referenceLocations;
  }

  @override
  set referenceLocations(ObservableList<Location>? value) {
    _$referenceLocationsAtom.reportWrite(value, super.referenceLocations, () {
      super.referenceLocations = value;
    });
  }

  late final _$isInitializingAtom = Atom(
    name: '_LspStore.isInitializing',
    context: context,
  );

  @override
  bool get isInitializing {
    _$isInitializingAtom.reportRead();
    return super.isInitializing;
  }

  @override
  set isInitializing(bool value) {
    _$isInitializingAtom.reportWrite(value, super.isInitializing, () {
      super.isInitializing = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_LspStore.isLoading',
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

  late final _$currentOperationAtom = Atom(
    name: '_LspStore.currentOperation',
    context: context,
  );

  @override
  String? get currentOperation {
    _$currentOperationAtom.reportRead();
    return super.currentOperation;
  }

  @override
  set currentOperation(String? value) {
    _$currentOperationAtom.reportWrite(value, super.currentOperation, () {
      super.currentOperation = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_LspStore.errorMessage',
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
    name: '_LspStore.errorFailure',
    context: context,
  );

  @override
  LspFailure? get errorFailure {
    _$errorFailureAtom.reportRead();
    return super.errorFailure;
  }

  @override
  set errorFailure(LspFailure? value) {
    _$errorFailureAtom.reportWrite(value, super.errorFailure, () {
      super.errorFailure = value;
    });
  }

  late final _$initializeSessionAsyncAction = AsyncAction(
    '_LspStore.initializeSession',
    context: context,
  );

  @override
  Future<void> initializeSession({
    required LanguageId language,
    required DocumentUri rootUri,
  }) {
    return _$initializeSessionAsyncAction.run(
      () => super.initializeSession(language: language, rootUri: rootUri),
    );
  }

  late final _$shutdownSessionAsyncAction = AsyncAction(
    '_LspStore.shutdownSession',
    context: context,
  );

  @override
  Future<void> shutdownSession() {
    return _$shutdownSessionAsyncAction.run(() => super.shutdownSession());
  }

  late final _$getCompletionsAsyncAction = AsyncAction(
    '_LspStore.getCompletions',
    context: context,
  );

  @override
  Future<void> getCompletions({
    required LanguageId language,
    required DocumentUri documentUri,
    required CursorPosition position,
    String? filterPrefix,
  }) {
    return _$getCompletionsAsyncAction.run(
      () => super.getCompletions(
        language: language,
        documentUri: documentUri,
        position: position,
        filterPrefix: filterPrefix,
      ),
    );
  }

  late final _$getHoverInfoAsyncAction = AsyncAction(
    '_LspStore.getHoverInfo',
    context: context,
  );

  @override
  Future<void> getHoverInfo({
    required LanguageId language,
    required DocumentUri documentUri,
    required CursorPosition position,
  }) {
    return _$getHoverInfoAsyncAction.run(
      () => super.getHoverInfo(
        language: language,
        documentUri: documentUri,
        position: position,
      ),
    );
  }

  late final _$getDiagnosticsAsyncAction = AsyncAction(
    '_LspStore.getDiagnostics',
    context: context,
  );

  @override
  Future<void> getDiagnostics({
    required LanguageId language,
    required DocumentUri documentUri,
  }) {
    return _$getDiagnosticsAsyncAction.run(
      () => super.getDiagnostics(language: language, documentUri: documentUri),
    );
  }

  late final _$goToDefinitionAsyncAction = AsyncAction(
    '_LspStore.goToDefinition',
    context: context,
  );

  @override
  Future<void> goToDefinition({
    required LanguageId language,
    required DocumentUri documentUri,
    required CursorPosition position,
  }) {
    return _$goToDefinitionAsyncAction.run(
      () => super.goToDefinition(
        language: language,
        documentUri: documentUri,
        position: position,
      ),
    );
  }

  late final _$findReferencesAsyncAction = AsyncAction(
    '_LspStore.findReferences',
    context: context,
  );

  @override
  Future<void> findReferences({
    required LanguageId language,
    required DocumentUri documentUri,
    required CursorPosition position,
  }) {
    return _$findReferencesAsyncAction.run(
      () => super.findReferences(
        language: language,
        documentUri: documentUri,
        position: position,
      ),
    );
  }

  late final _$_LspStoreActionController = ActionController(
    name: '_LspStore',
    context: context,
  );

  @override
  void clearCompletions() {
    final _$actionInfo = _$_LspStoreActionController.startAction(
      name: '_LspStore.clearCompletions',
    );
    try {
      return super.clearCompletions();
    } finally {
      _$_LspStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearHover() {
    final _$actionInfo = _$_LspStoreActionController.startAction(
      name: '_LspStore.clearHover',
    );
    try {
      return super.clearHover();
    } finally {
      _$_LspStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDiagnostics() {
    final _$actionInfo = _$_LspStoreActionController.startAction(
      name: '_LspStore.clearDiagnostics',
    );
    try {
      return super.clearDiagnostics();
    } finally {
      _$_LspStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_LspStoreActionController.startAction(
      name: '_LspStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_LspStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearAllData() {
    final _$actionInfo = _$_LspStoreActionController.startAction(
      name: '_LspStore._clearAllData',
    );
    try {
      return super._clearAllData();
    } finally {
      _$_LspStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleError(String message, LspFailure failure) {
    final _$actionInfo = _$_LspStoreActionController.startAction(
      name: '_LspStore._handleError',
    );
    try {
      return super._handleError(message, failure);
    } finally {
      _$_LspStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
session: ${session},
languageId: ${languageId},
completions: ${completions},
completionsPosition: ${completionsPosition},
hoverInfo: ${hoverInfo},
hoverPosition: ${hoverPosition},
diagnostics: ${diagnostics},
diagnosticsDocumentUri: ${diagnosticsDocumentUri},
definitionLocations: ${definitionLocations},
referenceLocations: ${referenceLocations},
isInitializing: ${isInitializing},
isLoading: ${isLoading},
currentOperation: ${currentOperation},
errorMessage: ${errorMessage},
errorFailure: ${errorFailure},
isReady: ${isReady},
hasError: ${hasError},
hasCompletions: ${hasCompletions},
hasHoverInfo: ${hasHoverInfo},
hasDiagnostics: ${hasDiagnostics},
errorCount: ${errorCount},
warningCount: ${warningCount},
errors: ${errors},
warnings: ${warnings},
statusText: ${statusText}
    ''';
  }
}
