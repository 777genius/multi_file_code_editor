// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LanguageId {
  String get value => throw _privateConstructorUsedError;

  /// Create a copy of LanguageId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageIdCopyWith<LanguageId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageIdCopyWith<$Res> {
  factory $LanguageIdCopyWith(
    LanguageId value,
    $Res Function(LanguageId) then,
  ) = _$LanguageIdCopyWithImpl<$Res, LanguageId>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$LanguageIdCopyWithImpl<$Res, $Val extends LanguageId>
    implements $LanguageIdCopyWith<$Res> {
  _$LanguageIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _value.copyWith(
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LanguageIdImplCopyWith<$Res>
    implements $LanguageIdCopyWith<$Res> {
  factory _$$LanguageIdImplCopyWith(
    _$LanguageIdImpl value,
    $Res Function(_$LanguageIdImpl) then,
  ) = __$$LanguageIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$LanguageIdImplCopyWithImpl<$Res>
    extends _$LanguageIdCopyWithImpl<$Res, _$LanguageIdImpl>
    implements _$$LanguageIdImplCopyWith<$Res> {
  __$$LanguageIdImplCopyWithImpl(
    _$LanguageIdImpl _value,
    $Res Function(_$LanguageIdImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LanguageId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _$LanguageIdImpl(
        null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LanguageIdImpl extends _LanguageId {
  const _$LanguageIdImpl(this.value) : super._();

  @override
  final String value;

  @override
  String toString() {
    return 'LanguageId(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageIdImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of LanguageId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageIdImplCopyWith<_$LanguageIdImpl> get copyWith =>
      __$$LanguageIdImplCopyWithImpl<_$LanguageIdImpl>(this, _$identity);
}

abstract class _LanguageId extends LanguageId {
  const factory _LanguageId(final String value) = _$LanguageIdImpl;
  const _LanguageId._() : super._();

  @override
  String get value;

  /// Create a copy of LanguageId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageIdImplCopyWith<_$LanguageIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
