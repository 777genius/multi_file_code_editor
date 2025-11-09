// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileIcon {

/// URL to the icon image (CDN)
 IconUrl get url;/// File extension this icon represents (e.g., "dart", "json")
 String get extension;/// Icon theme ID (e.g., "vscode-icons", "material-icons")
 String get themeId;/// Icon format (e.g., "svg", "png")
 String get format;/// Icon size in pixels
 int get size;/// Whether this icon has been successfully loaded
 bool get isLoaded;/// Error message if loading failed
 String? get errorMessage;
/// Create a copy of FileIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileIconCopyWith<FileIcon> get copyWith => _$FileIconCopyWithImpl<FileIcon>(this as FileIcon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileIcon&&(identical(other.url, url) || other.url == url)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.themeId, themeId) || other.themeId == themeId)&&(identical(other.format, format) || other.format == format)&&(identical(other.size, size) || other.size == size)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,url,extension,themeId,format,size,isLoaded,errorMessage);

@override
String toString() {
  return 'FileIcon(url: $url, extension: $extension, themeId: $themeId, format: $format, size: $size, isLoaded: $isLoaded, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FileIconCopyWith<$Res>  {
  factory $FileIconCopyWith(FileIcon value, $Res Function(FileIcon) _then) = _$FileIconCopyWithImpl;
@useResult
$Res call({
 IconUrl url, String extension, String themeId, String format, int size, bool isLoaded, String? errorMessage
});


$IconUrlCopyWith<$Res> get url;

}
/// @nodoc
class _$FileIconCopyWithImpl<$Res>
    implements $FileIconCopyWith<$Res> {
  _$FileIconCopyWithImpl(this._self, this._then);

  final FileIcon _self;
  final $Res Function(FileIcon) _then;

/// Create a copy of FileIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? extension = null,Object? themeId = null,Object? format = null,Object? size = null,Object? isLoaded = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as IconUrl,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,themeId: null == themeId ? _self.themeId : themeId // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FileIcon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IconUrlCopyWith<$Res> get url {
  
  return $IconUrlCopyWith<$Res>(_self.url, (value) {
    return _then(_self.copyWith(url: value));
  });
}
}


/// Adds pattern-matching-related methods to [FileIcon].
extension FileIconPatterns on FileIcon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileIcon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileIcon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileIcon value)  $default,){
final _that = this;
switch (_that) {
case _FileIcon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileIcon value)?  $default,){
final _that = this;
switch (_that) {
case _FileIcon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconUrl url,  String extension,  String themeId,  String format,  int size,  bool isLoaded,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileIcon() when $default != null:
return $default(_that.url,_that.extension,_that.themeId,_that.format,_that.size,_that.isLoaded,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconUrl url,  String extension,  String themeId,  String format,  int size,  bool isLoaded,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _FileIcon():
return $default(_that.url,_that.extension,_that.themeId,_that.format,_that.size,_that.isLoaded,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconUrl url,  String extension,  String themeId,  String format,  int size,  bool isLoaded,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _FileIcon() when $default != null:
return $default(_that.url,_that.extension,_that.themeId,_that.format,_that.size,_that.isLoaded,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _FileIcon extends FileIcon {
  const _FileIcon({required this.url, required this.extension, required this.themeId, this.format = 'svg', this.size = 18, this.isLoaded = false, this.errorMessage}): super._();
  

/// URL to the icon image (CDN)
@override final  IconUrl url;
/// File extension this icon represents (e.g., "dart", "json")
@override final  String extension;
/// Icon theme ID (e.g., "vscode-icons", "material-icons")
@override final  String themeId;
/// Icon format (e.g., "svg", "png")
@override@JsonKey() final  String format;
/// Icon size in pixels
@override@JsonKey() final  int size;
/// Whether this icon has been successfully loaded
@override@JsonKey() final  bool isLoaded;
/// Error message if loading failed
@override final  String? errorMessage;

/// Create a copy of FileIcon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileIconCopyWith<_FileIcon> get copyWith => __$FileIconCopyWithImpl<_FileIcon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileIcon&&(identical(other.url, url) || other.url == url)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.themeId, themeId) || other.themeId == themeId)&&(identical(other.format, format) || other.format == format)&&(identical(other.size, size) || other.size == size)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,url,extension,themeId,format,size,isLoaded,errorMessage);

@override
String toString() {
  return 'FileIcon(url: $url, extension: $extension, themeId: $themeId, format: $format, size: $size, isLoaded: $isLoaded, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$FileIconCopyWith<$Res> implements $FileIconCopyWith<$Res> {
  factory _$FileIconCopyWith(_FileIcon value, $Res Function(_FileIcon) _then) = __$FileIconCopyWithImpl;
@override @useResult
$Res call({
 IconUrl url, String extension, String themeId, String format, int size, bool isLoaded, String? errorMessage
});


@override $IconUrlCopyWith<$Res> get url;

}
/// @nodoc
class __$FileIconCopyWithImpl<$Res>
    implements _$FileIconCopyWith<$Res> {
  __$FileIconCopyWithImpl(this._self, this._then);

  final _FileIcon _self;
  final $Res Function(_FileIcon) _then;

/// Create a copy of FileIcon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? extension = null,Object? themeId = null,Object? format = null,Object? size = null,Object? isLoaded = null,Object? errorMessage = freezed,}) {
  return _then(_FileIcon(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as IconUrl,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,themeId: null == themeId ? _self.themeId : themeId // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FileIcon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IconUrlCopyWith<$Res> get url {
  
  return $IconUrlCopyWith<$Res>(_self.url, (value) {
    return _then(_self.copyWith(url: value));
  });
}
}

// dart format on
