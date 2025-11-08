import 'package:dartz/dartz.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Get hover information (documentation) at cursor position.
///
/// This use case retrieves documentation/type information when user hovers
/// over a symbol in the editor.
///
/// Follows SRP: One responsibility - get hover info.
///
/// Example:
/// ```dart
/// final useCase = GetHoverInfoUseCase(lspRepository);
///
/// final result = await useCase(
///   languageId: LanguageId.dart,
///   documentUri: DocumentUri.fromFilePath('/path/to/file.dart'),
///   position: CursorPosition.create(line: 5, column: 10),
/// );
///
/// result.fold(
///   (failure) => hideTooltip(),
///   (hoverInfo) => showTooltip(hoverInfo.contents),
/// );
/// ```
class GetHoverInfoUseCase {
  final ILspClientRepository _lspRepository;

  const GetHoverInfoUseCase(this._lspRepository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [languageId]: Programming language
  /// - [documentUri]: Document URI
  /// - [position]: Cursor position
  ///
  /// Returns:
  /// - Right(HoverInfo) on success
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, HoverInfo>> call({
    required LanguageId languageId,
    required DocumentUri documentUri,
    required CursorPosition position,
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

        // Step 3: Request hover info from LSP server
        return _lspRepository.getHoverInfo(
          sessionId: session.id,
          documentUri: documentUri,
          position: position,
        );
      },
    );
  }
}
