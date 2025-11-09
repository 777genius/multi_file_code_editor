// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_icons_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileIconsConfig {

/// Default icon theme to use
 String get defaultTheme;/// Maximum number of icons to cache in memory
 int get maxCacheSize;/// Enable fallback to default icons when custom icons fail
 bool get enableFallback;/// Icon size in logical pixels
 int get iconSize;/// Priority for this plugin's icons (lower = higher priority)
 int get priority;
/// Create a copy of FileIconsConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileIconsConfigCopyWith<FileIconsConfig> get copyWith => _$FileIconsConfigCopyWithImpl<FileIconsConfig>(this as FileIconsConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileIconsConfig&&(identical(other.defaultTheme, defaultTheme) || other.defaultTheme == defaultTheme)&&(identical(other.maxCacheSize, maxCacheSize) || other.maxCacheSize == maxCacheSize)&&(identical(other.enableFallback, enableFallback) || other.enableFallback == enableFallback)&&(identical(other.iconSize, iconSize) || other.iconSize == iconSize)&&(identical(other.priority, priority) || other.priority == priority));
}


@override
int get hashCode => Object.hash(runtimeType,defaultTheme,maxCacheSize,enableFallback,iconSize,priority);

@override
String toString() {
  return 'FileIconsConfig(defaultTheme: $defaultTheme, maxCacheSize: $maxCacheSize, enableFallback: $enableFallback, iconSize: $iconSize, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $FileIconsConfigCopyWith<$Res>  {
  factory $FileIconsConfigCopyWith(FileIconsConfig value, $Res Function(FileIconsConfig) _then) = _$FileIconsConfigCopyWithImpl;
@useResult
$Res call({
 String defaultTheme, int maxCacheSize, bool enableFallback, int iconSize, int priority
});




}
/// @nodoc
class _$FileIconsConfigCopyWithImpl<$Res>
    implements $FileIconsConfigCopyWith<$Res> {
  _$FileIconsConfigCopyWithImpl(this._self, this._then);

  final FileIconsConfig _self;
  final $Res Function(FileIconsConfig) _then;

/// Create a copy of FileIconsConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultTheme = null,Object? maxCacheSize = null,Object? enableFallback = null,Object? iconSize = null,Object? priority = null,}) {
  return _then(_self.copyWith(
defaultTheme: null == defaultTheme ? _self.defaultTheme : defaultTheme // ignore: cast_nullable_to_non_nullable
as String,maxCacheSize: null == maxCacheSize ? _self.maxCacheSize : maxCacheSize // ignore: cast_nullable_to_non_nullable
as int,enableFallback: null == enableFallback ? _self.enableFallback : enableFallback // ignore: cast_nullable_to_non_nullable
as bool,iconSize: null == iconSize ? _self.iconSize : iconSize // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FileIconsConfig].
extension FileIconsConfigPatterns on FileIconsConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileIconsConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileIconsConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileIconsConfig value)  $default,){
final _that = this;
switch (_that) {
case _FileIconsConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileIconsConfig value)?  $default,){
final _that = this;
switch (_that) {
case _FileIconsConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String defaultTheme,  int maxCacheSize,  bool enableFallback,  int iconSize,  int priority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileIconsConfig() when $default != null:
return $default(_that.defaultTheme,_that.maxCacheSize,_that.enableFallback,_that.iconSize,_that.priority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String defaultTheme,  int maxCacheSize,  bool enableFallback,  int iconSize,  int priority)  $default,) {final _that = this;
switch (_that) {
case _FileIconsConfig():
return $default(_that.defaultTheme,_that.maxCacheSize,_that.enableFallback,_that.iconSize,_that.priority);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String defaultTheme,  int maxCacheSize,  bool enableFallback,  int iconSize,  int priority)?  $default,) {final _that = this;
switch (_that) {
case _FileIconsConfig() when $default != null:
return $default(_that.defaultTheme,_that.maxCacheSize,_that.enableFallback,_that.iconSize,_that.priority);case _:
  return null;

}
}

}

/// @nodoc


class _FileIconsConfig implements FileIconsConfig {
  const _FileIconsConfig({this.defaultTheme = 'iconify-vscode', this.maxCacheSize = 100, this.enableFallback = true, this.iconSize = 18, this.priority = 50});
  

/// Default icon theme to use
@override@JsonKey() final  String defaultTheme;
/// Maximum number of icons to cache in memory
@override@JsonKey() final  int maxCacheSize;
/// Enable fallback to default icons when custom icons fail
@override@JsonKey() final  bool enableFallback;
/// Icon size in logical pixels
@override@JsonKey() final  int iconSize;
/// Priority for this plugin's icons (lower = higher priority)
@override@JsonKey() final  int priority;

/// Create a copy of FileIconsConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileIconsConfigCopyWith<_FileIconsConfig> get copyWith => __$FileIconsConfigCopyWithImpl<_FileIconsConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileIconsConfig&&(identical(other.defaultTheme, defaultTheme) || other.defaultTheme == defaultTheme)&&(identical(other.maxCacheSize, maxCacheSize) || other.maxCacheSize == maxCacheSize)&&(identical(other.enableFallback, enableFallback) || other.enableFallback == enableFallback)&&(identical(other.iconSize, iconSize) || other.iconSize == iconSize)&&(identical(other.priority, priority) || other.priority == priority));
}


@override
int get hashCode => Object.hash(runtimeType,defaultTheme,maxCacheSize,enableFallback,iconSize,priority);

@override
String toString() {
  return 'FileIconsConfig(defaultTheme: $defaultTheme, maxCacheSize: $maxCacheSize, enableFallback: $enableFallback, iconSize: $iconSize, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$FileIconsConfigCopyWith<$Res> implements $FileIconsConfigCopyWith<$Res> {
  factory _$FileIconsConfigCopyWith(_FileIconsConfig value, $Res Function(_FileIconsConfig) _then) = __$FileIconsConfigCopyWithImpl;
@override @useResult
$Res call({
 String defaultTheme, int maxCacheSize, bool enableFallback, int iconSize, int priority
});




}
/// @nodoc
class __$FileIconsConfigCopyWithImpl<$Res>
    implements _$FileIconsConfigCopyWith<$Res> {
  __$FileIconsConfigCopyWithImpl(this._self, this._then);

  final _FileIconsConfig _self;
  final $Res Function(_FileIconsConfig) _then;

/// Create a copy of FileIconsConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultTheme = null,Object? maxCacheSize = null,Object? enableFallback = null,Object? iconSize = null,Object? priority = null,}) {
  return _then(_FileIconsConfig(
defaultTheme: null == defaultTheme ? _self.defaultTheme : defaultTheme // ignore: cast_nullable_to_non_nullable
as String,maxCacheSize: null == maxCacheSize ? _self.maxCacheSize : maxCacheSize // ignore: cast_nullable_to_non_nullable
as int,enableFallback: null == enableFallback ? _self.enableFallback : enableFallback // ignore: cast_nullable_to_non_nullable
as bool,iconSize: null == iconSize ? _self.iconSize : iconSize // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
