import 'package:dartz/dartz.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Get diagnostics (errors, warnings) for a document.
///
/// This use case retrieves compiler errors, warnings, and hints
/// from the LSP server for a specific document.
///
/// SRP: One responsibility - get diagnostics.
///
/// Example:
/// ```dart
/// final useCase = GetDiagnosticsUseCase(lspRepository);
///
/// final result = await useCase(
///   languageId: LanguageId.dart,
///   documentUri: DocumentUri.fromFilePath('/path/to/file.dart'),
/// );
///
/// result.fold(
///   (failure) => clearDiagnostics(),
///   (diagnostics) => showDiagnostics(diagnostics),
/// );
/// ```
class GetDiagnosticsUseCase {
  final ILspClientRepository _lspRepository;

  const GetDiagnosticsUseCase(this._lspRepository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [languageId]: Programming language
  /// - [documentUri]: Document URI
  /// - [severityFilter]: Optional filter by severity (errors only, warnings only, etc.)
  ///
  /// Returns:
  /// - Right(List<Diagnostic>) on success
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, List<Diagnostic>>> call({
    required LanguageId languageId,
    required DocumentUri documentUri,
    DiagnosticSeverity? severityFilter,
  }) async {
    // Step 1: Get LSP session
    final sessionResult = await _lspRepository.getSession(languageId);

    return sessionResult.fold(
      (failure) => left(failure),
      (session) async {
        // Step 2: Validate session is ready
        if (!session.canHandleRequests) {
          return left(LspFailure.serverNotResponding(
            message: 'LSP session not ready for ${languageId.value}',
          ));
        }

        // Step 3: Get diagnostics from LSP server
        final diagnosticsResult = await _lspRepository.getDiagnostics(
          sessionId: session.id,
          documentUri: documentUri,
        );

        // Step 4: Filter by severity if requested
        return diagnosticsResult.map((diagnostics) {
          if (severityFilter == null) {
            return diagnostics;
          }

          return diagnostics
              .where((diagnostic) => diagnostic.severity == severityFilter)
              .toList();
        });
      },
    );
  }

  /// Helper: Get only errors
  Future<Either<LspFailure, List<Diagnostic>>> getErrors({
    required LanguageId languageId,
    required DocumentUri documentUri,
  }) {
    return call(
      languageId: languageId,
      documentUri: documentUri,
      severityFilter: DiagnosticSeverity.error,
    );
  }

  /// Helper: Get only warnings
  Future<Either<LspFailure, List<Diagnostic>>> getWarnings({
    required LanguageId languageId,
    required DocumentUri documentUri,
  }) {
    return call(
      languageId: languageId,
      documentUri: documentUri,
      severityFilter: DiagnosticSeverity.warning,
    );
  }
}
