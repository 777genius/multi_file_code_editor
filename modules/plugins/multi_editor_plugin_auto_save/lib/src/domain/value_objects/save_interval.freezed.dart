// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_interval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaveInterval {

 int get seconds;
/// Create a copy of SaveInterval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveIntervalCopyWith<SaveInterval> get copyWith => _$SaveIntervalCopyWithImpl<SaveInterval>(this as SaveInterval, _$identity);

  /// Serializes this SaveInterval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveInterval&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seconds);

@override
String toString() {
  return 'SaveInterval(seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class $SaveIntervalCopyWith<$Res>  {
  factory $SaveIntervalCopyWith(SaveInterval value, $Res Function(SaveInterval) _then) = _$SaveIntervalCopyWithImpl;
@useResult
$Res call({
 int seconds
});




}
/// @nodoc
class _$SaveIntervalCopyWithImpl<$Res>
    implements $SaveIntervalCopyWith<$Res> {
  _$SaveIntervalCopyWithImpl(this._self, this._then);

  final SaveInterval _self;
  final $Res Function(SaveInterval) _then;

/// Create a copy of SaveInterval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seconds = null,}) {
  return _then(_self.copyWith(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveInterval].
extension SaveIntervalPatterns on SaveInterval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveInterval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveInterval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveInterval value)  $default,){
final _that = this;
switch (_that) {
case _SaveInterval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveInterval value)?  $default,){
final _that = this;
switch (_that) {
case _SaveInterval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveInterval() when $default != null:
return $default(_that.seconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seconds)  $default,) {final _that = this;
switch (_that) {
case _SaveInterval():
return $default(_that.seconds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seconds)?  $default,) {final _that = this;
switch (_that) {
case _SaveInterval() when $default != null:
return $default(_that.seconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveInterval extends SaveInterval {
  const _SaveInterval({required this.seconds}): super._();
  factory _SaveInterval.fromJson(Map<String, dynamic> json) => _$SaveIntervalFromJson(json);

@override final  int seconds;

/// Create a copy of SaveInterval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveIntervalCopyWith<_SaveInterval> get copyWith => __$SaveIntervalCopyWithImpl<_SaveInterval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveIntervalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveInterval&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seconds);

@override
String toString() {
  return 'SaveInterval(seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class _$SaveIntervalCopyWith<$Res> implements $SaveIntervalCopyWith<$Res> {
  factory _$SaveIntervalCopyWith(_SaveInterval value, $Res Function(_SaveInterval) _then) = __$SaveIntervalCopyWithImpl;
@override @useResult
$Res call({
 int seconds
});




}
/// @nodoc
class __$SaveIntervalCopyWithImpl<$Res>
    implements _$SaveIntervalCopyWith<$Res> {
  __$SaveIntervalCopyWithImpl(this._self, this._then);

  final _SaveInterval _self;
  final $Res Function(_SaveInterval) _then;

/// Create a copy of SaveInterval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seconds = null,}) {
  return _then(_SaveInterval(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
