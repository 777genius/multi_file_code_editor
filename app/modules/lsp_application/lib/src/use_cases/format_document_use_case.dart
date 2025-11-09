import 'package:dartz/dartz.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Format document using LSP.
///
/// This use case orchestrates code formatting through the LSP server.
/// Most LSP servers provide document formatting capabilities.
///
/// Flow:
/// 1. Validates that LSP session exists for the language
/// 2. Gets current document content from editor
/// 3. Requests formatting from LSP server
/// 4. Applies formatted text to editor
///
/// Example:
/// ```dart
/// final useCase = FormatDocumentUseCase(lspRepository, editorRepository);
///
/// final result = await useCase(
///   languageId: LanguageId.dart,
///   documentUri: DocumentUri.fromFilePath('/path/to/file.dart'),
/// );
///
/// result.fold(
///   (failure) => showError(failure),
///   (_) => showSuccess('Document formatted'),
/// );
/// ```
class FormatDocumentUseCase {
  final ILspClientRepository _lspRepository;
  final ICodeEditorRepository _editorRepository;

  const FormatDocumentUseCase(
    this._lspRepository,
    this._editorRepository,
  );

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [languageId]: The programming language
  /// - [documentUri]: URI of the document to format
  /// - [options]: Formatting options (tab size, insert spaces, etc.)
  ///
  /// Returns:
  /// - Right(Unit) on success
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, Unit>> call({
    required LanguageId languageId,
    required DocumentUri documentUri,
    FormattingOptions? options,
  }) async {
    // Step 1: Get LSP session
    final sessionResult = await _lspRepository.getSession(languageId);

    final session = sessionResult.fold(
      (failure) => null,
      (s) => s,
    );

    if (session == null) {
      return left(LspFailure.sessionNotFound(
        message: 'No LSP session found for language: ${languageId.value}',
      ));
    }

    if (!session.canHandleRequests) {
      return left(LspFailure.serverNotResponding(
        message: 'LSP session is not ready (state: ${session.state})',
      ));
    }

    // Step 2: Get current document content
    final contentResult = await _editorRepository.getContent();

    final content = contentResult.fold(
      (failure) => null,
      (c) => c,
    );

    if (content == null) {
      return left(const LspFailure.unexpected(
        message: 'Failed to get document content from editor',
      ));
    }

    // Step 3: Notify LSP about current document state
    await _lspRepository.notifyDocumentChanged(
      sessionId: session.id,
      documentUri: documentUri,
      content: content,
    );

    // Step 4: Request formatting from LSP
    final formattingResult = await _lspRepository.formatDocument(
      sessionId: session.id,
      documentUri: documentUri,
      options: options ?? FormattingOptions.defaults(),
    );

    // Step 5: Apply formatting if successful
    return formattingResult.fold(
      (failure) => left(failure),
      (textEdits) async {
        if (textEdits.isEmpty) {
          // No changes needed
          return right(unit);
        }

        // Apply edits to editor
        // Note: LSP returns edits in reverse order (bottom to top)
        // to avoid offset issues
        for (final edit in textEdits.reversed) {
          await _editorRepository.replaceText(
            start: edit.range.start,
            end: edit.range.end,
            text: edit.newText,
          );
        }

        return right(unit);
      },
    );
  }
}
