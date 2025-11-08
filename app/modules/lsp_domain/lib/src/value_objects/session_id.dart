import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'session_id.freezed.dart';

/// Unique identifier for an LSP session.
@freezed
class SessionId with _$SessionId {
  const factory SessionId(String value) = _SessionId;

  const SessionId._();

  /// Generates a new unique session ID
  factory SessionId.generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp.hashCode;
    return SessionId('session_${timestamp}_$random');
  }

  /// Creates a session ID from a string
  factory SessionId.fromString(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Session ID cannot be empty');
    }
    return SessionId(value);
  }
}
