import 'package:dartz/dartz.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Get signature help (function/method parameter info).
///
/// This use case requests signature help from LSP server.
/// Signature help shows:
/// - Function/method parameter names and types
/// - Current parameter being edited (highlighted)
/// - Overload variants (if multiple signatures exist)
/// - Documentation for parameters
///
/// Flow:
/// 1. Validates that LSP session exists for the language
/// 2. Gets current document state and cursor position
/// 3. Requests signature help from LSP server
/// 4. Returns signature info for UI to display
///
/// Example:
/// ```dart
/// final useCase = GetSignatureHelpUseCase(lspRepository, editorRepository);
///
/// final result = await useCase(
///   languageId: LanguageId.dart,
///   documentUri: DocumentUri.fromFilePath('/file.dart'),
///   position: CursorPosition.create(line: 10, column: 15),
/// );
///
/// result.fold(
///   (failure) => hideSignatureHelp(),
///   (signatureHelp) => showSignatureHelp(signatureHelp),
/// );
/// ```
class GetSignatureHelpUseCase {
  final ILspClientRepository _lspRepository;
  final ICodeEditorRepository _editorRepository;

  const GetSignatureHelpUseCase(
    this._lspRepository,
    this._editorRepository,
  );

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [languageId]: The programming language
  /// - [documentUri]: URI of the document
  /// - [position]: Cursor position (typically inside function call)
  /// - [triggerCharacter]: Character that triggered signature help (e.g., '(', ',')
  ///
  /// Returns:
  /// - Right(SignatureHelp) on success
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, SignatureHelp>> call({
    required LanguageId languageId,
    required DocumentUri documentUri,
    required CursorPosition position,
    String? triggerCharacter,
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

    // Step 4: Request signature help from LSP
    final signatureHelpResult = await _lspRepository.getSignatureHelp(
      sessionId: session.id,
      documentUri: documentUri,
      position: position,
      triggerCharacter: triggerCharacter,
    );

    return signatureHelpResult;
  }
}
