import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:editor_core/editor_core.dart';

part 'diagnostic.freezed.dart';

/// Represents a diagnostic (error, warning, etc.) from LSP.
@freezed
class Diagnostic with _$Diagnostic {
  const factory Diagnostic({
    required TextSelection range,
    required DiagnosticSeverity severity,
    required String message,
    String? code,
    String? source,
    List<DiagnosticRelatedInformation>? relatedInformation,
  }) = _Diagnostic;

  const Diagnostic._();

  /// Checks if this is an error
  bool get isError => severity == DiagnosticSeverity.error;

  /// Checks if this is a warning
  bool get isWarning => severity == DiagnosticSeverity.warning;

  /// Checks if this is info
  bool get isInfo => severity == DiagnosticSeverity.information;

  /// Checks if this is a hint
  bool get isHint => severity == DiagnosticSeverity.hint;
}

enum DiagnosticSeverity {
  error,
  warning,
  information,
  hint,
}

@freezed
class DiagnosticRelatedInformation with _$DiagnosticRelatedInformation {
  const factory DiagnosticRelatedInformation({
    required DocumentUri uri,
    required TextSelection range,
    required String message,
  }) = _DiagnosticRelatedInformation;
}
