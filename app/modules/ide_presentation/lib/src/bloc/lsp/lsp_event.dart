import 'package:equatable/equatable.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Events for LspBloc
///
/// Represents LSP-related user actions and system triggers.
abstract class LspEvent extends Equatable {
  const LspEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize LSP session for a language
class LspSessionInitializeRequestedEvent extends LspEvent {
  final LanguageId languageId;
  final DocumentUri rootUri;

  const LspSessionInitializeRequestedEvent({
    required this.languageId,
    required this.rootUri,
  });

  @override
  List<Object?> get props => [languageId, rootUri];
}

/// Shutdown LSP session
class LspSessionShutdownRequestedEvent extends LspEvent {
  final LanguageId languageId;

  const LspSessionShutdownRequestedEvent({required this.languageId});

  @override
  List<Object?> get props => [languageId];
}

/// Request code completions at cursor position
class CompletionsRequestedEvent extends LspEvent {
  final LanguageId languageId;
  final DocumentUri documentUri;
  final CursorPosition position;
  final String? filterPrefix;

  const CompletionsRequestedEvent({
    required this.languageId,
    required this.documentUri,
    required this.position,
    this.filterPrefix,
  });

  @override
  List<Object?> get props => [languageId, documentUri, position, filterPrefix];
}

/// Request hover information at cursor position
class HoverInfoRequestedEvent extends LspEvent {
  final LanguageId languageId;
  final DocumentUri documentUri;
  final CursorPosition position;

  const HoverInfoRequestedEvent({
    required this.languageId,
    required this.documentUri,
    required this.position,
  });

  @override
  List<Object?> get props => [languageId, documentUri, position];
}

/// Request diagnostics for a document
class DiagnosticsRequestedEvent extends LspEvent {
  final LanguageId languageId;
  final DocumentUri documentUri;

  const DiagnosticsRequestedEvent({
    required this.languageId,
    required this.documentUri,
  });

  @override
  List<Object?> get props => [languageId, documentUri];
}

/// Request go to definition
class DefinitionRequestedEvent extends LspEvent {
  final LanguageId languageId;
  final DocumentUri documentUri;
  final CursorPosition position;

  const DefinitionRequestedEvent({
    required this.languageId,
    required this.documentUri,
    required this.position,
  });

  @override
  List<Object?> get props => [languageId, documentUri, position];
}

/// Request find references
class ReferencesRequestedEvent extends LspEvent {
  final LanguageId languageId;
  final DocumentUri documentUri;
  final CursorPosition position;

  const ReferencesRequestedEvent({
    required this.languageId,
    required this.documentUri,
    required this.position,
  });

  @override
  List<Object?> get props => [languageId, documentUri, position];
}

/// Document content changed
class DocumentContentChangedEvent extends LspEvent {
  final DocumentUri documentUri;
  final String content;

  const DocumentContentChangedEvent({
    required this.documentUri,
    required this.content,
  });

  @override
  List<Object?> get props => [documentUri, content];
}

/// Clear completions popup
class CompletionsClearedEvent extends LspEvent {
  const CompletionsClearedEvent();
}

/// Clear hover popup
class HoverClearedEvent extends LspEvent {
  const HoverClearedEvent();
}
