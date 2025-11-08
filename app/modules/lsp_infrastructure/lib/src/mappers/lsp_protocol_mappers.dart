import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Mappers for converting between LSP JSON protocol and Domain models.
///
/// These mappers isolate LSP protocol details from the domain layer.
/// The domain layer works with clean, immutable domain models while
/// the infrastructure handles the messy JSON protocol.
///
/// Follows SRP: One responsibility - protocol translation.
///
/// Example:
/// ```dart
/// // LSP JSON → Domain
/// final position = LspProtocolMappers.toDomainPosition(lspJson);
///
/// // Domain → LSP JSON
/// final lspJson = LspProtocolMappers.fromDomainPosition(position);
/// ```
class LspProtocolMappers {
  // ================================================================
  // Position Mapping
  // ================================================================

  /// Converts LSP position to domain CursorPosition.
  ///
  /// LSP uses 0-indexed lines and characters.
  /// Our domain also uses 0-indexed, so direct mapping.
  ///
  /// LSP format:
  /// ```json
  /// {"line": 10, "character": 5}
  /// ```
  static CursorPosition toDomainPosition(Map<String, dynamic> json) {
    return CursorPosition.create(
      line: json['line'] as int,
      column: json['character'] as int,
    );
  }

  /// Converts domain CursorPosition to LSP position.
  static Map<String, dynamic> fromDomainPosition(CursorPosition position) {
    return {
      'line': position.line,
      'character': position.column,
    };
  }

  // ================================================================
  // Range Mapping
  // ================================================================

  /// Converts LSP range to domain TextSelection.
  ///
  /// LSP format:
  /// ```json
  /// {
  ///   "start": {"line": 0, "character": 0},
  ///   "end": {"line": 0, "character": 10}
  /// }
  /// ```
  static TextSelection toDomainRange(Map<String, dynamic> json) {
    final start = toDomainPosition(json['start'] as Map<String, dynamic>);
    final end = toDomainPosition(json['end'] as Map<String, dynamic>);

    return TextSelection(start: start, end: end);
  }

  /// Converts domain TextSelection to LSP range.
  static Map<String, dynamic> fromDomainRange(TextSelection selection) {
    return {
      'start': fromDomainPosition(selection.start),
      'end': fromDomainPosition(selection.end),
    };
  }

  // ================================================================
  // TextDocument Identifier Mapping
  // ================================================================

  /// Creates LSP TextDocumentIdentifier from domain DocumentUri.
  static Map<String, dynamic> toTextDocumentIdentifier(DocumentUri uri) {
    return {'uri': uri.value};
  }

  /// Creates LSP VersionedTextDocumentIdentifier.
  static Map<String, dynamic> toVersionedTextDocumentIdentifier(
    DocumentUri uri, {
    int? version,
  }) {
    return {
      'uri': uri.value,
      'version': version,
    };
  }

  /// Creates LSP TextDocumentItem (for didOpen).
  static Map<String, dynamic> toTextDocumentItem({
    required DocumentUri uri,
    required LanguageId languageId,
    required String text,
    int version = 1,
  }) {
    return {
      'uri': uri.value,
      'languageId': languageId.value,
      'version': version,
      'text': text,
    };
  }

  // ================================================================
  // Completion Mapping
  // ================================================================

  /// Converts LSP completion list to domain CompletionList.
  ///
  /// LSP format:
  /// ```json
  /// {
  ///   "isIncomplete": false,
  ///   "items": [...]
  /// }
  /// ```
  static CompletionList toDomainCompletionList(Map<String, dynamic> json) {
    final items = (json['items'] as List?)?.map((item) {
      return toDomainCompletionItem(item as Map<String, dynamic>);
    }).toList() ?? [];

    return CompletionList(
      items: items,
      isIncomplete: json['isIncomplete'] as bool? ?? false,
    );
  }

  /// Converts LSP completion item to domain CompletionItem.
  static CompletionItem toDomainCompletionItem(Map<String, dynamic> json) {
    return CompletionItem(
      label: json['label'] as String,
      kind: _toCompletionItemKind(json['kind'] as int?),
      detail: json['detail'] as String?,
      documentation: _extractDocumentation(json['documentation']),
      insertText: json['insertText'] as String?,
      sortText: json['sortText'] as String?,
      filterText: json['filterText'] as String?,
      preselect: json['preselect'] as bool? ?? false,
    );
  }

  /// Converts LSP completion item kind to domain enum.
  static CompletionItemKind _toCompletionItemKind(int? kind) {
    if (kind == null) return CompletionItemKind.text;

    return switch (kind) {
      1 => CompletionItemKind.text,
      2 => CompletionItemKind.method,
      3 => CompletionItemKind.function,
      4 => CompletionItemKind.constructor,
      5 => CompletionItemKind.field,
      6 => CompletionItemKind.variable,
      7 => CompletionItemKind.class_,
      8 => CompletionItemKind.interface,
      9 => CompletionItemKind.module,
      10 => CompletionItemKind.property,
      14 => CompletionItemKind.keyword,
      15 => CompletionItemKind.snippet,
      _ => CompletionItemKind.text,
    };
  }

  /// Extracts documentation from LSP format.
  ///
  /// Can be string or MarkupContent object.
  static String? _extractDocumentation(dynamic doc) {
    if (doc == null) return null;

    if (doc is String) {
      return doc;
    }

    if (doc is Map<String, dynamic>) {
      return doc['value'] as String?;
    }

    return null;
  }

  // ================================================================
  // Diagnostic Mapping
  // ================================================================

  /// Converts LSP diagnostic to domain Diagnostic.
  static Diagnostic toDomainDiagnostic(Map<String, dynamic> json) {
    return Diagnostic(
      range: toDomainRange(json['range'] as Map<String, dynamic>),
      severity: _toDiagnosticSeverity(json['severity'] as int?),
      message: json['message'] as String,
      code: json['code']?.toString(),
      source: json['source'] as String?,
    );
  }

  /// Converts LSP severity to domain enum.
  static DiagnosticSeverity _toDiagnosticSeverity(int? severity) {
    if (severity == null) return DiagnosticSeverity.information;

    return switch (severity) {
      1 => DiagnosticSeverity.error,
      2 => DiagnosticSeverity.warning,
      3 => DiagnosticSeverity.information,
      4 => DiagnosticSeverity.hint,
      _ => DiagnosticSeverity.information,
    };
  }

  // ================================================================
  // Hover Mapping
  // ================================================================

  /// Converts LSP hover to domain HoverInfo.
  static HoverInfo toDomainHoverInfo(Map<String, dynamic>? json) {
    if (json == null) {
      return HoverInfo.empty;
    }

    final contents = _extractHoverContents(json['contents']);
    final range = json['range'] != null
        ? toDomainRange(json['range'] as Map<String, dynamic>)
        : null;

    return HoverInfo(
      contents: contents,
      range: range,
    );
  }

  /// Extracts hover contents from various LSP formats.
  static String _extractHoverContents(dynamic contents) {
    if (contents is String) {
      return contents;
    }

    if (contents is Map<String, dynamic>) {
      return contents['value'] as String? ?? '';
    }

    if (contents is List) {
      return contents
          .map((item) => _extractHoverContents(item))
          .where((text) => text.isNotEmpty)
          .join('\n\n');
    }

    return '';
  }

  // ================================================================
  // Location Mapping
  // ================================================================

  /// Converts LSP location to domain Location.
  static Location toDomainLocation(Map<String, dynamic> json) {
    return Location(
      uri: DocumentUri(json['uri'] as String),
      range: toDomainRange(json['range'] as Map<String, dynamic>),
    );
  }

  /// Converts list of LSP locations to domain locations.
  static List<Location> toDomainLocations(List<dynamic>? json) {
    if (json == null) return [];

    return json
        .map((item) => toDomainLocation(item as Map<String, dynamic>))
        .toList();
  }
}
