// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent()';
}


}

/// @nodoc
class $EditorEventCopyWith<$Res>  {
$EditorEventCopyWith(EditorEvent _, $Res Function(EditorEvent) __);
}


/// Adds pattern-matching-related methods to [EditorEvent].
extension EditorEventPatterns on EditorEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FileOpened value)?  fileOpened,TResult Function( FileClosed value)?  fileClosed,TResult Function( FileContentChanged value)?  fileContentChanged,TResult Function( FileSaved value)?  fileSaved,TResult Function( FileCreated value)?  fileCreated,TResult Function( FileDeleted value)?  fileDeleted,TResult Function( FileRenamed value)?  fileRenamed,TResult Function( FileMoved value)?  fileMoved,TResult Function( FolderCreated value)?  folderCreated,TResult Function( FolderDeleted value)?  folderDeleted,TResult Function( FolderRenamed value)?  folderRenamed,TResult Function( FolderMoved value)?  folderMoved,TResult Function( ProjectChanged value)?  projectChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that);case FileClosed() when fileClosed != null:
return fileClosed(_that);case FileContentChanged() when fileContentChanged != null:
return fileContentChanged(_that);case FileSaved() when fileSaved != null:
return fileSaved(_that);case FileCreated() when fileCreated != null:
return fileCreated(_that);case FileDeleted() when fileDeleted != null:
return fileDeleted(_that);case FileRenamed() when fileRenamed != null:
return fileRenamed(_that);case FileMoved() when fileMoved != null:
return fileMoved(_that);case FolderCreated() when folderCreated != null:
return folderCreated(_that);case FolderDeleted() when folderDeleted != null:
return folderDeleted(_that);case FolderRenamed() when folderRenamed != null:
return folderRenamed(_that);case FolderMoved() when folderMoved != null:
return folderMoved(_that);case ProjectChanged() when projectChanged != null:
return projectChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FileOpened value)  fileOpened,required TResult Function( FileClosed value)  fileClosed,required TResult Function( FileContentChanged value)  fileContentChanged,required TResult Function( FileSaved value)  fileSaved,required TResult Function( FileCreated value)  fileCreated,required TResult Function( FileDeleted value)  fileDeleted,required TResult Function( FileRenamed value)  fileRenamed,required TResult Function( FileMoved value)  fileMoved,required TResult Function( FolderCreated value)  folderCreated,required TResult Function( FolderDeleted value)  folderDeleted,required TResult Function( FolderRenamed value)  folderRenamed,required TResult Function( FolderMoved value)  folderMoved,required TResult Function( ProjectChanged value)  projectChanged,}){
final _that = this;
switch (_that) {
case FileOpened():
return fileOpened(_that);case FileClosed():
return fileClosed(_that);case FileContentChanged():
return fileContentChanged(_that);case FileSaved():
return fileSaved(_that);case FileCreated():
return fileCreated(_that);case FileDeleted():
return fileDeleted(_that);case FileRenamed():
return fileRenamed(_that);case FileMoved():
return fileMoved(_that);case FolderCreated():
return folderCreated(_that);case FolderDeleted():
return folderDeleted(_that);case FolderRenamed():
return folderRenamed(_that);case FolderMoved():
return folderMoved(_that);case ProjectChanged():
return projectChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FileOpened value)?  fileOpened,TResult? Function( FileClosed value)?  fileClosed,TResult? Function( FileContentChanged value)?  fileContentChanged,TResult? Function( FileSaved value)?  fileSaved,TResult? Function( FileCreated value)?  fileCreated,TResult? Function( FileDeleted value)?  fileDeleted,TResult? Function( FileRenamed value)?  fileRenamed,TResult? Function( FileMoved value)?  fileMoved,TResult? Function( FolderCreated value)?  folderCreated,TResult? Function( FolderDeleted value)?  folderDeleted,TResult? Function( FolderRenamed value)?  folderRenamed,TResult? Function( FolderMoved value)?  folderMoved,TResult? Function( ProjectChanged value)?  projectChanged,}){
final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that);case FileClosed() when fileClosed != null:
return fileClosed(_that);case FileContentChanged() when fileContentChanged != null:
return fileContentChanged(_that);case FileSaved() when fileSaved != null:
return fileSaved(_that);case FileCreated() when fileCreated != null:
return fileCreated(_that);case FileDeleted() when fileDeleted != null:
return fileDeleted(_that);case FileRenamed() when fileRenamed != null:
return fileRenamed(_that);case FileMoved() when fileMoved != null:
return fileMoved(_that);case FolderCreated() when folderCreated != null:
return folderCreated(_that);case FolderDeleted() when folderDeleted != null:
return folderDeleted(_that);case FolderRenamed() when folderRenamed != null:
return folderRenamed(_that);case FolderMoved() when folderMoved != null:
return folderMoved(_that);case ProjectChanged() when projectChanged != null:
return projectChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FileDocument file)?  fileOpened,TResult Function( String fileId)?  fileClosed,TResult Function( String fileId,  String content)?  fileContentChanged,TResult Function( FileDocument file)?  fileSaved,TResult Function( FileDocument file)?  fileCreated,TResult Function( String fileId)?  fileDeleted,TResult Function( String fileId,  String oldName,  String newName)?  fileRenamed,TResult Function( String fileId,  String oldFolderId,  String newFolderId)?  fileMoved,TResult Function( Folder folder)?  folderCreated,TResult Function( String folderId)?  folderDeleted,TResult Function( String folderId,  String oldName,  String newName)?  folderRenamed,TResult Function( String folderId,  String? oldParentId,  String? newParentId)?  folderMoved,TResult Function( String projectId)?  projectChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that.file);case FileClosed() when fileClosed != null:
return fileClosed(_that.fileId);case FileContentChanged() when fileContentChanged != null:
return fileContentChanged(_that.fileId,_that.content);case FileSaved() when fileSaved != null:
return fileSaved(_that.file);case FileCreated() when fileCreated != null:
return fileCreated(_that.file);case FileDeleted() when fileDeleted != null:
return fileDeleted(_that.fileId);case FileRenamed() when fileRenamed != null:
return fileRenamed(_that.fileId,_that.oldName,_that.newName);case FileMoved() when fileMoved != null:
return fileMoved(_that.fileId,_that.oldFolderId,_that.newFolderId);case FolderCreated() when folderCreated != null:
return folderCreated(_that.folder);case FolderDeleted() when folderDeleted != null:
return folderDeleted(_that.folderId);case FolderRenamed() when folderRenamed != null:
return folderRenamed(_that.folderId,_that.oldName,_that.newName);case FolderMoved() when folderMoved != null:
return folderMoved(_that.folderId,_that.oldParentId,_that.newParentId);case ProjectChanged() when projectChanged != null:
return projectChanged(_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FileDocument file)  fileOpened,required TResult Function( String fileId)  fileClosed,required TResult Function( String fileId,  String content)  fileContentChanged,required TResult Function( FileDocument file)  fileSaved,required TResult Function( FileDocument file)  fileCreated,required TResult Function( String fileId)  fileDeleted,required TResult Function( String fileId,  String oldName,  String newName)  fileRenamed,required TResult Function( String fileId,  String oldFolderId,  String newFolderId)  fileMoved,required TResult Function( Folder folder)  folderCreated,required TResult Function( String folderId)  folderDeleted,required TResult Function( String folderId,  String oldName,  String newName)  folderRenamed,required TResult Function( String folderId,  String? oldParentId,  String? newParentId)  folderMoved,required TResult Function( String projectId)  projectChanged,}) {final _that = this;
switch (_that) {
case FileOpened():
return fileOpened(_that.file);case FileClosed():
return fileClosed(_that.fileId);case FileContentChanged():
return fileContentChanged(_that.fileId,_that.content);case FileSaved():
return fileSaved(_that.file);case FileCreated():
return fileCreated(_that.file);case FileDeleted():
return fileDeleted(_that.fileId);case FileRenamed():
return fileRenamed(_that.fileId,_that.oldName,_that.newName);case FileMoved():
return fileMoved(_that.fileId,_that.oldFolderId,_that.newFolderId);case FolderCreated():
return folderCreated(_that.folder);case FolderDeleted():
return folderDeleted(_that.folderId);case FolderRenamed():
return folderRenamed(_that.folderId,_that.oldName,_that.newName);case FolderMoved():
return folderMoved(_that.folderId,_that.oldParentId,_that.newParentId);case ProjectChanged():
return projectChanged(_that.projectId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FileDocument file)?  fileOpened,TResult? Function( String fileId)?  fileClosed,TResult? Function( String fileId,  String content)?  fileContentChanged,TResult? Function( FileDocument file)?  fileSaved,TResult? Function( FileDocument file)?  fileCreated,TResult? Function( String fileId)?  fileDeleted,TResult? Function( String fileId,  String oldName,  String newName)?  fileRenamed,TResult? Function( String fileId,  String oldFolderId,  String newFolderId)?  fileMoved,TResult? Function( Folder folder)?  folderCreated,TResult? Function( String folderId)?  folderDeleted,TResult? Function( String folderId,  String oldName,  String newName)?  folderRenamed,TResult? Function( String folderId,  String? oldParentId,  String? newParentId)?  folderMoved,TResult? Function( String projectId)?  projectChanged,}) {final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that.file);case FileClosed() when fileClosed != null:
return fileClosed(_that.fileId);case FileContentChanged() when fileContentChanged != null:
return fileContentChanged(_that.fileId,_that.content);case FileSaved() when fileSaved != null:
return fileSaved(_that.file);case FileCreated() when fileCreated != null:
return fileCreated(_that.file);case FileDeleted() when fileDeleted != null:
return fileDeleted(_that.fileId);case FileRenamed() when fileRenamed != null:
return fileRenamed(_that.fileId,_that.oldName,_that.newName);case FileMoved() when fileMoved != null:
return fileMoved(_that.fileId,_that.oldFolderId,_that.newFolderId);case FolderCreated() when folderCreated != null:
return folderCreated(_that.folder);case FolderDeleted() when folderDeleted != null:
return folderDeleted(_that.folderId);case FolderRenamed() when folderRenamed != null:
return folderRenamed(_that.folderId,_that.oldName,_that.newName);case FolderMoved() when folderMoved != null:
return folderMoved(_that.folderId,_that.oldParentId,_that.newParentId);case ProjectChanged() when projectChanged != null:
return projectChanged(_that.projectId);case _:
  return null;

}
}

}

/// @nodoc


class FileOpened extends EditorEvent {
  const FileOpened({required this.file}): super._();
  

 final  FileDocument file;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileOpenedCopyWith<FileOpened> get copyWith => _$FileOpenedCopyWithImpl<FileOpened>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileOpened&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'EditorEvent.fileOpened(file: $file)';
}


}

/// @nodoc
abstract mixin class $FileOpenedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileOpenedCopyWith(FileOpened value, $Res Function(FileOpened) _then) = _$FileOpenedCopyWithImpl;
@useResult
$Res call({
 FileDocument file
});


$FileDocumentCopyWith<$Res> get file;

}
/// @nodoc
class _$FileOpenedCopyWithImpl<$Res>
    implements $FileOpenedCopyWith<$Res> {
  _$FileOpenedCopyWithImpl(this._self, this._then);

  final FileOpened _self;
  final $Res Function(FileOpened) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(FileOpened(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as FileDocument,
  ));
}

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileDocumentCopyWith<$Res> get file {
  
  return $FileDocumentCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

/// @nodoc


class FileClosed extends EditorEvent {
  const FileClosed({required this.fileId}): super._();
  

 final  String fileId;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileClosedCopyWith<FileClosed> get copyWith => _$FileClosedCopyWithImpl<FileClosed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileClosed&&(identical(other.fileId, fileId) || other.fileId == fileId));
}


@override
int get hashCode => Object.hash(runtimeType,fileId);

@override
String toString() {
  return 'EditorEvent.fileClosed(fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class $FileClosedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileClosedCopyWith(FileClosed value, $Res Function(FileClosed) _then) = _$FileClosedCopyWithImpl;
@useResult
$Res call({
 String fileId
});




}
/// @nodoc
class _$FileClosedCopyWithImpl<$Res>
    implements $FileClosedCopyWith<$Res> {
  _$FileClosedCopyWithImpl(this._self, this._then);

  final FileClosed _self;
  final $Res Function(FileClosed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileId = null,}) {
  return _then(FileClosed(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FileContentChanged extends EditorEvent {
  const FileContentChanged({required this.fileId, required this.content}): super._();
  

 final  String fileId;
 final  String content;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileContentChangedCopyWith<FileContentChanged> get copyWith => _$FileContentChangedCopyWithImpl<FileContentChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileContentChanged&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,fileId,content);

@override
String toString() {
  return 'EditorEvent.fileContentChanged(fileId: $fileId, content: $content)';
}


}

/// @nodoc
abstract mixin class $FileContentChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileContentChangedCopyWith(FileContentChanged value, $Res Function(FileContentChanged) _then) = _$FileContentChangedCopyWithImpl;
@useResult
$Res call({
 String fileId, String content
});




}
/// @nodoc
class _$FileContentChangedCopyWithImpl<$Res>
    implements $FileContentChangedCopyWith<$Res> {
  _$FileContentChangedCopyWithImpl(this._self, this._then);

  final FileContentChanged _self;
  final $Res Function(FileContentChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? content = null,}) {
  return _then(FileContentChanged(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FileSaved extends EditorEvent {
  const FileSaved({required this.file}): super._();
  

 final  FileDocument file;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileSavedCopyWith<FileSaved> get copyWith => _$FileSavedCopyWithImpl<FileSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileSaved&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'EditorEvent.fileSaved(file: $file)';
}


}

/// @nodoc
abstract mixin class $FileSavedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileSavedCopyWith(FileSaved value, $Res Function(FileSaved) _then) = _$FileSavedCopyWithImpl;
@useResult
$Res call({
 FileDocument file
});


$FileDocumentCopyWith<$Res> get file;

}
/// @nodoc
class _$FileSavedCopyWithImpl<$Res>
    implements $FileSavedCopyWith<$Res> {
  _$FileSavedCopyWithImpl(this._self, this._then);

  final FileSaved _self;
  final $Res Function(FileSaved) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(FileSaved(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as FileDocument,
  ));
}

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileDocumentCopyWith<$Res> get file {
  
  return $FileDocumentCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

/// @nodoc


class FileCreated extends EditorEvent {
  const FileCreated({required this.file}): super._();
  

 final  FileDocument file;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileCreatedCopyWith<FileCreated> get copyWith => _$FileCreatedCopyWithImpl<FileCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileCreated&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'EditorEvent.fileCreated(file: $file)';
}


}

/// @nodoc
abstract mixin class $FileCreatedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileCreatedCopyWith(FileCreated value, $Res Function(FileCreated) _then) = _$FileCreatedCopyWithImpl;
@useResult
$Res call({
 FileDocument file
});


$FileDocumentCopyWith<$Res> get file;

}
/// @nodoc
class _$FileCreatedCopyWithImpl<$Res>
    implements $FileCreatedCopyWith<$Res> {
  _$FileCreatedCopyWithImpl(this._self, this._then);

  final FileCreated _self;
  final $Res Function(FileCreated) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(FileCreated(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as FileDocument,
  ));
}

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileDocumentCopyWith<$Res> get file {
  
  return $FileDocumentCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

/// @nodoc


class FileDeleted extends EditorEvent {
  const FileDeleted({required this.fileId}): super._();
  

 final  String fileId;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileDeletedCopyWith<FileDeleted> get copyWith => _$FileDeletedCopyWithImpl<FileDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileDeleted&&(identical(other.fileId, fileId) || other.fileId == fileId));
}


@override
int get hashCode => Object.hash(runtimeType,fileId);

@override
String toString() {
  return 'EditorEvent.fileDeleted(fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class $FileDeletedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileDeletedCopyWith(FileDeleted value, $Res Function(FileDeleted) _then) = _$FileDeletedCopyWithImpl;
@useResult
$Res call({
 String fileId
});




}
/// @nodoc
class _$FileDeletedCopyWithImpl<$Res>
    implements $FileDeletedCopyWith<$Res> {
  _$FileDeletedCopyWithImpl(this._self, this._then);

  final FileDeleted _self;
  final $Res Function(FileDeleted) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileId = null,}) {
  return _then(FileDeleted(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FileRenamed extends EditorEvent {
  const FileRenamed({required this.fileId, required this.oldName, required this.newName}): super._();
  

 final  String fileId;
 final  String oldName;
 final  String newName;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileRenamedCopyWith<FileRenamed> get copyWith => _$FileRenamedCopyWithImpl<FileRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileRenamed&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.oldName, oldName) || other.oldName == oldName)&&(identical(other.newName, newName) || other.newName == newName));
}


@override
int get hashCode => Object.hash(runtimeType,fileId,oldName,newName);

@override
String toString() {
  return 'EditorEvent.fileRenamed(fileId: $fileId, oldName: $oldName, newName: $newName)';
}


}

/// @nodoc
abstract mixin class $FileRenamedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileRenamedCopyWith(FileRenamed value, $Res Function(FileRenamed) _then) = _$FileRenamedCopyWithImpl;
@useResult
$Res call({
 String fileId, String oldName, String newName
});




}
/// @nodoc
class _$FileRenamedCopyWithImpl<$Res>
    implements $FileRenamedCopyWith<$Res> {
  _$FileRenamedCopyWithImpl(this._self, this._then);

  final FileRenamed _self;
  final $Res Function(FileRenamed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? oldName = null,Object? newName = null,}) {
  return _then(FileRenamed(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,oldName: null == oldName ? _self.oldName : oldName // ignore: cast_nullable_to_non_nullable
as String,newName: null == newName ? _self.newName : newName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FileMoved extends EditorEvent {
  const FileMoved({required this.fileId, required this.oldFolderId, required this.newFolderId}): super._();
  

 final  String fileId;
 final  String oldFolderId;
 final  String newFolderId;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileMovedCopyWith<FileMoved> get copyWith => _$FileMovedCopyWithImpl<FileMoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileMoved&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.oldFolderId, oldFolderId) || other.oldFolderId == oldFolderId)&&(identical(other.newFolderId, newFolderId) || other.newFolderId == newFolderId));
}


@override
int get hashCode => Object.hash(runtimeType,fileId,oldFolderId,newFolderId);

@override
String toString() {
  return 'EditorEvent.fileMoved(fileId: $fileId, oldFolderId: $oldFolderId, newFolderId: $newFolderId)';
}


}

/// @nodoc
abstract mixin class $FileMovedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileMovedCopyWith(FileMoved value, $Res Function(FileMoved) _then) = _$FileMovedCopyWithImpl;
@useResult
$Res call({
 String fileId, String oldFolderId, String newFolderId
});




}
/// @nodoc
class _$FileMovedCopyWithImpl<$Res>
    implements $FileMovedCopyWith<$Res> {
  _$FileMovedCopyWithImpl(this._self, this._then);

  final FileMoved _self;
  final $Res Function(FileMoved) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? oldFolderId = null,Object? newFolderId = null,}) {
  return _then(FileMoved(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,oldFolderId: null == oldFolderId ? _self.oldFolderId : oldFolderId // ignore: cast_nullable_to_non_nullable
as String,newFolderId: null == newFolderId ? _self.newFolderId : newFolderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FolderCreated extends EditorEvent {
  const FolderCreated({required this.folder}): super._();
  

 final  Folder folder;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderCreatedCopyWith<FolderCreated> get copyWith => _$FolderCreatedCopyWithImpl<FolderCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderCreated&&(identical(other.folder, folder) || other.folder == folder));
}


@override
int get hashCode => Object.hash(runtimeType,folder);

@override
String toString() {
  return 'EditorEvent.folderCreated(folder: $folder)';
}


}

/// @nodoc
abstract mixin class $FolderCreatedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FolderCreatedCopyWith(FolderCreated value, $Res Function(FolderCreated) _then) = _$FolderCreatedCopyWithImpl;
@useResult
$Res call({
 Folder folder
});


$FolderCopyWith<$Res> get folder;

}
/// @nodoc
class _$FolderCreatedCopyWithImpl<$Res>
    implements $FolderCreatedCopyWith<$Res> {
  _$FolderCreatedCopyWithImpl(this._self, this._then);

  final FolderCreated _self;
  final $Res Function(FolderCreated) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folder = null,}) {
  return _then(FolderCreated(
folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as Folder,
  ));
}

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FolderCopyWith<$Res> get folder {
  
  return $FolderCopyWith<$Res>(_self.folder, (value) {
    return _then(_self.copyWith(folder: value));
  });
}
}

/// @nodoc


class FolderDeleted extends EditorEvent {
  const FolderDeleted({required this.folderId}): super._();
  

 final  String folderId;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderDeletedCopyWith<FolderDeleted> get copyWith => _$FolderDeletedCopyWithImpl<FolderDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderDeleted&&(identical(other.folderId, folderId) || other.folderId == folderId));
}


@override
int get hashCode => Object.hash(runtimeType,folderId);

@override
String toString() {
  return 'EditorEvent.folderDeleted(folderId: $folderId)';
}


}

/// @nodoc
abstract mixin class $FolderDeletedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FolderDeletedCopyWith(FolderDeleted value, $Res Function(FolderDeleted) _then) = _$FolderDeletedCopyWithImpl;
@useResult
$Res call({
 String folderId
});




}
/// @nodoc
class _$FolderDeletedCopyWithImpl<$Res>
    implements $FolderDeletedCopyWith<$Res> {
  _$FolderDeletedCopyWithImpl(this._self, this._then);

  final FolderDeleted _self;
  final $Res Function(FolderDeleted) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folderId = null,}) {
  return _then(FolderDeleted(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FolderRenamed extends EditorEvent {
  const FolderRenamed({required this.folderId, required this.oldName, required this.newName}): super._();
  

 final  String folderId;
 final  String oldName;
 final  String newName;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderRenamedCopyWith<FolderRenamed> get copyWith => _$FolderRenamedCopyWithImpl<FolderRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderRenamed&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.oldName, oldName) || other.oldName == oldName)&&(identical(other.newName, newName) || other.newName == newName));
}


@override
int get hashCode => Object.hash(runtimeType,folderId,oldName,newName);

@override
String toString() {
  return 'EditorEvent.folderRenamed(folderId: $folderId, oldName: $oldName, newName: $newName)';
}


}

/// @nodoc
abstract mixin class $FolderRenamedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FolderRenamedCopyWith(FolderRenamed value, $Res Function(FolderRenamed) _then) = _$FolderRenamedCopyWithImpl;
@useResult
$Res call({
 String folderId, String oldName, String newName
});




}
/// @nodoc
class _$FolderRenamedCopyWithImpl<$Res>
    implements $FolderRenamedCopyWith<$Res> {
  _$FolderRenamedCopyWithImpl(this._self, this._then);

  final FolderRenamed _self;
  final $Res Function(FolderRenamed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? oldName = null,Object? newName = null,}) {
  return _then(FolderRenamed(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,oldName: null == oldName ? _self.oldName : oldName // ignore: cast_nullable_to_non_nullable
as String,newName: null == newName ? _self.newName : newName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FolderMoved extends EditorEvent {
  const FolderMoved({required this.folderId, this.oldParentId, this.newParentId}): super._();
  

 final  String folderId;
 final  String? oldParentId;
 final  String? newParentId;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderMovedCopyWith<FolderMoved> get copyWith => _$FolderMovedCopyWithImpl<FolderMoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderMoved&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.oldParentId, oldParentId) || other.oldParentId == oldParentId)&&(identical(other.newParentId, newParentId) || other.newParentId == newParentId));
}


@override
int get hashCode => Object.hash(runtimeType,folderId,oldParentId,newParentId);

@override
String toString() {
  return 'EditorEvent.folderMoved(folderId: $folderId, oldParentId: $oldParentId, newParentId: $newParentId)';
}


}

/// @nodoc
abstract mixin class $FolderMovedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FolderMovedCopyWith(FolderMoved value, $Res Function(FolderMoved) _then) = _$FolderMovedCopyWithImpl;
@useResult
$Res call({
 String folderId, String? oldParentId, String? newParentId
});




}
/// @nodoc
class _$FolderMovedCopyWithImpl<$Res>
    implements $FolderMovedCopyWith<$Res> {
  _$FolderMovedCopyWithImpl(this._self, this._then);

  final FolderMoved _self;
  final $Res Function(FolderMoved) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? oldParentId = freezed,Object? newParentId = freezed,}) {
  return _then(FolderMoved(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,oldParentId: freezed == oldParentId ? _self.oldParentId : oldParentId // ignore: cast_nullable_to_non_nullable
as String?,newParentId: freezed == newParentId ? _self.newParentId : newParentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ProjectChanged extends EditorEvent {
  const ProjectChanged({required this.projectId}): super._();
  

 final  String projectId;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectChangedCopyWith<ProjectChanged> get copyWith => _$ProjectChangedCopyWithImpl<ProjectChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectChanged&&(identical(other.projectId, projectId) || other.projectId == projectId));
}


@override
int get hashCode => Object.hash(runtimeType,projectId);

@override
String toString() {
  return 'EditorEvent.projectChanged(projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $ProjectChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ProjectChangedCopyWith(ProjectChanged value, $Res Function(ProjectChanged) _then) = _$ProjectChangedCopyWithImpl;
@useResult
$Res call({
 String projectId
});




}
/// @nodoc
class _$ProjectChangedCopyWithImpl<$Res>
    implements $ProjectChangedCopyWith<$Res> {
  _$ProjectChangedCopyWithImpl(this._self, this._then);

  final ProjectChanged _self;
  final $Res Function(ProjectChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? projectId = null,}) {
  return _then(ProjectChanged(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
