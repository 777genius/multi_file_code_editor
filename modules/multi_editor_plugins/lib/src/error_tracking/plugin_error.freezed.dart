// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugin_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PluginError {

 String get pluginId; String get pluginName; PluginErrorType get type; String get message; DateTime get timestamp;@JsonKey(includeFromJson: false, includeToJson: false) StackTrace? get stackTrace; Map<String, dynamic> get context;
/// Create a copy of PluginError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PluginErrorCopyWith<PluginError> get copyWith => _$PluginErrorCopyWithImpl<PluginError>(this as PluginError, _$identity);

  /// Serializes this PluginError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PluginError&&(identical(other.pluginId, pluginId) || other.pluginId == pluginId)&&(identical(other.pluginName, pluginName) || other.pluginName == pluginName)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&const DeepCollectionEquality().equals(other.context, context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pluginId,pluginName,type,message,timestamp,stackTrace,const DeepCollectionEquality().hash(context));

@override
String toString() {
  return 'PluginError(pluginId: $pluginId, pluginName: $pluginName, type: $type, message: $message, timestamp: $timestamp, stackTrace: $stackTrace, context: $context)';
}


}

/// @nodoc
abstract mixin class $PluginErrorCopyWith<$Res>  {
  factory $PluginErrorCopyWith(PluginError value, $Res Function(PluginError) _then) = _$PluginErrorCopyWithImpl;
@useResult
$Res call({
 String pluginId, String pluginName, PluginErrorType type, String message, DateTime timestamp,@JsonKey(includeFromJson: false, includeToJson: false) StackTrace? stackTrace, Map<String, dynamic> context
});




}
/// @nodoc
class _$PluginErrorCopyWithImpl<$Res>
    implements $PluginErrorCopyWith<$Res> {
  _$PluginErrorCopyWithImpl(this._self, this._then);

  final PluginError _self;
  final $Res Function(PluginError) _then;

/// Create a copy of PluginError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pluginId = null,Object? pluginName = null,Object? type = null,Object? message = null,Object? timestamp = null,Object? stackTrace = freezed,Object? context = null,}) {
  return _then(_self.copyWith(
pluginId: null == pluginId ? _self.pluginId : pluginId // ignore: cast_nullable_to_non_nullable
as String,pluginName: null == pluginName ? _self.pluginName : pluginName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PluginErrorType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [PluginError].
extension PluginErrorPatterns on PluginError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PluginError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PluginError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PluginError value)  $default,){
final _that = this;
switch (_that) {
case _PluginError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PluginError value)?  $default,){
final _that = this;
switch (_that) {
case _PluginError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pluginId,  String pluginName,  PluginErrorType type,  String message,  DateTime timestamp, @JsonKey(includeFromJson: false, includeToJson: false)  StackTrace? stackTrace,  Map<String, dynamic> context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PluginError() when $default != null:
return $default(_that.pluginId,_that.pluginName,_that.type,_that.message,_that.timestamp,_that.stackTrace,_that.context);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pluginId,  String pluginName,  PluginErrorType type,  String message,  DateTime timestamp, @JsonKey(includeFromJson: false, includeToJson: false)  StackTrace? stackTrace,  Map<String, dynamic> context)  $default,) {final _that = this;
switch (_that) {
case _PluginError():
return $default(_that.pluginId,_that.pluginName,_that.type,_that.message,_that.timestamp,_that.stackTrace,_that.context);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pluginId,  String pluginName,  PluginErrorType type,  String message,  DateTime timestamp, @JsonKey(includeFromJson: false, includeToJson: false)  StackTrace? stackTrace,  Map<String, dynamic> context)?  $default,) {final _that = this;
switch (_that) {
case _PluginError() when $default != null:
return $default(_that.pluginId,_that.pluginName,_that.type,_that.message,_that.timestamp,_that.stackTrace,_that.context);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PluginError extends PluginError {
  const _PluginError({required this.pluginId, required this.pluginName, required this.type, required this.message, required this.timestamp, @JsonKey(includeFromJson: false, includeToJson: false) this.stackTrace, final  Map<String, dynamic> context = const {}}): _context = context,super._();
  factory _PluginError.fromJson(Map<String, dynamic> json) => _$PluginErrorFromJson(json);

@override final  String pluginId;
@override final  String pluginName;
@override final  PluginErrorType type;
@override final  String message;
@override final  DateTime timestamp;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  StackTrace? stackTrace;
 final  Map<String, dynamic> _context;
@override@JsonKey() Map<String, dynamic> get context {
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_context);
}


/// Create a copy of PluginError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PluginErrorCopyWith<_PluginError> get copyWith => __$PluginErrorCopyWithImpl<_PluginError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PluginErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PluginError&&(identical(other.pluginId, pluginId) || other.pluginId == pluginId)&&(identical(other.pluginName, pluginName) || other.pluginName == pluginName)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&const DeepCollectionEquality().equals(other._context, _context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pluginId,pluginName,type,message,timestamp,stackTrace,const DeepCollectionEquality().hash(_context));

@override
String toString() {
  return 'PluginError(pluginId: $pluginId, pluginName: $pluginName, type: $type, message: $message, timestamp: $timestamp, stackTrace: $stackTrace, context: $context)';
}


}

/// @nodoc
abstract mixin class _$PluginErrorCopyWith<$Res> implements $PluginErrorCopyWith<$Res> {
  factory _$PluginErrorCopyWith(_PluginError value, $Res Function(_PluginError) _then) = __$PluginErrorCopyWithImpl;
@override @useResult
$Res call({
 String pluginId, String pluginName, PluginErrorType type, String message, DateTime timestamp,@JsonKey(includeFromJson: false, includeToJson: false) StackTrace? stackTrace, Map<String, dynamic> context
});




}
/// @nodoc
class __$PluginErrorCopyWithImpl<$Res>
    implements _$PluginErrorCopyWith<$Res> {
  __$PluginErrorCopyWithImpl(this._self, this._then);

  final _PluginError _self;
  final $Res Function(_PluginError) _then;

/// Create a copy of PluginError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pluginId = null,Object? pluginName = null,Object? type = null,Object? message = null,Object? timestamp = null,Object? stackTrace = freezed,Object? context = null,}) {
  return _then(_PluginError(
pluginId: null == pluginId ? _self.pluginId : pluginId // ignore: cast_nullable_to_non_nullable
as String,pluginName: null == pluginName ? _self.pluginName : pluginName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PluginErrorType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
