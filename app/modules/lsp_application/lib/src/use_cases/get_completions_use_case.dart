import 'package:dartz/dartz.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Get code completions at cursor position.
///
/// This use case orchestrates the process of requesting completions from LSP server.
/// It follows the Single Responsibility Principle - it does ONE thing well.
///
/// Flow:
/// 1. Validates that LSP session exists for the language
/// 2. Gets current document state from editor
/// 3. Requests completions from LSP client
/// 4. Returns filtered and sorted completion list
///
/// Example:
/// ```dart
/// final useCase = GetCompletionsUseCase(lspRepository, editorRepository);
///
/// final result = await useCase(
///   languageId: LanguageId.dart,
///   documentUri: DocumentUri.fromFilePath('/path/to/file.dart'),
///   position: CursorPosition.create(line: 10, column: 5),
/// );
///
/// result.fold(
///   (failure) => showError(failure),
///   (completions) => showCompletionPopup(completions),
/// );
/// ```
class GetCompletionsUseCase {
  final ILspClientRepository _lspRepository;
  final ICodeEditorRepository _editorRepository;

  const GetCompletionsUseCase(
    this._lspRepository,
    this._editorRepository,
  );

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [languageId]: The programming language (e.g., dart, typescript)
  /// - [documentUri]: URI of the document
  /// - [position]: Cursor position where completions are requested
  /// - [filterPrefix]: Optional prefix to filter completions (e.g., "pri" filters "print")
  ///
  /// Returns:
  /// - Right(CompletionList) on success
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, CompletionList>> call({
    required LanguageId languageId,
    required DocumentUri documentUri,
    required CursorPosition position,
    String? filterPrefix,
  }) async {
    // Step 1: Get or create LSP session for this language
    final sessionResult = await _lspRepository.getSession(languageId);

    // If session doesn't exist, it's a failure
    final session = sessionResult.fold(
      (failure) => null,
      (s) => s,
    );

    if (session == null) {
      return left(LspFailure.sessionNotFound(
        message: 'No LSP session found for language: ${languageId.value}',
      ));
    }

    // Step 2: Validate session can handle requests
    if (!session.canHandleRequests) {
      return left(LspFailure.serverNotResponding(
        message: 'LSP session is not ready (state: ${session.state})',
      ));
    }

    // Step 3: Get current document content from editor
    // This ensures we send the latest content to LSP
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

    // Step 4: Notify LSP server about current document state
    // This is crucial for accurate completions
    await _lspRepository.notifyDocumentChanged(
      sessionId: session.id,
      documentUri: documentUri,
      content: content,
    );

    // Step 5: Request completions from LSP server
    final completionsResult = await _lspRepository.getCompletions(
      sessionId: session.id,
      documentUri: documentUri,
      position: position,
    );

    // Step 6: Post-process completions (filter, sort)
    return completionsResult.map((completionList) {
      var processedList = completionList;

      // Filter by prefix if provided
      if (filterPrefix != null && filterPrefix.isNotEmpty) {
        processedList = processedList.filterByPrefix(filterPrefix);
      }

      // Sort by relevance
      processedList = processedList.sortByRelevance();

      return processedList;
    });
  }
}
