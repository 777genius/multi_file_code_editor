// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cursor_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CursorPosition {
  int get line => throw _privateConstructorUsedError;
  int get column => throw _privateConstructorUsedError;

  /// Create a copy of CursorPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CursorPositionCopyWith<CursorPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursorPositionCopyWith<$Res> {
  factory $CursorPositionCopyWith(
    CursorPosition value,
    $Res Function(CursorPosition) then,
  ) = _$CursorPositionCopyWithImpl<$Res, CursorPosition>;
  @useResult
  $Res call({int line, int column});
}

/// @nodoc
class _$CursorPositionCopyWithImpl<$Res, $Val extends CursorPosition>
    implements $CursorPositionCopyWith<$Res> {
  _$CursorPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CursorPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? line = null, Object? column = null}) {
    return _then(
      _value.copyWith(
            line: null == line
                ? _value.line
                : line // ignore: cast_nullable_to_non_nullable
                      as int,
            column: null == column
                ? _value.column
                : column // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CursorPositionImplCopyWith<$Res>
    implements $CursorPositionCopyWith<$Res> {
  factory _$$CursorPositionImplCopyWith(
    _$CursorPositionImpl value,
    $Res Function(_$CursorPositionImpl) then,
  ) = __$$CursorPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int line, int column});
}

/// @nodoc
class __$$CursorPositionImplCopyWithImpl<$Res>
    extends _$CursorPositionCopyWithImpl<$Res, _$CursorPositionImpl>
    implements _$$CursorPositionImplCopyWith<$Res> {
  __$$CursorPositionImplCopyWithImpl(
    _$CursorPositionImpl _value,
    $Res Function(_$CursorPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CursorPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? line = null, Object? column = null}) {
    return _then(
      _$CursorPositionImpl(
        line: null == line
            ? _value.line
            : line // ignore: cast_nullable_to_non_nullable
                  as int,
        column: null == column
            ? _value.column
            : column // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CursorPositionImpl extends _CursorPosition {
  const _$CursorPositionImpl({required this.line, required this.column})
    : super._();

  @override
  final int line;
  @override
  final int column;

  @override
  String toString() {
    return 'CursorPosition(line: $line, column: $column)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorPositionImpl &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.column, column) || other.column == column));
  }

  @override
  int get hashCode => Object.hash(runtimeType, line, column);

  /// Create a copy of CursorPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursorPositionImplCopyWith<_$CursorPositionImpl> get copyWith =>
      __$$CursorPositionImplCopyWithImpl<_$CursorPositionImpl>(
        this,
        _$identity,
      );
}

abstract class _CursorPosition extends CursorPosition {
  const factory _CursorPosition({
    required final int line,
    required final int column,
  }) = _$CursorPositionImpl;
  const _CursorPosition._() : super._();

  @override
  int get line;
  @override
  int get column;

  /// Create a copy of CursorPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursorPositionImplCopyWith<_$CursorPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
