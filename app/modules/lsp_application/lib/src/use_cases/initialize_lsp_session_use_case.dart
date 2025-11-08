import 'package:dartz/dartz.dart';
import 'package:editor_core/editor_core.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Initialize LSP session for a language.
///
/// This use case handles the initialization of an LSP server session
/// for a specific programming language. It's the first step before
/// using any LSP features.
///
/// SRP: One responsibility - initialize LSP session.
///
/// Example:
/// ```dart
/// final useCase = InitializeLspSessionUseCase(lspRepository);
///
/// final result = await useCase(
///   languageId: LanguageId.dart,
///   rootUri: DocumentUri.fromFilePath('/path/to/project'),
/// );
///
/// result.fold(
///   (failure) => showError('Failed to start LSP: $failure'),
///   (session) => print('LSP ready: ${session.id}'),
/// );
/// ```
class InitializeLspSessionUseCase {
  final ILspClientRepository _lspRepository;

  const InitializeLspSessionUseCase(this._lspRepository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [languageId]: Programming language to initialize LSP for
  /// - [rootUri]: Root URI of the project/workspace
  ///
  /// Returns:
  /// - Right(LspSession) - Initialized session
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, LspSession>> call({
    required LanguageId languageId,
    required DocumentUri rootUri,
  }) async {
    // Step 1: Check if session already exists
    final existingSessionResult = await _lspRepository.getSession(languageId);

    // If session exists and is active, return it
    final existingSession = existingSessionResult.fold(
      (_) => null,
      (session) => session,
    );

    if (existingSession != null && existingSession.isActive) {
      return right(existingSession);
    }

    // Step 2: Initialize new session
    return _lspRepository.initialize(
      languageId: languageId,
      rootUri: rootUri,
    );
  }
}
