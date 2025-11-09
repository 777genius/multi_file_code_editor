// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugin_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PluginConfiguration {

 PluginId get pluginId; bool get enabled; Map<String, dynamic> get settings; DateTime? get lastModified;
/// Create a copy of PluginConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PluginConfigurationCopyWith<PluginConfiguration> get copyWith => _$PluginConfigurationCopyWithImpl<PluginConfiguration>(this as PluginConfiguration, _$identity);

  /// Serializes this PluginConfiguration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PluginConfiguration&&(identical(other.pluginId, pluginId) || other.pluginId == pluginId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.settings, settings)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pluginId,enabled,const DeepCollectionEquality().hash(settings),lastModified);

@override
String toString() {
  return 'PluginConfiguration(pluginId: $pluginId, enabled: $enabled, settings: $settings, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class $PluginConfigurationCopyWith<$Res>  {
  factory $PluginConfigurationCopyWith(PluginConfiguration value, $Res Function(PluginConfiguration) _then) = _$PluginConfigurationCopyWithImpl;
@useResult
$Res call({
 PluginId pluginId, bool enabled, Map<String, dynamic> settings, DateTime? lastModified
});


$PluginIdCopyWith<$Res> get pluginId;

}
/// @nodoc
class _$PluginConfigurationCopyWithImpl<$Res>
    implements $PluginConfigurationCopyWith<$Res> {
  _$PluginConfigurationCopyWithImpl(this._self, this._then);

  final PluginConfiguration _self;
  final $Res Function(PluginConfiguration) _then;

/// Create a copy of PluginConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pluginId = null,Object? enabled = null,Object? settings = null,Object? lastModified = freezed,}) {
  return _then(_self.copyWith(
pluginId: null == pluginId ? _self.pluginId : pluginId // ignore: cast_nullable_to_non_nullable
as PluginId,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PluginConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PluginIdCopyWith<$Res> get pluginId {
  
  return $PluginIdCopyWith<$Res>(_self.pluginId, (value) {
    return _then(_self.copyWith(pluginId: value));
  });
}
}


/// Adds pattern-matching-related methods to [PluginConfiguration].
extension PluginConfigurationPatterns on PluginConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PluginConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PluginConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PluginConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _PluginConfiguration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PluginConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _PluginConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PluginId pluginId,  bool enabled,  Map<String, dynamic> settings,  DateTime? lastModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PluginConfiguration() when $default != null:
return $default(_that.pluginId,_that.enabled,_that.settings,_that.lastModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PluginId pluginId,  bool enabled,  Map<String, dynamic> settings,  DateTime? lastModified)  $default,) {final _that = this;
switch (_that) {
case _PluginConfiguration():
return $default(_that.pluginId,_that.enabled,_that.settings,_that.lastModified);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PluginId pluginId,  bool enabled,  Map<String, dynamic> settings,  DateTime? lastModified)?  $default,) {final _that = this;
switch (_that) {
case _PluginConfiguration() when $default != null:
return $default(_that.pluginId,_that.enabled,_that.settings,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PluginConfiguration extends PluginConfiguration {
  const _PluginConfiguration({required this.pluginId, required this.enabled, final  Map<String, dynamic> settings = const {}, this.lastModified}): _settings = settings,super._();
  factory _PluginConfiguration.fromJson(Map<String, dynamic> json) => _$PluginConfigurationFromJson(json);

@override final  PluginId pluginId;
@override final  bool enabled;
 final  Map<String, dynamic> _settings;
@override@JsonKey() Map<String, dynamic> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}

@override final  DateTime? lastModified;

/// Create a copy of PluginConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PluginConfigurationCopyWith<_PluginConfiguration> get copyWith => __$PluginConfigurationCopyWithImpl<_PluginConfiguration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PluginConfigurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PluginConfiguration&&(identical(other.pluginId, pluginId) || other.pluginId == pluginId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pluginId,enabled,const DeepCollectionEquality().hash(_settings),lastModified);

@override
String toString() {
  return 'PluginConfiguration(pluginId: $pluginId, enabled: $enabled, settings: $settings, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$PluginConfigurationCopyWith<$Res> implements $PluginConfigurationCopyWith<$Res> {
  factory _$PluginConfigurationCopyWith(_PluginConfiguration value, $Res Function(_PluginConfiguration) _then) = __$PluginConfigurationCopyWithImpl;
@override @useResult
$Res call({
 PluginId pluginId, bool enabled, Map<String, dynamic> settings, DateTime? lastModified
});


@override $PluginIdCopyWith<$Res> get pluginId;

}
/// @nodoc
class __$PluginConfigurationCopyWithImpl<$Res>
    implements _$PluginConfigurationCopyWith<$Res> {
  __$PluginConfigurationCopyWithImpl(this._self, this._then);

  final _PluginConfiguration _self;
  final $Res Function(_PluginConfiguration) _then;

/// Create a copy of PluginConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pluginId = null,Object? enabled = null,Object? settings = null,Object? lastModified = freezed,}) {
  return _then(_PluginConfiguration(
pluginId: null == pluginId ? _self.pluginId : pluginId // ignore: cast_nullable_to_non_nullable
as PluginId,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PluginConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PluginIdCopyWith<$Res> get pluginId {
  
  return $PluginIdCopyWith<$Res>(_self.pluginId, (value) {
    return _then(_self.copyWith(pluginId: value));
  });
}
}

// dart format on
