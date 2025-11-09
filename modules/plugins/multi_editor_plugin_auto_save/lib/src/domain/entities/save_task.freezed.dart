// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaveTask {

 String get fileId; String get content; DateTime get scheduledAt; bool get completed; bool get failed; String? get errorMessage;
/// Create a copy of SaveTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveTaskCopyWith<SaveTask> get copyWith => _$SaveTaskCopyWithImpl<SaveTask>(this as SaveTask, _$identity);

  /// Serializes this SaveTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveTask&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.content, content) || other.content == content)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,content,scheduledAt,completed,failed,errorMessage);

@override
String toString() {
  return 'SaveTask(fileId: $fileId, content: $content, scheduledAt: $scheduledAt, completed: $completed, failed: $failed, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SaveTaskCopyWith<$Res>  {
  factory $SaveTaskCopyWith(SaveTask value, $Res Function(SaveTask) _then) = _$SaveTaskCopyWithImpl;
@useResult
$Res call({
 String fileId, String content, DateTime scheduledAt, bool completed, bool failed, String? errorMessage
});




}
/// @nodoc
class _$SaveTaskCopyWithImpl<$Res>
    implements $SaveTaskCopyWith<$Res> {
  _$SaveTaskCopyWithImpl(this._self, this._then);

  final SaveTask _self;
  final $Res Function(SaveTask) _then;

/// Create a copy of SaveTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? content = null,Object? scheduledAt = null,Object? completed = null,Object? failed = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveTask].
extension SaveTaskPatterns on SaveTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveTask value)  $default,){
final _that = this;
switch (_that) {
case _SaveTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveTask value)?  $default,){
final _that = this;
switch (_that) {
case _SaveTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String content,  DateTime scheduledAt,  bool completed,  bool failed,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveTask() when $default != null:
return $default(_that.fileId,_that.content,_that.scheduledAt,_that.completed,_that.failed,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String content,  DateTime scheduledAt,  bool completed,  bool failed,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SaveTask():
return $default(_that.fileId,_that.content,_that.scheduledAt,_that.completed,_that.failed,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String content,  DateTime scheduledAt,  bool completed,  bool failed,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SaveTask() when $default != null:
return $default(_that.fileId,_that.content,_that.scheduledAt,_that.completed,_that.failed,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveTask extends SaveTask {
  const _SaveTask({required this.fileId, required this.content, required this.scheduledAt, this.completed = false, this.failed = false, this.errorMessage}): super._();
  factory _SaveTask.fromJson(Map<String, dynamic> json) => _$SaveTaskFromJson(json);

@override final  String fileId;
@override final  String content;
@override final  DateTime scheduledAt;
@override@JsonKey() final  bool completed;
@override@JsonKey() final  bool failed;
@override final  String? errorMessage;

/// Create a copy of SaveTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveTaskCopyWith<_SaveTask> get copyWith => __$SaveTaskCopyWithImpl<_SaveTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveTask&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.content, content) || other.content == content)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,content,scheduledAt,completed,failed,errorMessage);

@override
String toString() {
  return 'SaveTask(fileId: $fileId, content: $content, scheduledAt: $scheduledAt, completed: $completed, failed: $failed, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SaveTaskCopyWith<$Res> implements $SaveTaskCopyWith<$Res> {
  factory _$SaveTaskCopyWith(_SaveTask value, $Res Function(_SaveTask) _then) = __$SaveTaskCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String content, DateTime scheduledAt, bool completed, bool failed, String? errorMessage
});




}
/// @nodoc
class __$SaveTaskCopyWithImpl<$Res>
    implements _$SaveTaskCopyWith<$Res> {
  __$SaveTaskCopyWithImpl(this._self, this._then);

  final _SaveTask _self;
  final $Res Function(_SaveTask) _then;

/// Create a copy of SaveTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? content = null,Object? scheduledAt = null,Object? completed = null,Object? failed = null,Object? errorMessage = freezed,}) {
  return _then(_SaveTask(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
