import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'module_id.freezed.dart';

/// Value Object: Module Identifier
/// Self-validating, immutable module ID
@freezed
class ModuleId with _$ModuleId {
  const ModuleId._();

  const factory ModuleId(String value) = _ModuleId;

  /// Factory with validation
  factory ModuleId.fromString(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      throw FormatException('ModuleId cannot be empty');
    }

    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(trimmed)) {
      throw FormatException(
        'ModuleId must contain only lowercase letters, numbers, and dashes',
      );
    }

    if (trimmed.startsWith('-') || trimmed.endsWith('-')) {
      throw FormatException('ModuleId cannot start or end with a dash');
    }

    if (trimmed.contains('--')) {
      throw FormatException('ModuleId cannot contain consecutive dashes');
    }

    return ModuleId(trimmed);
  }

  // Well-known module IDs
  static final nodejs = ModuleId('nodejs');
  static final openVSCodeServer = ModuleId('openvscode-server');
  static final baseExtensions = ModuleId('base-extensions');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
