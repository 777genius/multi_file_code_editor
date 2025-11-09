// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hover_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HoverInfo {
  String get contents => throw _privateConstructorUsedError;
  TextSelection? get range => throw _privateConstructorUsedError;

  /// Create a copy of HoverInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HoverInfoCopyWith<HoverInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HoverInfoCopyWith<$Res> {
  factory $HoverInfoCopyWith(HoverInfo value, $Res Function(HoverInfo) then) =
      _$HoverInfoCopyWithImpl<$Res, HoverInfo>;
  @useResult
  $Res call({String contents, TextSelection? range});

  $TextSelectionCopyWith<$Res>? get range;
}

/// @nodoc
class _$HoverInfoCopyWithImpl<$Res, $Val extends HoverInfo>
    implements $HoverInfoCopyWith<$Res> {
  _$HoverInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HoverInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? contents = null, Object? range = freezed}) {
    return _then(
      _value.copyWith(
            contents: null == contents
                ? _value.contents
                : contents // ignore: cast_nullable_to_non_nullable
                      as String,
            range: freezed == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as TextSelection?,
          )
          as $Val,
    );
  }

  /// Create a copy of HoverInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextSelectionCopyWith<$Res>? get range {
    if (_value.range == null) {
      return null;
    }

    return $TextSelectionCopyWith<$Res>(_value.range!, (value) {
      return _then(_value.copyWith(range: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HoverInfoImplCopyWith<$Res>
    implements $HoverInfoCopyWith<$Res> {
  factory _$$HoverInfoImplCopyWith(
    _$HoverInfoImpl value,
    $Res Function(_$HoverInfoImpl) then,
  ) = __$$HoverInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contents, TextSelection? range});

  @override
  $TextSelectionCopyWith<$Res>? get range;
}

/// @nodoc
class __$$HoverInfoImplCopyWithImpl<$Res>
    extends _$HoverInfoCopyWithImpl<$Res, _$HoverInfoImpl>
    implements _$$HoverInfoImplCopyWith<$Res> {
  __$$HoverInfoImplCopyWithImpl(
    _$HoverInfoImpl _value,
    $Res Function(_$HoverInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HoverInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? contents = null, Object? range = freezed}) {
    return _then(
      _$HoverInfoImpl(
        contents: null == contents
            ? _value.contents
            : contents // ignore: cast_nullable_to_non_nullable
                  as String,
        range: freezed == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as TextSelection?,
      ),
    );
  }
}

/// @nodoc

class _$HoverInfoImpl extends _HoverInfo {
  const _$HoverInfoImpl({required this.contents, this.range}) : super._();

  @override
  final String contents;
  @override
  final TextSelection? range;

  @override
  String toString() {
    return 'HoverInfo(contents: $contents, range: $range)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HoverInfoImpl &&
            (identical(other.contents, contents) ||
                other.contents == contents) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contents, range);

  /// Create a copy of HoverInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HoverInfoImplCopyWith<_$HoverInfoImpl> get copyWith =>
      __$$HoverInfoImplCopyWithImpl<_$HoverInfoImpl>(this, _$identity);
}

abstract class _HoverInfo extends HoverInfo {
  const factory _HoverInfo({
    required final String contents,
    final TextSelection? range,
  }) = _$HoverInfoImpl;
  const _HoverInfo._() : super._();

  @override
  String get contents;
  @override
  TextSelection? get range;

  /// Create a copy of HoverInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HoverInfoImplCopyWith<_$HoverInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
