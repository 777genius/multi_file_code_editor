import 'package:freezed_annotation/freezed_annotation.dart';

part 'lsp_failure.freezed.dart';

/// Represents failures that can occur in LSP operations.
@freezed
class LspFailure with _$LspFailure implements Exception {
  const factory LspFailure.sessionNotFound({
    @Default('LSP session not found') String message,
  }) = _SessionNotFound;

  const factory LspFailure.initializationFailed({
    required String reason,
  }) = _InitializationFailed;

  const factory LspFailure.requestFailed({
    required String method,
    String? reason,
  }) = _RequestFailed;

  const factory LspFailure.serverNotResponding({
    @Default('LSP server is not responding') String message,
  }) = _ServerNotResponding;

  const factory LspFailure.unsupportedLanguage({
    required String languageId,
  }) = _UnsupportedLanguage;

  const factory LspFailure.connectionFailed({
    required String reason,
  }) = _ConnectionFailed;

  const factory LspFailure.unexpected({
    required String message,
    Object? error,
  }) = _Unexpected;
}
