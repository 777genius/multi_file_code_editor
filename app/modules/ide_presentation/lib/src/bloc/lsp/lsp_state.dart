import 'package:equatable/equatable.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// States for LspBloc
///
/// Represents the current state of LSP interactions.
abstract class LspState extends Equatable {
  const LspState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no LSP session
class LspInitialState extends LspState {
  const LspInitialState();
}

/// LSP session is being initialized
class LspInitializingState extends LspState {
  final LanguageId languageId;

  const LspInitializingState({required this.languageId});

  @override
  List<Object?> get props => [languageId];
}

/// LSP session is ready
class LspReadyState extends LspState {
  final LspSession session;
  final CompletionList? completions;
  final HoverInfo? hoverInfo;
  final List<Diagnostic>? diagnostics;

  const LspReadyState({
    required this.session,
    this.completions,
    this.hoverInfo,
    this.diagnostics,
  });

  /// Creates a copy with updated fields
  LspReadyState copyWith({
    LspSession? session,
    CompletionList? completions,
    bool clearCompletions = false,
    HoverInfo? hoverInfo,
    bool clearHoverInfo = false,
    List<Diagnostic>? diagnostics,
    bool clearDiagnostics = false,
  }) {
    return LspReadyState(
      session: session ?? this.session,
      completions: clearCompletions ? null : (completions ?? this.completions),
      hoverInfo: clearHoverInfo ? null : (hoverInfo ?? this.hoverInfo),
      diagnostics: clearDiagnostics ? null : (diagnostics ?? this.diagnostics),
    );
  }

  @override
  List<Object?> get props => [session, completions, hoverInfo, diagnostics];
}

/// Loading LSP data
class LspLoadingState extends LspState {
  final String operation;

  const LspLoadingState({required this.operation});

  @override
  List<Object?> get props => [operation];
}

/// LSP error occurred
class LspErrorState extends LspState {
  final String message;
  final LspFailure? failure;

  const LspErrorState({
    required this.message,
    this.failure,
  });

  @override
  List<Object?> get props => [message, failure];
}

/// Completions loaded
class CompletionsLoadedState extends LspState {
  final CompletionList completions;
  final CursorPosition position;

  const CompletionsLoadedState({
    required this.completions,
    required this.position,
  });

  @override
  List<Object?> get props => [completions, position];
}

/// Hover info loaded
class HoverInfoLoadedState extends LspState {
  final HoverInfo hoverInfo;
  final CursorPosition position;

  const HoverInfoLoadedState({
    required this.hoverInfo,
    required this.position,
  });

  @override
  List<Object?> get props => [hoverInfo, position];
}

/// Diagnostics loaded
class DiagnosticsLoadedState extends LspState {
  final List<Diagnostic> diagnostics;
  final DocumentUri documentUri;

  const DiagnosticsLoadedState({
    required this.diagnostics,
    required this.documentUri,
  });

  @override
  List<Object?> get props => [diagnostics, documentUri];
}

/// Definition locations loaded
class DefinitionLoadedState extends LspState {
  final List<Location> locations;

  const DefinitionLoadedState({required this.locations});

  @override
  List<Object?> get props => [locations];
}

/// Reference locations loaded
class ReferencesLoadedState extends LspState {
  final List<Location> locations;

  const ReferencesLoadedState({required this.locations});

  @override
  List<Object?> get props => [locations];
}
