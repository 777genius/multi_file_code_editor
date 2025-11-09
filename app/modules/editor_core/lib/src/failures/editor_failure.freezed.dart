// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EditorFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorFailureCopyWith<$Res> {
  factory $EditorFailureCopyWith(
    EditorFailure value,
    $Res Function(EditorFailure) then,
  ) = _$EditorFailureCopyWithImpl<$Res, EditorFailure>;
}

/// @nodoc
class _$EditorFailureCopyWithImpl<$Res, $Val extends EditorFailure>
    implements $EditorFailureCopyWith<$Res> {
  _$EditorFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NotInitializedImplCopyWith<$Res> {
  factory _$$NotInitializedImplCopyWith(
    _$NotInitializedImpl value,
    $Res Function(_$NotInitializedImpl) then,
  ) = __$$NotInitializedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NotInitializedImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$NotInitializedImpl>
    implements _$$NotInitializedImplCopyWith<$Res> {
  __$$NotInitializedImplCopyWithImpl(
    _$NotInitializedImpl _value,
    $Res Function(_$NotInitializedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NotInitializedImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NotInitializedImpl implements _NotInitialized {
  const _$NotInitializedImpl({this.message = 'Editor is not initialized'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'EditorFailure.notInitialized(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotInitializedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotInitializedImplCopyWith<_$NotInitializedImpl> get copyWith =>
      __$$NotInitializedImplCopyWithImpl<_$NotInitializedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return notInitialized(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return notInitialized?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (notInitialized != null) {
      return notInitialized(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return notInitialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return notInitialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (notInitialized != null) {
      return notInitialized(this);
    }
    return orElse();
  }
}

abstract class _NotInitialized implements EditorFailure {
  const factory _NotInitialized({final String message}) = _$NotInitializedImpl;

  String get message;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotInitializedImplCopyWith<_$NotInitializedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidPositionImplCopyWith<$Res> {
  factory _$$InvalidPositionImplCopyWith(
    _$InvalidPositionImpl value,
    $Res Function(_$InvalidPositionImpl) then,
  ) = __$$InvalidPositionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InvalidPositionImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$InvalidPositionImpl>
    implements _$$InvalidPositionImplCopyWith<$Res> {
  __$$InvalidPositionImplCopyWithImpl(
    _$InvalidPositionImpl _value,
    $Res Function(_$InvalidPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$InvalidPositionImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InvalidPositionImpl implements _InvalidPosition {
  const _$InvalidPositionImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'EditorFailure.invalidPosition(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidPositionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidPositionImplCopyWith<_$InvalidPositionImpl> get copyWith =>
      __$$InvalidPositionImplCopyWithImpl<_$InvalidPositionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return invalidPosition(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return invalidPosition?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (invalidPosition != null) {
      return invalidPosition(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return invalidPosition(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return invalidPosition?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (invalidPosition != null) {
      return invalidPosition(this);
    }
    return orElse();
  }
}

abstract class _InvalidPosition implements EditorFailure {
  const factory _InvalidPosition({required final String message}) =
      _$InvalidPositionImpl;

  String get message;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidPositionImplCopyWith<_$InvalidPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidRangeImplCopyWith<$Res> {
  factory _$$InvalidRangeImplCopyWith(
    _$InvalidRangeImpl value,
    $Res Function(_$InvalidRangeImpl) then,
  ) = __$$InvalidRangeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InvalidRangeImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$InvalidRangeImpl>
    implements _$$InvalidRangeImplCopyWith<$Res> {
  __$$InvalidRangeImplCopyWithImpl(
    _$InvalidRangeImpl _value,
    $Res Function(_$InvalidRangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$InvalidRangeImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InvalidRangeImpl implements _InvalidRange {
  const _$InvalidRangeImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'EditorFailure.invalidRange(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidRangeImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidRangeImplCopyWith<_$InvalidRangeImpl> get copyWith =>
      __$$InvalidRangeImplCopyWithImpl<_$InvalidRangeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return invalidRange(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return invalidRange?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (invalidRange != null) {
      return invalidRange(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return invalidRange(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return invalidRange?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (invalidRange != null) {
      return invalidRange(this);
    }
    return orElse();
  }
}

abstract class _InvalidRange implements EditorFailure {
  const factory _InvalidRange({required final String message}) =
      _$InvalidRangeImpl;

  String get message;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidRangeImplCopyWith<_$InvalidRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentNotFoundImplCopyWith<$Res> {
  factory _$$DocumentNotFoundImplCopyWith(
    _$DocumentNotFoundImpl value,
    $Res Function(_$DocumentNotFoundImpl) then,
  ) = __$$DocumentNotFoundImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DocumentNotFoundImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$DocumentNotFoundImpl>
    implements _$$DocumentNotFoundImplCopyWith<$Res> {
  __$$DocumentNotFoundImplCopyWithImpl(
    _$DocumentNotFoundImpl _value,
    $Res Function(_$DocumentNotFoundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$DocumentNotFoundImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DocumentNotFoundImpl implements _DocumentNotFound {
  const _$DocumentNotFoundImpl({this.message = 'Document not found'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'EditorFailure.documentNotFound(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentNotFoundImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentNotFoundImplCopyWith<_$DocumentNotFoundImpl> get copyWith =>
      __$$DocumentNotFoundImplCopyWithImpl<_$DocumentNotFoundImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return documentNotFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return documentNotFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (documentNotFound != null) {
      return documentNotFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return documentNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return documentNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (documentNotFound != null) {
      return documentNotFound(this);
    }
    return orElse();
  }
}

abstract class _DocumentNotFound implements EditorFailure {
  const factory _DocumentNotFound({final String message}) =
      _$DocumentNotFoundImpl;

  String get message;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentNotFoundImplCopyWith<_$DocumentNotFoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationFailedImplCopyWith<$Res> {
  factory _$$OperationFailedImplCopyWith(
    _$OperationFailedImpl value,
    $Res Function(_$OperationFailedImpl) then,
  ) = __$$OperationFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String operation, String? reason});
}

/// @nodoc
class __$$OperationFailedImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$OperationFailedImpl>
    implements _$$OperationFailedImplCopyWith<$Res> {
  __$$OperationFailedImplCopyWithImpl(
    _$OperationFailedImpl _value,
    $Res Function(_$OperationFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operation = null, Object? reason = freezed}) {
    return _then(
      _$OperationFailedImpl(
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OperationFailedImpl implements _OperationFailed {
  const _$OperationFailedImpl({required this.operation, this.reason});

  @override
  final String operation;
  @override
  final String? reason;

  @override
  String toString() {
    return 'EditorFailure.operationFailed(operation: $operation, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationFailedImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation, reason);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationFailedImplCopyWith<_$OperationFailedImpl> get copyWith =>
      __$$OperationFailedImplCopyWithImpl<_$OperationFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return operationFailed(operation, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return operationFailed?.call(operation, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (operationFailed != null) {
      return operationFailed(operation, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return operationFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return operationFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (operationFailed != null) {
      return operationFailed(this);
    }
    return orElse();
  }
}

abstract class _OperationFailed implements EditorFailure {
  const factory _OperationFailed({
    required final String operation,
    final String? reason,
  }) = _$OperationFailedImpl;

  String get operation;
  String? get reason;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperationFailedImplCopyWith<_$OperationFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnsupportedOperationImplCopyWith<$Res> {
  factory _$$UnsupportedOperationImplCopyWith(
    _$UnsupportedOperationImpl value,
    $Res Function(_$UnsupportedOperationImpl) then,
  ) = __$$UnsupportedOperationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String operation});
}

/// @nodoc
class __$$UnsupportedOperationImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$UnsupportedOperationImpl>
    implements _$$UnsupportedOperationImplCopyWith<$Res> {
  __$$UnsupportedOperationImplCopyWithImpl(
    _$UnsupportedOperationImpl _value,
    $Res Function(_$UnsupportedOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operation = null}) {
    return _then(
      _$UnsupportedOperationImpl(
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnsupportedOperationImpl implements _UnsupportedOperation {
  const _$UnsupportedOperationImpl({required this.operation});

  @override
  final String operation;

  @override
  String toString() {
    return 'EditorFailure.unsupportedOperation(operation: $operation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnsupportedOperationImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnsupportedOperationImplCopyWith<_$UnsupportedOperationImpl>
  get copyWith =>
      __$$UnsupportedOperationImplCopyWithImpl<_$UnsupportedOperationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return unsupportedOperation(operation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return unsupportedOperation?.call(operation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (unsupportedOperation != null) {
      return unsupportedOperation(operation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return unsupportedOperation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return unsupportedOperation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (unsupportedOperation != null) {
      return unsupportedOperation(this);
    }
    return orElse();
  }
}

abstract class _UnsupportedOperation implements EditorFailure {
  const factory _UnsupportedOperation({required final String operation}) =
      _$UnsupportedOperationImpl;

  String get operation;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnsupportedOperationImplCopyWith<_$UnsupportedOperationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnexpectedImplCopyWith<$Res> {
  factory _$$UnexpectedImplCopyWith(
    _$UnexpectedImpl value,
    $Res Function(_$UnexpectedImpl) then,
  ) = __$$UnexpectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Object? error});
}

/// @nodoc
class __$$UnexpectedImplCopyWithImpl<$Res>
    extends _$EditorFailureCopyWithImpl<$Res, _$UnexpectedImpl>
    implements _$$UnexpectedImplCopyWith<$Res> {
  __$$UnexpectedImplCopyWithImpl(
    _$UnexpectedImpl _value,
    $Res Function(_$UnexpectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? error = freezed}) {
    return _then(
      _$UnexpectedImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error ? _value.error : error,
      ),
    );
  }
}

/// @nodoc

class _$UnexpectedImpl implements _Unexpected {
  const _$UnexpectedImpl({required this.message, this.error});

  @override
  final String message;
  @override
  final Object? error;

  @override
  String toString() {
    return 'EditorFailure.unexpected(message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
  );

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedImplCopyWith<_$UnexpectedImpl> get copyWith =>
      __$$UnexpectedImplCopyWithImpl<_$UnexpectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) notInitialized,
    required TResult Function(String message) invalidPosition,
    required TResult Function(String message) invalidRange,
    required TResult Function(String message) documentNotFound,
    required TResult Function(String operation, String? reason) operationFailed,
    required TResult Function(String operation) unsupportedOperation,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return unexpected(message, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? notInitialized,
    TResult? Function(String message)? invalidPosition,
    TResult? Function(String message)? invalidRange,
    TResult? Function(String message)? documentNotFound,
    TResult? Function(String operation, String? reason)? operationFailed,
    TResult? Function(String operation)? unsupportedOperation,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return unexpected?.call(message, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? notInitialized,
    TResult Function(String message)? invalidPosition,
    TResult Function(String message)? invalidRange,
    TResult Function(String message)? documentNotFound,
    TResult Function(String operation, String? reason)? operationFailed,
    TResult Function(String operation)? unsupportedOperation,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(message, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotInitialized value) notInitialized,
    required TResult Function(_InvalidPosition value) invalidPosition,
    required TResult Function(_InvalidRange value) invalidRange,
    required TResult Function(_DocumentNotFound value) documentNotFound,
    required TResult Function(_OperationFailed value) operationFailed,
    required TResult Function(_UnsupportedOperation value) unsupportedOperation,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotInitialized value)? notInitialized,
    TResult? Function(_InvalidPosition value)? invalidPosition,
    TResult? Function(_InvalidRange value)? invalidRange,
    TResult? Function(_DocumentNotFound value)? documentNotFound,
    TResult? Function(_OperationFailed value)? operationFailed,
    TResult? Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotInitialized value)? notInitialized,
    TResult Function(_InvalidPosition value)? invalidPosition,
    TResult Function(_InvalidRange value)? invalidRange,
    TResult Function(_DocumentNotFound value)? documentNotFound,
    TResult Function(_OperationFailed value)? operationFailed,
    TResult Function(_UnsupportedOperation value)? unsupportedOperation,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class _Unexpected implements EditorFailure {
  const factory _Unexpected({
    required final String message,
    final Object? error,
  }) = _$UnexpectedImpl;

  String get message;
  Object? get error;

  /// Create a copy of EditorFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnexpectedImplCopyWith<_$UnexpectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
