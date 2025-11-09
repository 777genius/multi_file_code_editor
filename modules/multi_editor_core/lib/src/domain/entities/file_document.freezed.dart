// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileDocument {

 String get id; String get name; String get folderId; String get content; String get language; DateTime get createdAt; DateTime get updatedAt; Map<String, dynamic>? get metadata;
/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileDocumentCopyWith<FileDocument> get copyWith => _$FileDocumentCopyWithImpl<FileDocument>(this as FileDocument, _$identity);

  /// Serializes this FileDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.language, language) || other.language == language)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,folderId,content,language,createdAt,updatedAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'FileDocument(id: $id, name: $name, folderId: $folderId, content: $content, language: $language, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $FileDocumentCopyWith<$Res>  {
  factory $FileDocumentCopyWith(FileDocument value, $Res Function(FileDocument) _then) = _$FileDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String name, String folderId, String content, String language, DateTime createdAt, DateTime updatedAt, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$FileDocumentCopyWithImpl<$Res>
    implements $FileDocumentCopyWith<$Res> {
  _$FileDocumentCopyWithImpl(this._self, this._then);

  final FileDocument _self;
  final $Res Function(FileDocument) _then;

/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? folderId = null,Object? content = null,Object? language = null,Object? createdAt = null,Object? updatedAt = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FileDocument].
extension FileDocumentPatterns on FileDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileDocument value)  $default,){
final _that = this;
switch (_that) {
case _FileDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileDocument value)?  $default,){
final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String folderId,  String content,  String language,  DateTime createdAt,  DateTime updatedAt,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
return $default(_that.id,_that.name,_that.folderId,_that.content,_that.language,_that.createdAt,_that.updatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String folderId,  String content,  String language,  DateTime createdAt,  DateTime updatedAt,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _FileDocument():
return $default(_that.id,_that.name,_that.folderId,_that.content,_that.language,_that.createdAt,_that.updatedAt,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String folderId,  String content,  String language,  DateTime createdAt,  DateTime updatedAt,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
return $default(_that.id,_that.name,_that.folderId,_that.content,_that.language,_that.createdAt,_that.updatedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileDocument extends FileDocument {
  const _FileDocument({required this.id, required this.name, required this.folderId, required this.content, required this.language, required this.createdAt, required this.updatedAt, final  Map<String, dynamic>? metadata}): _metadata = metadata,super._();
  factory _FileDocument.fromJson(Map<String, dynamic> json) => _$FileDocumentFromJson(json);

@override final  String id;
@override final  String name;
@override final  String folderId;
@override final  String content;
@override final  String language;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileDocumentCopyWith<_FileDocument> get copyWith => __$FileDocumentCopyWithImpl<_FileDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.language, language) || other.language == language)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,folderId,content,language,createdAt,updatedAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'FileDocument(id: $id, name: $name, folderId: $folderId, content: $content, language: $language, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$FileDocumentCopyWith<$Res> implements $FileDocumentCopyWith<$Res> {
  factory _$FileDocumentCopyWith(_FileDocument value, $Res Function(_FileDocument) _then) = __$FileDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String folderId, String content, String language, DateTime createdAt, DateTime updatedAt, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$FileDocumentCopyWithImpl<$Res>
    implements _$FileDocumentCopyWith<$Res> {
  __$FileDocumentCopyWithImpl(this._self, this._then);

  final _FileDocument _self;
  final $Res Function(_FileDocument) _then;

/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? folderId = null,Object? content = null,Object? language = null,Object? createdAt = null,Object? updatedAt = null,Object? metadata = freezed,}) {
  return _then(_FileDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
