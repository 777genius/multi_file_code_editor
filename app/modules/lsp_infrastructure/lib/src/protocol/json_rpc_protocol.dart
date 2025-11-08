import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'json_rpc_protocol.freezed.dart';
part 'json_rpc_protocol.g.dart';

/// JSON-RPC 2.0 Request
///
/// Represents a request sent to the LSP server.
///
/// Example:
/// ```json
/// {
///   "jsonrpc": "2.0",
///   "id": 1,
///   "method": "textDocument/completion",
///   "params": {...}
/// }
/// ```
@freezed
class JsonRpcRequest with _$JsonRpcRequest {
  const factory JsonRpcRequest({
    @Default('2.0') String jsonrpc,
    required dynamic id, // String or int
    required String method,
    Map<String, dynamic>? params,
  }) = _JsonRpcRequest;

  factory JsonRpcRequest.fromJson(Map<String, dynamic> json) =>
      _$JsonRpcRequestFromJson(json);
}

/// JSON-RPC 2.0 Response
///
/// Represents a response from the LSP server.
///
/// Example success:
/// ```json
/// {
///   "jsonrpc": "2.0",
///   "id": 1,
///   "result": {...}
/// }
/// ```
///
/// Example error:
/// ```json
/// {
///   "jsonrpc": "2.0",
///   "id": 1,
///   "error": {
///     "code": -32601,
///     "message": "Method not found"
///   }
/// }
/// ```
@freezed
class JsonRpcResponse with _$JsonRpcResponse {
  const factory JsonRpcResponse({
    @Default('2.0') String jsonrpc,
    required dynamic id,
    Map<String, dynamic>? result,
    JsonRpcError? error,
  }) = _JsonRpcResponse;

  const JsonRpcResponse._();

  factory JsonRpcResponse.fromJson(Map<String, dynamic> json) =>
      _$JsonRpcResponseFromJson(json);

  /// Checks if response is successful
  bool get isSuccess => error == null;

  /// Checks if response has error
  bool get hasError => error != null;
}

/// JSON-RPC 2.0 Error
///
/// Represents an error in a response.
@freezed
class JsonRpcError with _$JsonRpcError {
  const factory JsonRpcError({
    required int code,
    required String message,
    dynamic data,
  }) = _JsonRpcError;

  factory JsonRpcError.fromJson(Map<String, dynamic> json) =>
      _$JsonRpcErrorFromJson(json);
}

/// JSON-RPC 2.0 Notification
///
/// Represents a notification (request without ID).
/// Notifications don't expect a response.
///
/// Example:
/// ```json
/// {
///   "jsonrpc": "2.0",
///   "method": "textDocument/didChange",
///   "params": {...}
/// }
/// ```
@freezed
class JsonRpcNotification with _$JsonRpcNotification {
  const factory JsonRpcNotification({
    @Default('2.0') String jsonrpc,
    required String method,
    Map<String, dynamic>? params,
  }) = _JsonRpcNotification;

  factory JsonRpcNotification.fromJson(Map<String, dynamic> json) =>
      _$JsonRpcNotificationFromJson(json);
}

/// JSON-RPC Error Codes
///
/// Standard error codes defined by JSON-RPC 2.0 and LSP.
class JsonRpcErrorCode {
  // JSON-RPC standard errors
  static const int parseError = -32700;
  static const int invalidRequest = -32600;
  static const int methodNotFound = -32601;
  static const int invalidParams = -32602;
  static const int internalError = -32603;

  // LSP specific errors
  static const int serverNotInitialized = -32002;
  static const int unknownErrorCode = -32001;
  static const int requestCancelled = -32800;
  static const int contentModified = -32801;
  static const int serverCancelled = -32802;

  /// Checks if error code is a server error
  static bool isServerError(int code) {
    return code >= -32099 && code <= -32000;
  }

  /// Gets error message for a code
  static String getMessage(int code) {
    return switch (code) {
      parseError => 'Parse error',
      invalidRequest => 'Invalid request',
      methodNotFound => 'Method not found',
      invalidParams => 'Invalid params',
      internalError => 'Internal error',
      serverNotInitialized => 'Server not initialized',
      requestCancelled => 'Request cancelled',
      contentModified => 'Content modified',
      serverCancelled => 'Server cancelled',
      _ => 'Unknown error',
    };
  }
}
