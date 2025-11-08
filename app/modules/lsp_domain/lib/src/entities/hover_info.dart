import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:editor_core/editor_core.dart';

part 'hover_info.freezed.dart';

/// Represents hover information from LSP.
@freezed
class HoverInfo with _$HoverInfo {
  const factory HoverInfo({
    required String contents,
    TextSelection? range,
  }) = _HoverInfo;

  const HoverInfo._();

  /// Empty hover info
  static const empty = HoverInfo(contents: '');

  /// Checks if hover info is empty
  bool get isEmpty => contents.trim().isEmpty;

  /// Checks if hover info has content
  bool get isNotEmpty => !isEmpty;
}
