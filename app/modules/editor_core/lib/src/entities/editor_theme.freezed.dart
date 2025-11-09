// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EditorTheme {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ThemeMode get mode => throw _privateConstructorUsedError;

  /// Create a copy of EditorTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditorThemeCopyWith<EditorTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorThemeCopyWith<$Res> {
  factory $EditorThemeCopyWith(
    EditorTheme value,
    $Res Function(EditorTheme) then,
  ) = _$EditorThemeCopyWithImpl<$Res, EditorTheme>;
  @useResult
  $Res call({String id, String name, ThemeMode mode});
}

/// @nodoc
class _$EditorThemeCopyWithImpl<$Res, $Val extends EditorTheme>
    implements $EditorThemeCopyWith<$Res> {
  _$EditorThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditorTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? mode = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EditorThemeImplCopyWith<$Res>
    implements $EditorThemeCopyWith<$Res> {
  factory _$$EditorThemeImplCopyWith(
    _$EditorThemeImpl value,
    $Res Function(_$EditorThemeImpl) then,
  ) = __$$EditorThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, ThemeMode mode});
}

/// @nodoc
class __$$EditorThemeImplCopyWithImpl<$Res>
    extends _$EditorThemeCopyWithImpl<$Res, _$EditorThemeImpl>
    implements _$$EditorThemeImplCopyWith<$Res> {
  __$$EditorThemeImplCopyWithImpl(
    _$EditorThemeImpl _value,
    $Res Function(_$EditorThemeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? mode = null}) {
    return _then(
      _$EditorThemeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
      ),
    );
  }
}

/// @nodoc

class _$EditorThemeImpl extends _EditorTheme {
  const _$EditorThemeImpl({
    required this.id,
    required this.name,
    required this.mode,
  }) : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final ThemeMode mode;

  @override
  String toString() {
    return 'EditorTheme(id: $id, name: $name, mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditorThemeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, mode);

  /// Create a copy of EditorTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditorThemeImplCopyWith<_$EditorThemeImpl> get copyWith =>
      __$$EditorThemeImplCopyWithImpl<_$EditorThemeImpl>(this, _$identity);
}

abstract class _EditorTheme extends EditorTheme {
  const factory _EditorTheme({
    required final String id,
    required final String name,
    required final ThemeMode mode,
  }) = _$EditorThemeImpl;
  const _EditorTheme._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  ThemeMode get mode;

  /// Create a copy of EditorTheme
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditorThemeImplCopyWith<_$EditorThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
