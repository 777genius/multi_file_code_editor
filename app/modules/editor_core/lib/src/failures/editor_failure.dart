import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_failure.freezed.dart';

/// Represents failures that can occur in the editor domain.
/// Platform-agnostic - not tied to Monaco or any specific implementation.
@freezed
class EditorFailure with _$EditorFailure implements Exception {
  const factory EditorFailure.notInitialized({
    @Default('Editor is not initialized') String message,
  }) = _NotInitialized;

  const factory EditorFailure.invalidPosition({
    required String message,
  }) = _InvalidPosition;

  const factory EditorFailure.invalidRange({
    required String message,
  }) = _InvalidRange;

  const factory EditorFailure.documentNotFound({
    @Default('Document not found') String message,
  }) = _DocumentNotFound;

  const factory EditorFailure.operationFailed({
    required String operation,
    String? reason,
  }) = _OperationFailed;

  const factory EditorFailure.unsupportedOperation({
    required String operation,
  }) = _UnsupportedOperation;

  const factory EditorFailure.unexpected({
    required String message,
    Object? error,
  }) = _Unexpected;
}
