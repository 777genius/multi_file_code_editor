// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IconTheme {

/// Unique theme identifier
 String get id;/// Human-readable theme name
 String get name;/// Theme provider (e.g., "iconify", "vscode", "material")
 String get provider;/// Base CDN URL for this theme's icons
 String get baseUrl;/// Priority for icon selection (lower = higher priority)
 int get priority;/// Whether this theme is currently active
 bool get isActive;/// Supported file extensions for this theme
 List<String> get supportedExtensions;/// Theme metadata (version, author, etc.)
 Map<String, dynamic> get metadata;
/// Create a copy of IconTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconThemeCopyWith<IconTheme> get copyWith => _$IconThemeCopyWithImpl<IconTheme>(this as IconTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IconTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.supportedExtensions, supportedExtensions)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,provider,baseUrl,priority,isActive,const DeepCollectionEquality().hash(supportedExtensions),const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'IconTheme(id: $id, name: $name, provider: $provider, baseUrl: $baseUrl, priority: $priority, isActive: $isActive, supportedExtensions: $supportedExtensions, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $IconThemeCopyWith<$Res>  {
  factory $IconThemeCopyWith(IconTheme value, $Res Function(IconTheme) _then) = _$IconThemeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String provider, String baseUrl, int priority, bool isActive, List<String> supportedExtensions, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$IconThemeCopyWithImpl<$Res>
    implements $IconThemeCopyWith<$Res> {
  _$IconThemeCopyWithImpl(this._self, this._then);

  final IconTheme _self;
  final $Res Function(IconTheme) _then;

/// Create a copy of IconTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? provider = null,Object? baseUrl = null,Object? priority = null,Object? isActive = null,Object? supportedExtensions = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,supportedExtensions: null == supportedExtensions ? _self.supportedExtensions : supportedExtensions // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [IconTheme].
extension IconThemePatterns on IconTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IconTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IconTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IconTheme value)  $default,){
final _that = this;
switch (_that) {
case _IconTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IconTheme value)?  $default,){
final _that = this;
switch (_that) {
case _IconTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String provider,  String baseUrl,  int priority,  bool isActive,  List<String> supportedExtensions,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IconTheme() when $default != null:
return $default(_that.id,_that.name,_that.provider,_that.baseUrl,_that.priority,_that.isActive,_that.supportedExtensions,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String provider,  String baseUrl,  int priority,  bool isActive,  List<String> supportedExtensions,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _IconTheme():
return $default(_that.id,_that.name,_that.provider,_that.baseUrl,_that.priority,_that.isActive,_that.supportedExtensions,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String provider,  String baseUrl,  int priority,  bool isActive,  List<String> supportedExtensions,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _IconTheme() when $default != null:
return $default(_that.id,_that.name,_that.provider,_that.baseUrl,_that.priority,_that.isActive,_that.supportedExtensions,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc


class _IconTheme extends IconTheme {
  const _IconTheme({required this.id, required this.name, required this.provider, required this.baseUrl, this.priority = 100, this.isActive = false, final  List<String> supportedExtensions = const [], final  Map<String, dynamic> metadata = const {}}): _supportedExtensions = supportedExtensions,_metadata = metadata,super._();
  

/// Unique theme identifier
@override final  String id;
/// Human-readable theme name
@override final  String name;
/// Theme provider (e.g., "iconify", "vscode", "material")
@override final  String provider;
/// Base CDN URL for this theme's icons
@override final  String baseUrl;
/// Priority for icon selection (lower = higher priority)
@override@JsonKey() final  int priority;
/// Whether this theme is currently active
@override@JsonKey() final  bool isActive;
/// Supported file extensions for this theme
 final  List<String> _supportedExtensions;
/// Supported file extensions for this theme
@override@JsonKey() List<String> get supportedExtensions {
  if (_supportedExtensions is EqualUnmodifiableListView) return _supportedExtensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedExtensions);
}

/// Theme metadata (version, author, etc.)
 final  Map<String, dynamic> _metadata;
/// Theme metadata (version, author, etc.)
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of IconTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IconThemeCopyWith<_IconTheme> get copyWith => __$IconThemeCopyWithImpl<_IconTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IconTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._supportedExtensions, _supportedExtensions)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,provider,baseUrl,priority,isActive,const DeepCollectionEquality().hash(_supportedExtensions),const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'IconTheme(id: $id, name: $name, provider: $provider, baseUrl: $baseUrl, priority: $priority, isActive: $isActive, supportedExtensions: $supportedExtensions, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$IconThemeCopyWith<$Res> implements $IconThemeCopyWith<$Res> {
  factory _$IconThemeCopyWith(_IconTheme value, $Res Function(_IconTheme) _then) = __$IconThemeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String provider, String baseUrl, int priority, bool isActive, List<String> supportedExtensions, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$IconThemeCopyWithImpl<$Res>
    implements _$IconThemeCopyWith<$Res> {
  __$IconThemeCopyWithImpl(this._self, this._then);

  final _IconTheme _self;
  final $Res Function(_IconTheme) _then;

/// Create a copy of IconTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? provider = null,Object? baseUrl = null,Object? priority = null,Object? isActive = null,Object? supportedExtensions = null,Object? metadata = null,}) {
  return _then(_IconTheme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,supportedExtensions: null == supportedExtensions ? _self._supportedExtensions : supportedExtensions // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
