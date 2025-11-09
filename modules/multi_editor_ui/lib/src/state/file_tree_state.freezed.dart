// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_tree_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileTreeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileTreeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FileTreeState()';
}


}

/// @nodoc
class $FileTreeStateCopyWith<$Res>  {
$FileTreeStateCopyWith(FileTreeState _, $Res Function(FileTreeState) __);
}


/// Adds pattern-matching-related methods to [FileTreeState].
extension FileTreeStatePatterns on FileTreeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( FileTreeNode rootNode,  String? selectedNodeId,  List<String> expandedFolderIds)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.rootNode,_that.selectedNodeId,_that.expandedFolderIds);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( FileTreeNode rootNode,  String? selectedNodeId,  List<String> expandedFolderIds)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.rootNode,_that.selectedNodeId,_that.expandedFolderIds);case _Error():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( FileTreeNode rootNode,  String? selectedNodeId,  List<String> expandedFolderIds)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.rootNode,_that.selectedNodeId,_that.expandedFolderIds);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends FileTreeState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FileTreeState.initial()';
}


}




/// @nodoc


class _Loading extends FileTreeState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FileTreeState.loading()';
}


}




/// @nodoc


class _Loaded extends FileTreeState {
  const _Loaded({required this.rootNode, this.selectedNodeId, final  List<String> expandedFolderIds = const []}): _expandedFolderIds = expandedFolderIds,super._();
  

 final  FileTreeNode rootNode;
 final  String? selectedNodeId;
 final  List<String> _expandedFolderIds;
@JsonKey() List<String> get expandedFolderIds {
  if (_expandedFolderIds is EqualUnmodifiableListView) return _expandedFolderIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expandedFolderIds);
}


/// Create a copy of FileTreeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.rootNode, rootNode) || other.rootNode == rootNode)&&(identical(other.selectedNodeId, selectedNodeId) || other.selectedNodeId == selectedNodeId)&&const DeepCollectionEquality().equals(other._expandedFolderIds, _expandedFolderIds));
}


@override
int get hashCode => Object.hash(runtimeType,rootNode,selectedNodeId,const DeepCollectionEquality().hash(_expandedFolderIds));

@override
String toString() {
  return 'FileTreeState.loaded(rootNode: $rootNode, selectedNodeId: $selectedNodeId, expandedFolderIds: $expandedFolderIds)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $FileTreeStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 FileTreeNode rootNode, String? selectedNodeId, List<String> expandedFolderIds
});


$FileTreeNodeCopyWith<$Res> get rootNode;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of FileTreeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rootNode = null,Object? selectedNodeId = freezed,Object? expandedFolderIds = null,}) {
  return _then(_Loaded(
rootNode: null == rootNode ? _self.rootNode : rootNode // ignore: cast_nullable_to_non_nullable
as FileTreeNode,selectedNodeId: freezed == selectedNodeId ? _self.selectedNodeId : selectedNodeId // ignore: cast_nullable_to_non_nullable
as String?,expandedFolderIds: null == expandedFolderIds ? _self._expandedFolderIds : expandedFolderIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of FileTreeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileTreeNodeCopyWith<$Res> get rootNode {
  
  return $FileTreeNodeCopyWith<$Res>(_self.rootNode, (value) {
    return _then(_self.copyWith(rootNode: value));
  });
}
}

/// @nodoc


class _Error extends FileTreeState {
  const _Error({required this.message}): super._();
  

 final  String message;

/// Create a copy of FileTreeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FileTreeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $FileTreeStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of FileTreeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
