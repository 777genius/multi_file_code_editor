import 'package:dartz/dartz.dart';
import 'package:lsp_domain/lsp_domain.dart';

/// Use Case: Shutdown LSP session.
///
/// This use case handles graceful shutdown of an LSP server session.
/// It should be called when closing a project or exiting the IDE.
///
/// SRP: One responsibility - shutdown LSP session.
///
/// Example:
/// ```dart
/// final useCase = ShutdownLspSessionUseCase(lspRepository);
///
/// final result = await useCase(sessionId: session.id);
///
/// result.fold(
///   (failure) => print('Failed to shutdown: $failure'),
///   (_) => print('LSP session closed gracefully'),
/// );
/// ```
class ShutdownLspSessionUseCase {
  final ILspClientRepository _lspRepository;

  const ShutdownLspSessionUseCase(this._lspRepository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [sessionId]: ID of the session to shutdown
  ///
  /// Returns:
  /// - Right(Unit) on success
  /// - Left(LspFailure) on failure
  Future<Either<LspFailure, Unit>> call({
    required SessionId sessionId,
  }) async {
    return _lspRepository.shutdown(sessionId);
  }
}
