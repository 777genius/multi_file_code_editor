// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_tree_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileTreeNode {

 String get id; String get name; FileTreeNodeType get type; String? get parentId; String? get language; List<FileTreeNode> get children; bool get isExpanded; Map<String, dynamic> get metadata;
/// Create a copy of FileTreeNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileTreeNodeCopyWith<FileTreeNode> get copyWith => _$FileTreeNodeCopyWithImpl<FileTreeNode>(this as FileTreeNode, _$identity);

  /// Serializes this FileTreeNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileTreeNode&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.language, language) || other.language == language)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,parentId,language,const DeepCollectionEquality().hash(children),isExpanded,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'FileTreeNode(id: $id, name: $name, type: $type, parentId: $parentId, language: $language, children: $children, isExpanded: $isExpanded, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $FileTreeNodeCopyWith<$Res>  {
  factory $FileTreeNodeCopyWith(FileTreeNode value, $Res Function(FileTreeNode) _then) = _$FileTreeNodeCopyWithImpl;
@useResult
$Res call({
 String id, String name, FileTreeNodeType type, String? parentId, String? language, List<FileTreeNode> children, bool isExpanded, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$FileTreeNodeCopyWithImpl<$Res>
    implements $FileTreeNodeCopyWith<$Res> {
  _$FileTreeNodeCopyWithImpl(this._self, this._then);

  final FileTreeNode _self;
  final $Res Function(FileTreeNode) _then;

/// Create a copy of FileTreeNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? parentId = freezed,Object? language = freezed,Object? children = null,Object? isExpanded = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FileTreeNodeType,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<FileTreeNode>,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [FileTreeNode].
extension FileTreeNodePatterns on FileTreeNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileTreeNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileTreeNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileTreeNode value)  $default,){
final _that = this;
switch (_that) {
case _FileTreeNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileTreeNode value)?  $default,){
final _that = this;
switch (_that) {
case _FileTreeNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  FileTreeNodeType type,  String? parentId,  String? language,  List<FileTreeNode> children,  bool isExpanded,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileTreeNode() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.parentId,_that.language,_that.children,_that.isExpanded,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  FileTreeNodeType type,  String? parentId,  String? language,  List<FileTreeNode> children,  bool isExpanded,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _FileTreeNode():
return $default(_that.id,_that.name,_that.type,_that.parentId,_that.language,_that.children,_that.isExpanded,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  FileTreeNodeType type,  String? parentId,  String? language,  List<FileTreeNode> children,  bool isExpanded,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _FileTreeNode() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.parentId,_that.language,_that.children,_that.isExpanded,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileTreeNode extends FileTreeNode {
  const _FileTreeNode({required this.id, required this.name, required this.type, this.parentId, this.language, final  List<FileTreeNode> children = const [], this.isExpanded = false, final  Map<String, dynamic> metadata = const {}}): _children = children,_metadata = metadata,super._();
  factory _FileTreeNode.fromJson(Map<String, dynamic> json) => _$FileTreeNodeFromJson(json);

@override final  String id;
@override final  String name;
@override final  FileTreeNodeType type;
@override final  String? parentId;
@override final  String? language;
 final  List<FileTreeNode> _children;
@override@JsonKey() List<FileTreeNode> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override@JsonKey() final  bool isExpanded;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of FileTreeNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileTreeNodeCopyWith<_FileTreeNode> get copyWith => __$FileTreeNodeCopyWithImpl<_FileTreeNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileTreeNodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileTreeNode&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.language, language) || other.language == language)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,parentId,language,const DeepCollectionEquality().hash(_children),isExpanded,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'FileTreeNode(id: $id, name: $name, type: $type, parentId: $parentId, language: $language, children: $children, isExpanded: $isExpanded, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$FileTreeNodeCopyWith<$Res> implements $FileTreeNodeCopyWith<$Res> {
  factory _$FileTreeNodeCopyWith(_FileTreeNode value, $Res Function(_FileTreeNode) _then) = __$FileTreeNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, FileTreeNodeType type, String? parentId, String? language, List<FileTreeNode> children, bool isExpanded, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$FileTreeNodeCopyWithImpl<$Res>
    implements _$FileTreeNodeCopyWith<$Res> {
  __$FileTreeNodeCopyWithImpl(this._self, this._then);

  final _FileTreeNode _self;
  final $Res Function(_FileTreeNode) _then;

/// Create a copy of FileTreeNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? parentId = freezed,Object? language = freezed,Object? children = null,Object? isExpanded = null,Object? metadata = null,}) {
  return _then(_FileTreeNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FileTreeNodeType,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<FileTreeNode>,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
