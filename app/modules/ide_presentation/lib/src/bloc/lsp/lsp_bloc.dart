import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_application/lsp_application.dart';
import 'package:injectable/injectable.dart';

import 'lsp_event.dart';
import 'lsp_state.dart';

/// LspBloc
///
/// Manages LSP interactions and coordinates language server operations.
///
/// Architecture (Clean Architecture + BLoC):
/// ```
/// UI Widget
///     ↓ dispatches events
/// LspBloc
///     ↓ calls
/// LSP Use Cases (Application Layer)
///     ↓ uses
/// ILspClientRepository (Domain Interface)
///     ↑ implemented by
/// LSP Infrastructure Adapters
/// ```
///
/// Responsibilities:
/// - Manages LSP session lifecycle
/// - Coordinates completion requests
/// - Coordinates hover information requests
/// - Coordinates diagnostics requests
/// - Coordinates go-to-definition and find-references
/// - Never directly accesses Infrastructure
///
/// Example:
/// ```dart
/// // In UI widget
/// context.read<LspBloc>().add(CompletionsRequestedEvent(
///   languageId: LanguageId.dart,
///   documentUri: DocumentUri.fromFilePath('/file.dart'),
///   position: CursorPosition.create(line: 10, column: 5),
/// ));
/// ```
@injectable
class LspBloc extends Bloc<LspEvent, LspState> {
  final InitializeLspSessionUseCase _initializeSessionUseCase;
  final ShutdownLspSessionUseCase _shutdownSessionUseCase;
  final GetCompletionsUseCase _getCompletionsUseCase;
  final GetHoverInfoUseCase _getHoverInfoUseCase;
  final GetDiagnosticsUseCase _getDiagnosticsUseCase;
  final GoToDefinitionUseCase _goToDefinitionUseCase;
  final FindReferencesUseCase _findReferencesUseCase;

  LspBloc({
    required InitializeLspSessionUseCase initializeSessionUseCase,
    required ShutdownLspSessionUseCase shutdownSessionUseCase,
    required GetCompletionsUseCase getCompletionsUseCase,
    required GetHoverInfoUseCase getHoverInfoUseCase,
    required GetDiagnosticsUseCase getDiagnosticsUseCase,
    required GoToDefinitionUseCase goToDefinitionUseCase,
    required FindReferencesUseCase findReferencesUseCase,
  })  : _initializeSessionUseCase = initializeSessionUseCase,
        _shutdownSessionUseCase = shutdownSessionUseCase,
        _getCompletionsUseCase = getCompletionsUseCase,
        _getHoverInfoUseCase = getHoverInfoUseCase,
        _getDiagnosticsUseCase = getDiagnosticsUseCase,
        _goToDefinitionUseCase = goToDefinitionUseCase,
        _findReferencesUseCase = findReferencesUseCase,
        super(const LspInitialState()) {
    // Register event handlers
    on<LspSessionInitializeRequestedEvent>(_onInitializeSession);
    on<LspSessionShutdownRequestedEvent>(_onShutdownSession);
    on<CompletionsRequestedEvent>(_onCompletionsRequested);
    on<HoverInfoRequestedEvent>(_onHoverInfoRequested);
    on<DiagnosticsRequestedEvent>(_onDiagnosticsRequested);
    on<DefinitionRequestedEvent>(_onDefinitionRequested);
    on<ReferencesRequestedEvent>(_onReferencesRequested);
    on<CompletionsClearedEvent>(_onCompletionsCleared);
    on<HoverClearedEvent>(_onHoverCleared);
  }

  // ================================================================
  // Event Handlers
  // ================================================================

  /// Handles LSP session initialization
  Future<void> _onInitializeSession(
    LspSessionInitializeRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    emit(LspInitializingState(languageId: event.languageId));

    final result = await _initializeSessionUseCase(
      languageId: event.languageId,
      rootUri: event.rootUri,
    );

    result.fold(
      (failure) => emit(LspErrorState(
        message: 'Failed to initialize LSP session: ${failure.toString()}',
        failure: failure,
      )),
      (session) => emit(LspReadyState(session: session)),
    );
  }

  /// Handles LSP session shutdown
  Future<void> _onShutdownSession(
    LspSessionShutdownRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    final result = await _shutdownSessionUseCase(
      languageId: event.languageId,
    );

    result.fold(
      (failure) => emit(LspErrorState(
        message: 'Failed to shutdown LSP session',
        failure: failure,
      )),
      (_) => emit(const LspInitialState()),
    );
  }

  /// Handles completion requests
  Future<void> _onCompletionsRequested(
    CompletionsRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    // Don't show loading state for completions (would flicker)
    final result = await _getCompletionsUseCase(
      languageId: event.languageId,
      documentUri: event.documentUri,
      position: event.position,
      filterPrefix: event.filterPrefix,
    );

    result.fold(
      (failure) {
        // Silently fail completions - don't disrupt editing
        // Could log this for debugging
      },
      (completions) {
        emit(CompletionsLoadedState(
          completions: completions,
          position: event.position,
        ));
      },
    );
  }

  /// Handles hover info requests
  Future<void> _onHoverInfoRequested(
    HoverInfoRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    final result = await _getHoverInfoUseCase(
      languageId: event.languageId,
      documentUri: event.documentUri,
      position: event.position,
    );

    result.fold(
      (failure) {
        // Silently fail hover - don't disrupt editing
      },
      (hoverInfo) {
        emit(HoverInfoLoadedState(
          hoverInfo: hoverInfo,
          position: event.position,
        ));
      },
    );
  }

  /// Handles diagnostics requests
  Future<void> _onDiagnosticsRequested(
    DiagnosticsRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    final result = await _getDiagnosticsUseCase(
      languageId: event.languageId,
      documentUri: event.documentUri,
    );

    result.fold(
      (failure) => emit(LspErrorState(
        message: 'Failed to get diagnostics',
        failure: failure,
      )),
      (diagnostics) {
        emit(DiagnosticsLoadedState(
          diagnostics: diagnostics,
          documentUri: event.documentUri,
        ));
      },
    );
  }

  /// Handles definition requests
  Future<void> _onDefinitionRequested(
    DefinitionRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    emit(const LspLoadingState(operation: 'Finding definition...'));

    final result = await _goToDefinitionUseCase(
      languageId: event.languageId,
      documentUri: event.documentUri,
      position: event.position,
    );

    result.fold(
      (failure) => emit(LspErrorState(
        message: 'Failed to find definition',
        failure: failure,
      )),
      (locations) {
        emit(DefinitionLoadedState(locations: locations));
      },
    );
  }

  /// Handles references requests
  Future<void> _onReferencesRequested(
    ReferencesRequestedEvent event,
    Emitter<LspState> emit,
  ) async {
    emit(const LspLoadingState(operation: 'Finding references...'));

    final result = await _findReferencesUseCase(
      languageId: event.languageId,
      documentUri: event.documentUri,
      position: event.position,
    );

    result.fold(
      (failure) => emit(LspErrorState(
        message: 'Failed to find references',
        failure: failure,
      )),
      (locations) {
        emit(ReferencesLoadedState(locations: locations));
      },
    );
  }

  /// Handles clearing completions
  Future<void> _onCompletionsCleared(
    CompletionsClearedEvent event,
    Emitter<LspState> emit,
  ) async {
    final currentState = state;
    if (currentState is LspReadyState) {
      emit(currentState.copyWith(clearCompletions: true));
    }
  }

  /// Handles clearing hover
  Future<void> _onHoverCleared(
    HoverClearedEvent event,
    Emitter<LspState> emit,
  ) async {
    final currentState = state;
    if (currentState is LspReadyState) {
      emit(currentState.copyWith(clearHoverInfo: true));
    }
  }

  @override
  Future<void> close() {
    // Cleanup if needed
    return super.close();
  }
}
