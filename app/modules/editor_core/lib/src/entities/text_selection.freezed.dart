// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TextSelection {
  CursorPosition get start => throw _privateConstructorUsedError;
  CursorPosition get end => throw _privateConstructorUsedError;

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextSelectionCopyWith<TextSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextSelectionCopyWith<$Res> {
  factory $TextSelectionCopyWith(
    TextSelection value,
    $Res Function(TextSelection) then,
  ) = _$TextSelectionCopyWithImpl<$Res, TextSelection>;
  @useResult
  $Res call({CursorPosition start, CursorPosition end});

  $CursorPositionCopyWith<$Res> get start;
  $CursorPositionCopyWith<$Res> get end;
}

/// @nodoc
class _$TextSelectionCopyWithImpl<$Res, $Val extends TextSelection>
    implements $TextSelectionCopyWith<$Res> {
  _$TextSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? start = null, Object? end = null}) {
    return _then(
      _value.copyWith(
            start: null == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as CursorPosition,
            end: null == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as CursorPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CursorPositionCopyWith<$Res> get start {
    return $CursorPositionCopyWith<$Res>(_value.start, (value) {
      return _then(_value.copyWith(start: value) as $Val);
    });
  }

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CursorPositionCopyWith<$Res> get end {
    return $CursorPositionCopyWith<$Res>(_value.end, (value) {
      return _then(_value.copyWith(end: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TextSelectionImplCopyWith<$Res>
    implements $TextSelectionCopyWith<$Res> {
  factory _$$TextSelectionImplCopyWith(
    _$TextSelectionImpl value,
    $Res Function(_$TextSelectionImpl) then,
  ) = __$$TextSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CursorPosition start, CursorPosition end});

  @override
  $CursorPositionCopyWith<$Res> get start;
  @override
  $CursorPositionCopyWith<$Res> get end;
}

/// @nodoc
class __$$TextSelectionImplCopyWithImpl<$Res>
    extends _$TextSelectionCopyWithImpl<$Res, _$TextSelectionImpl>
    implements _$$TextSelectionImplCopyWith<$Res> {
  __$$TextSelectionImplCopyWithImpl(
    _$TextSelectionImpl _value,
    $Res Function(_$TextSelectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? start = null, Object? end = null}) {
    return _then(
      _$TextSelectionImpl(
        start: null == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as CursorPosition,
        end: null == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as CursorPosition,
      ),
    );
  }
}

/// @nodoc

class _$TextSelectionImpl extends _TextSelection {
  const _$TextSelectionImpl({required this.start, required this.end})
    : super._();

  @override
  final CursorPosition start;
  @override
  final CursorPosition end;

  @override
  String toString() {
    return 'TextSelection(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextSelectionImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextSelectionImplCopyWith<_$TextSelectionImpl> get copyWith =>
      __$$TextSelectionImplCopyWithImpl<_$TextSelectionImpl>(this, _$identity);
}

abstract class _TextSelection extends TextSelection {
  const factory _TextSelection({
    required final CursorPosition start,
    required final CursorPosition end,
  }) = _$TextSelectionImpl;
  const _TextSelection._() : super._();

  @override
  CursorPosition get start;
  @override
  CursorPosition get end;

  /// Create a copy of TextSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextSelectionImplCopyWith<_$TextSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
