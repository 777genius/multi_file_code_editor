import 'package:freezed_annotation/freezed_annotation.dart';

part 'installation_id.freezed.dart';

/// Value Object: Installation ID
/// Unique identifier for installation session
@freezed
class InstallationId with _$InstallationId {
  const InstallationId._();

  const factory InstallationId(String value) = _InstallationId;

  /// Generate new unique ID
  factory InstallationId.generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch % 10000;
    return InstallationId('installation_${timestamp}_$random');
  }

  /// Parse from string
  factory InstallationId.fromString(String value) {
    if (value.trim().isEmpty) {
      throw FormatException('InstallationId cannot be empty');
    }
    return InstallationId(value.trim());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstallationId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
