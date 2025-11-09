// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_save_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutoSaveConfig {

 bool get enabled; SaveInterval get interval; bool get onlyWhenIdle; bool get showNotifications;
/// Create a copy of AutoSaveConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutoSaveConfigCopyWith<AutoSaveConfig> get copyWith => _$AutoSaveConfigCopyWithImpl<AutoSaveConfig>(this as AutoSaveConfig, _$identity);

  /// Serializes this AutoSaveConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoSaveConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.onlyWhenIdle, onlyWhenIdle) || other.onlyWhenIdle == onlyWhenIdle)&&(identical(other.showNotifications, showNotifications) || other.showNotifications == showNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,interval,onlyWhenIdle,showNotifications);

@override
String toString() {
  return 'AutoSaveConfig(enabled: $enabled, interval: $interval, onlyWhenIdle: $onlyWhenIdle, showNotifications: $showNotifications)';
}


}

/// @nodoc
abstract mixin class $AutoSaveConfigCopyWith<$Res>  {
  factory $AutoSaveConfigCopyWith(AutoSaveConfig value, $Res Function(AutoSaveConfig) _then) = _$AutoSaveConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled, SaveInterval interval, bool onlyWhenIdle, bool showNotifications
});


$SaveIntervalCopyWith<$Res> get interval;

}
/// @nodoc
class _$AutoSaveConfigCopyWithImpl<$Res>
    implements $AutoSaveConfigCopyWith<$Res> {
  _$AutoSaveConfigCopyWithImpl(this._self, this._then);

  final AutoSaveConfig _self;
  final $Res Function(AutoSaveConfig) _then;

/// Create a copy of AutoSaveConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? interval = null,Object? onlyWhenIdle = null,Object? showNotifications = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as SaveInterval,onlyWhenIdle: null == onlyWhenIdle ? _self.onlyWhenIdle : onlyWhenIdle // ignore: cast_nullable_to_non_nullable
as bool,showNotifications: null == showNotifications ? _self.showNotifications : showNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AutoSaveConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveIntervalCopyWith<$Res> get interval {
  
  return $SaveIntervalCopyWith<$Res>(_self.interval, (value) {
    return _then(_self.copyWith(interval: value));
  });
}
}


/// Adds pattern-matching-related methods to [AutoSaveConfig].
extension AutoSaveConfigPatterns on AutoSaveConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutoSaveConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutoSaveConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutoSaveConfig value)  $default,){
final _that = this;
switch (_that) {
case _AutoSaveConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutoSaveConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AutoSaveConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  SaveInterval interval,  bool onlyWhenIdle,  bool showNotifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutoSaveConfig() when $default != null:
return $default(_that.enabled,_that.interval,_that.onlyWhenIdle,_that.showNotifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  SaveInterval interval,  bool onlyWhenIdle,  bool showNotifications)  $default,) {final _that = this;
switch (_that) {
case _AutoSaveConfig():
return $default(_that.enabled,_that.interval,_that.onlyWhenIdle,_that.showNotifications);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  SaveInterval interval,  bool onlyWhenIdle,  bool showNotifications)?  $default,) {final _that = this;
switch (_that) {
case _AutoSaveConfig() when $default != null:
return $default(_that.enabled,_that.interval,_that.onlyWhenIdle,_that.showNotifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutoSaveConfig extends AutoSaveConfig {
  const _AutoSaveConfig({required this.enabled, required this.interval, this.onlyWhenIdle = false, this.showNotifications = true}): super._();
  factory _AutoSaveConfig.fromJson(Map<String, dynamic> json) => _$AutoSaveConfigFromJson(json);

@override final  bool enabled;
@override final  SaveInterval interval;
@override@JsonKey() final  bool onlyWhenIdle;
@override@JsonKey() final  bool showNotifications;

/// Create a copy of AutoSaveConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutoSaveConfigCopyWith<_AutoSaveConfig> get copyWith => __$AutoSaveConfigCopyWithImpl<_AutoSaveConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutoSaveConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutoSaveConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.onlyWhenIdle, onlyWhenIdle) || other.onlyWhenIdle == onlyWhenIdle)&&(identical(other.showNotifications, showNotifications) || other.showNotifications == showNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,interval,onlyWhenIdle,showNotifications);

@override
String toString() {
  return 'AutoSaveConfig(enabled: $enabled, interval: $interval, onlyWhenIdle: $onlyWhenIdle, showNotifications: $showNotifications)';
}


}

/// @nodoc
abstract mixin class _$AutoSaveConfigCopyWith<$Res> implements $AutoSaveConfigCopyWith<$Res> {
  factory _$AutoSaveConfigCopyWith(_AutoSaveConfig value, $Res Function(_AutoSaveConfig) _then) = __$AutoSaveConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, SaveInterval interval, bool onlyWhenIdle, bool showNotifications
});


@override $SaveIntervalCopyWith<$Res> get interval;

}
/// @nodoc
class __$AutoSaveConfigCopyWithImpl<$Res>
    implements _$AutoSaveConfigCopyWith<$Res> {
  __$AutoSaveConfigCopyWithImpl(this._self, this._then);

  final _AutoSaveConfig _self;
  final $Res Function(_AutoSaveConfig) _then;

/// Create a copy of AutoSaveConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? interval = null,Object? onlyWhenIdle = null,Object? showNotifications = null,}) {
  return _then(_AutoSaveConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as SaveInterval,onlyWhenIdle: null == onlyWhenIdle ? _self.onlyWhenIdle : onlyWhenIdle // ignore: cast_nullable_to_non_nullable
as bool,showNotifications: null == showNotifications ? _self.showNotifications : showNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AutoSaveConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveIntervalCopyWith<$Res> get interval {
  
  return $SaveIntervalCopyWith<$Res>(_self.interval, (value) {
    return _then(_self.copyWith(interval: value));
  });
}
}

// dart format on
