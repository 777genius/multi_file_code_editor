// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'domain_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DomainFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DomainFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DomainFailure()';
}


}

/// @nodoc
class $DomainFailureCopyWith<$Res>  {
$DomainFailureCopyWith(DomainFailure _, $Res Function(DomainFailure) __);
}


/// Adds pattern-matching-related methods to [DomainFailure].
extension DomainFailurePatterns on DomainFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NotFound value)?  notFound,TResult Function( _AlreadyExists value)?  alreadyExists,TResult Function( _ValidationError value)?  validationError,TResult Function( _PermissionDenied value)?  permissionDenied,TResult Function( _SyncError value)?  syncError,TResult Function( _Unexpected value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that);case _AlreadyExists() when alreadyExists != null:
return alreadyExists(_that);case _ValidationError() when validationError != null:
return validationError(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _SyncError() when syncError != null:
return syncError(_that);case _Unexpected() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NotFound value)  notFound,required TResult Function( _AlreadyExists value)  alreadyExists,required TResult Function( _ValidationError value)  validationError,required TResult Function( _PermissionDenied value)  permissionDenied,required TResult Function( _SyncError value)  syncError,required TResult Function( _Unexpected value)  unexpected,}){
final _that = this;
switch (_that) {
case _NotFound():
return notFound(_that);case _AlreadyExists():
return alreadyExists(_that);case _ValidationError():
return validationError(_that);case _PermissionDenied():
return permissionDenied(_that);case _SyncError():
return syncError(_that);case _Unexpected():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NotFound value)?  notFound,TResult? Function( _AlreadyExists value)?  alreadyExists,TResult? Function( _ValidationError value)?  validationError,TResult? Function( _PermissionDenied value)?  permissionDenied,TResult? Function( _SyncError value)?  syncError,TResult? Function( _Unexpected value)?  unexpected,}){
final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that);case _AlreadyExists() when alreadyExists != null:
return alreadyExists(_that);case _ValidationError() when validationError != null:
return validationError(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _SyncError() when syncError != null:
return syncError(_that);case _Unexpected() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String entityType,  String entityId,  String? message)?  notFound,TResult Function( String entityType,  String entityId,  String? message)?  alreadyExists,TResult Function( String field,  String reason,  String? value)?  validationError,TResult Function( String operation,  String resource,  String? message)?  permissionDenied,TResult Function( String operation,  String? message,  Object? cause)?  syncError,TResult Function( String message,  Object? cause,  StackTrace? stackTrace)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that.entityType,_that.entityId,_that.message);case _AlreadyExists() when alreadyExists != null:
return alreadyExists(_that.entityType,_that.entityId,_that.message);case _ValidationError() when validationError != null:
return validationError(_that.field,_that.reason,_that.value);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.operation,_that.resource,_that.message);case _SyncError() when syncError != null:
return syncError(_that.operation,_that.message,_that.cause);case _Unexpected() when unexpected != null:
return unexpected(_that.message,_that.cause,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String entityType,  String entityId,  String? message)  notFound,required TResult Function( String entityType,  String entityId,  String? message)  alreadyExists,required TResult Function( String field,  String reason,  String? value)  validationError,required TResult Function( String operation,  String resource,  String? message)  permissionDenied,required TResult Function( String operation,  String? message,  Object? cause)  syncError,required TResult Function( String message,  Object? cause,  StackTrace? stackTrace)  unexpected,}) {final _that = this;
switch (_that) {
case _NotFound():
return notFound(_that.entityType,_that.entityId,_that.message);case _AlreadyExists():
return alreadyExists(_that.entityType,_that.entityId,_that.message);case _ValidationError():
return validationError(_that.field,_that.reason,_that.value);case _PermissionDenied():
return permissionDenied(_that.operation,_that.resource,_that.message);case _SyncError():
return syncError(_that.operation,_that.message,_that.cause);case _Unexpected():
return unexpected(_that.message,_that.cause,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String entityType,  String entityId,  String? message)?  notFound,TResult? Function( String entityType,  String entityId,  String? message)?  alreadyExists,TResult? Function( String field,  String reason,  String? value)?  validationError,TResult? Function( String operation,  String resource,  String? message)?  permissionDenied,TResult? Function( String operation,  String? message,  Object? cause)?  syncError,TResult? Function( String message,  Object? cause,  StackTrace? stackTrace)?  unexpected,}) {final _that = this;
switch (_that) {
case _NotFound() when notFound != null:
return notFound(_that.entityType,_that.entityId,_that.message);case _AlreadyExists() when alreadyExists != null:
return alreadyExists(_that.entityType,_that.entityId,_that.message);case _ValidationError() when validationError != null:
return validationError(_that.field,_that.reason,_that.value);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.operation,_that.resource,_that.message);case _SyncError() when syncError != null:
return syncError(_that.operation,_that.message,_that.cause);case _Unexpected() when unexpected != null:
return unexpected(_that.message,_that.cause,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _NotFound extends DomainFailure {
  const _NotFound({required this.entityType, required this.entityId, this.message}): super._();
  

 final  String entityType;
 final  String entityId;
 final  String? message;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotFoundCopyWith<_NotFound> get copyWith => __$NotFoundCopyWithImpl<_NotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFound&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,entityType,entityId,message);

@override
String toString() {
  return 'DomainFailure.notFound(entityType: $entityType, entityId: $entityId, message: $message)';
}


}

/// @nodoc
abstract mixin class _$NotFoundCopyWith<$Res> implements $DomainFailureCopyWith<$Res> {
  factory _$NotFoundCopyWith(_NotFound value, $Res Function(_NotFound) _then) = __$NotFoundCopyWithImpl;
@useResult
$Res call({
 String entityType, String entityId, String? message
});




}
/// @nodoc
class __$NotFoundCopyWithImpl<$Res>
    implements _$NotFoundCopyWith<$Res> {
  __$NotFoundCopyWithImpl(this._self, this._then);

  final _NotFound _self;
  final $Res Function(_NotFound) _then;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entityType = null,Object? entityId = null,Object? message = freezed,}) {
  return _then(_NotFound(
entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _AlreadyExists extends DomainFailure {
  const _AlreadyExists({required this.entityType, required this.entityId, this.message}): super._();
  

 final  String entityType;
 final  String entityId;
 final  String? message;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlreadyExistsCopyWith<_AlreadyExists> get copyWith => __$AlreadyExistsCopyWithImpl<_AlreadyExists>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlreadyExists&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,entityType,entityId,message);

@override
String toString() {
  return 'DomainFailure.alreadyExists(entityType: $entityType, entityId: $entityId, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AlreadyExistsCopyWith<$Res> implements $DomainFailureCopyWith<$Res> {
  factory _$AlreadyExistsCopyWith(_AlreadyExists value, $Res Function(_AlreadyExists) _then) = __$AlreadyExistsCopyWithImpl;
@useResult
$Res call({
 String entityType, String entityId, String? message
});




}
/// @nodoc
class __$AlreadyExistsCopyWithImpl<$Res>
    implements _$AlreadyExistsCopyWith<$Res> {
  __$AlreadyExistsCopyWithImpl(this._self, this._then);

  final _AlreadyExists _self;
  final $Res Function(_AlreadyExists) _then;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entityType = null,Object? entityId = null,Object? message = freezed,}) {
  return _then(_AlreadyExists(
entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ValidationError extends DomainFailure {
  const _ValidationError({required this.field, required this.reason, this.value}): super._();
  

 final  String field;
 final  String reason;
 final  String? value;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidationErrorCopyWith<_ValidationError> get copyWith => __$ValidationErrorCopyWithImpl<_ValidationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValidationError&&(identical(other.field, field) || other.field == field)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,field,reason,value);

@override
String toString() {
  return 'DomainFailure.validationError(field: $field, reason: $reason, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ValidationErrorCopyWith<$Res> implements $DomainFailureCopyWith<$Res> {
  factory _$ValidationErrorCopyWith(_ValidationError value, $Res Function(_ValidationError) _then) = __$ValidationErrorCopyWithImpl;
@useResult
$Res call({
 String field, String reason, String? value
});




}
/// @nodoc
class __$ValidationErrorCopyWithImpl<$Res>
    implements _$ValidationErrorCopyWith<$Res> {
  __$ValidationErrorCopyWithImpl(this._self, this._then);

  final _ValidationError _self;
  final $Res Function(_ValidationError) _then;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field = null,Object? reason = null,Object? value = freezed,}) {
  return _then(_ValidationError(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _PermissionDenied extends DomainFailure {
  const _PermissionDenied({required this.operation, required this.resource, this.message}): super._();
  

 final  String operation;
 final  String resource;
 final  String? message;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionDeniedCopyWith<_PermissionDenied> get copyWith => __$PermissionDeniedCopyWithImpl<_PermissionDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDenied&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.resource, resource) || other.resource == resource)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,operation,resource,message);

@override
String toString() {
  return 'DomainFailure.permissionDenied(operation: $operation, resource: $resource, message: $message)';
}


}

/// @nodoc
abstract mixin class _$PermissionDeniedCopyWith<$Res> implements $DomainFailureCopyWith<$Res> {
  factory _$PermissionDeniedCopyWith(_PermissionDenied value, $Res Function(_PermissionDenied) _then) = __$PermissionDeniedCopyWithImpl;
@useResult
$Res call({
 String operation, String resource, String? message
});




}
/// @nodoc
class __$PermissionDeniedCopyWithImpl<$Res>
    implements _$PermissionDeniedCopyWith<$Res> {
  __$PermissionDeniedCopyWithImpl(this._self, this._then);

  final _PermissionDenied _self;
  final $Res Function(_PermissionDenied) _then;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? resource = null,Object? message = freezed,}) {
  return _then(_PermissionDenied(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,resource: null == resource ? _self.resource : resource // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _SyncError extends DomainFailure {
  const _SyncError({required this.operation, this.message, this.cause}): super._();
  

 final  String operation;
 final  String? message;
 final  Object? cause;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncErrorCopyWith<_SyncError> get copyWith => __$SyncErrorCopyWithImpl<_SyncError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncError&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,operation,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'DomainFailure.syncError(operation: $operation, message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class _$SyncErrorCopyWith<$Res> implements $DomainFailureCopyWith<$Res> {
  factory _$SyncErrorCopyWith(_SyncError value, $Res Function(_SyncError) _then) = __$SyncErrorCopyWithImpl;
@useResult
$Res call({
 String operation, String? message, Object? cause
});




}
/// @nodoc
class __$SyncErrorCopyWithImpl<$Res>
    implements _$SyncErrorCopyWith<$Res> {
  __$SyncErrorCopyWithImpl(this._self, this._then);

  final _SyncError _self;
  final $Res Function(_SyncError) _then;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? message = freezed,Object? cause = freezed,}) {
  return _then(_SyncError(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class _Unexpected extends DomainFailure {
  const _Unexpected({required this.message, this.cause, this.stackTrace}): super._();
  

 final  String message;
 final  Object? cause;
 final  StackTrace? stackTrace;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnexpectedCopyWith<_Unexpected> get copyWith => __$UnexpectedCopyWithImpl<_Unexpected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unexpected&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause),stackTrace);

@override
String toString() {
  return 'DomainFailure.unexpected(message: $message, cause: $cause, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$UnexpectedCopyWith<$Res> implements $DomainFailureCopyWith<$Res> {
  factory _$UnexpectedCopyWith(_Unexpected value, $Res Function(_Unexpected) _then) = __$UnexpectedCopyWithImpl;
@useResult
$Res call({
 String message, Object? cause, StackTrace? stackTrace
});




}
/// @nodoc
class __$UnexpectedCopyWithImpl<$Res>
    implements _$UnexpectedCopyWith<$Res> {
  __$UnexpectedCopyWithImpl(this._self, this._then);

  final _Unexpected _self;
  final $Res Function(_Unexpected) _then;

/// Create a copy of DomainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? cause = freezed,Object? stackTrace = freezed,}) {
  return _then(_Unexpected(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cause: freezed == cause ? _self.cause : cause ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
