// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugin_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PluginId {

 String get value;
/// Create a copy of PluginId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PluginIdCopyWith<PluginId> get copyWith => _$PluginIdCopyWithImpl<PluginId>(this as PluginId, _$identity);

  /// Serializes this PluginId to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PluginId&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PluginId(value: $value)';
}


}

/// @nodoc
abstract mixin class $PluginIdCopyWith<$Res>  {
  factory $PluginIdCopyWith(PluginId value, $Res Function(PluginId) _then) = _$PluginIdCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$PluginIdCopyWithImpl<$Res>
    implements $PluginIdCopyWith<$Res> {
  _$PluginIdCopyWithImpl(this._self, this._then);

  final PluginId _self;
  final $Res Function(PluginId) _then;

/// Create a copy of PluginId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PluginId].
extension PluginIdPatterns on PluginId {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PluginId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PluginId() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PluginId value)  $default,){
final _that = this;
switch (_that) {
case _PluginId():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PluginId value)?  $default,){
final _that = this;
switch (_that) {
case _PluginId() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PluginId() when $default != null:
return $default(_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value)  $default,) {final _that = this;
switch (_that) {
case _PluginId():
return $default(_that.value);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value)?  $default,) {final _that = this;
switch (_that) {
case _PluginId() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PluginId extends PluginId {
  const _PluginId({required this.value}): super._();
  factory _PluginId.fromJson(Map<String, dynamic> json) => _$PluginIdFromJson(json);

@override final  String value;

/// Create a copy of PluginId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PluginIdCopyWith<_PluginId> get copyWith => __$PluginIdCopyWithImpl<_PluginId>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PluginIdToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PluginId&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PluginId(value: $value)';
}


}

/// @nodoc
abstract mixin class _$PluginIdCopyWith<$Res> implements $PluginIdCopyWith<$Res> {
  factory _$PluginIdCopyWith(_PluginId value, $Res Function(_PluginId) _then) = __$PluginIdCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$PluginIdCopyWithImpl<$Res>
    implements _$PluginIdCopyWith<$Res> {
  __$PluginIdCopyWithImpl(this._self, this._then);

  final _PluginId _self;
  final $Res Function(_PluginId) _then;

/// Create a copy of PluginId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_PluginId(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
