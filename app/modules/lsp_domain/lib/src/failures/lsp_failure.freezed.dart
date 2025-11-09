// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lsp_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LspFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LspFailureCopyWith<$Res> {
  factory $LspFailureCopyWith(
    LspFailure value,
    $Res Function(LspFailure) then,
  ) = _$LspFailureCopyWithImpl<$Res, LspFailure>;
}

/// @nodoc
class _$LspFailureCopyWithImpl<$Res, $Val extends LspFailure>
    implements $LspFailureCopyWith<$Res> {
  _$LspFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SessionNotFoundImplCopyWith<$Res> {
  factory _$$SessionNotFoundImplCopyWith(
    _$SessionNotFoundImpl value,
    $Res Function(_$SessionNotFoundImpl) then,
  ) = __$$SessionNotFoundImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SessionNotFoundImplCopyWithImpl<$Res>
    extends _$LspFailureCopyWithImpl<$Res, _$SessionNotFoundImpl>
    implements _$$SessionNotFoundImplCopyWith<$Res> {
  __$$SessionNotFoundImplCopyWithImpl(
    _$SessionNotFoundImpl _value,
    $Res Function(_$SessionNotFoundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SessionNotFoundImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SessionNotFoundImpl implements _SessionNotFound {
  const _$SessionNotFoundImpl({this.message = 'LSP session not found'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'LspFailure.sessionNotFound(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionNotFoundImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionNotFoundImplCopyWith<_$SessionNotFoundImpl> get copyWith =>
      __$$SessionNotFoundImplCopyWithImpl<_$SessionNotFoundImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return sessionNotFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return sessionNotFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (sessionNotFound != null) {
      return sessionNotFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return sessionNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return sessionNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (sessionNotFound != null) {
      return sessionNotFound(this);
    }
    return orElse();
  }
}

abstract class _SessionNotFound implements LspFailure {
  const factory _SessionNotFound({final String message}) =
      _$SessionNotFoundImpl;

  String get message;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionNotFoundImplCopyWith<_$SessionNotFoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitializationFailedImplCopyWith<$Res> {
  factory _$$InitializationFailedImplCopyWith(
    _$InitializationFailedImpl value,
    $Res Function(_$InitializationFailedImpl) then,
  ) = __$$InitializationFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$InitializationFailedImplCopyWithImpl<$Res>
    extends _$LspFailureCopyWithImpl<$Res, _$InitializationFailedImpl>
    implements _$$InitializationFailedImplCopyWith<$Res> {
  __$$InitializationFailedImplCopyWithImpl(
    _$InitializationFailedImpl _value,
    $Res Function(_$InitializationFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$InitializationFailedImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InitializationFailedImpl implements _InitializationFailed {
  const _$InitializationFailedImpl({required this.reason});

  @override
  final String reason;

  @override
  String toString() {
    return 'LspFailure.initializationFailed(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializationFailedImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializationFailedImplCopyWith<_$InitializationFailedImpl>
  get copyWith =>
      __$$InitializationFailedImplCopyWithImpl<_$InitializationFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return initializationFailed(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return initializationFailed?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (initializationFailed != null) {
      return initializationFailed(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return initializationFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return initializationFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (initializationFailed != null) {
      return initializationFailed(this);
    }
    return orElse();
  }
}

abstract class _InitializationFailed implements LspFailure {
  const factory _InitializationFailed({required final String reason}) =
      _$InitializationFailedImpl;

  String get reason;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializationFailedImplCopyWith<_$InitializationFailedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RequestFailedImplCopyWith<$Res> {
  factory _$$RequestFailedImplCopyWith(
    _$RequestFailedImpl value,
    $Res Function(_$RequestFailedImpl) then,
  ) = __$$RequestFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String method, String? reason});
}

/// @nodoc
class __$$RequestFailedImplCopyWithImpl<$Res>
    extends _$LspFailureCopyWithImpl<$Res, _$RequestFailedImpl>
    implements _$$RequestFailedImplCopyWith<$Res> {
  __$$RequestFailedImplCopyWithImpl(
    _$RequestFailedImpl _value,
    $Res Function(_$RequestFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? method = null, Object? reason = freezed}) {
    return _then(
      _$RequestFailedImpl(
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
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

class _$RequestFailedImpl implements _RequestFailed {
  const _$RequestFailedImpl({required this.method, this.reason});

  @override
  final String method;
  @override
  final String? reason;

  @override
  String toString() {
    return 'LspFailure.requestFailed(method: $method, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestFailedImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, method, reason);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestFailedImplCopyWith<_$RequestFailedImpl> get copyWith =>
      __$$RequestFailedImplCopyWithImpl<_$RequestFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return requestFailed(method, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return requestFailed?.call(method, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (requestFailed != null) {
      return requestFailed(method, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return requestFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return requestFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (requestFailed != null) {
      return requestFailed(this);
    }
    return orElse();
  }
}

abstract class _RequestFailed implements LspFailure {
  const factory _RequestFailed({
    required final String method,
    final String? reason,
  }) = _$RequestFailedImpl;

  String get method;
  String? get reason;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestFailedImplCopyWith<_$RequestFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerNotRespondingImplCopyWith<$Res> {
  factory _$$ServerNotRespondingImplCopyWith(
    _$ServerNotRespondingImpl value,
    $Res Function(_$ServerNotRespondingImpl) then,
  ) = __$$ServerNotRespondingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ServerNotRespondingImplCopyWithImpl<$Res>
    extends _$LspFailureCopyWithImpl<$Res, _$ServerNotRespondingImpl>
    implements _$$ServerNotRespondingImplCopyWith<$Res> {
  __$$ServerNotRespondingImplCopyWithImpl(
    _$ServerNotRespondingImpl _value,
    $Res Function(_$ServerNotRespondingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ServerNotRespondingImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ServerNotRespondingImpl implements _ServerNotResponding {
  const _$ServerNotRespondingImpl({
    this.message = 'LSP server is not responding',
  });

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'LspFailure.serverNotResponding(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerNotRespondingImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerNotRespondingImplCopyWith<_$ServerNotRespondingImpl> get copyWith =>
      __$$ServerNotRespondingImplCopyWithImpl<_$ServerNotRespondingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return serverNotResponding(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return serverNotResponding?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (serverNotResponding != null) {
      return serverNotResponding(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return serverNotResponding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return serverNotResponding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (serverNotResponding != null) {
      return serverNotResponding(this);
    }
    return orElse();
  }
}

abstract class _ServerNotResponding implements LspFailure {
  const factory _ServerNotResponding({final String message}) =
      _$ServerNotRespondingImpl;

  String get message;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerNotRespondingImplCopyWith<_$ServerNotRespondingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnsupportedLanguageImplCopyWith<$Res> {
  factory _$$UnsupportedLanguageImplCopyWith(
    _$UnsupportedLanguageImpl value,
    $Res Function(_$UnsupportedLanguageImpl) then,
  ) = __$$UnsupportedLanguageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String languageId});
}

/// @nodoc
class __$$UnsupportedLanguageImplCopyWithImpl<$Res>
    extends _$LspFailureCopyWithImpl<$Res, _$UnsupportedLanguageImpl>
    implements _$$UnsupportedLanguageImplCopyWith<$Res> {
  __$$UnsupportedLanguageImplCopyWithImpl(
    _$UnsupportedLanguageImpl _value,
    $Res Function(_$UnsupportedLanguageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? languageId = null}) {
    return _then(
      _$UnsupportedLanguageImpl(
        languageId: null == languageId
            ? _value.languageId
            : languageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnsupportedLanguageImpl implements _UnsupportedLanguage {
  const _$UnsupportedLanguageImpl({required this.languageId});

  @override
  final String languageId;

  @override
  String toString() {
    return 'LspFailure.unsupportedLanguage(languageId: $languageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnsupportedLanguageImpl &&
            (identical(other.languageId, languageId) ||
                other.languageId == languageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, languageId);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnsupportedLanguageImplCopyWith<_$UnsupportedLanguageImpl> get copyWith =>
      __$$UnsupportedLanguageImplCopyWithImpl<_$UnsupportedLanguageImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return unsupportedLanguage(languageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return unsupportedLanguage?.call(languageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (unsupportedLanguage != null) {
      return unsupportedLanguage(languageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return unsupportedLanguage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return unsupportedLanguage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (unsupportedLanguage != null) {
      return unsupportedLanguage(this);
    }
    return orElse();
  }
}

abstract class _UnsupportedLanguage implements LspFailure {
  const factory _UnsupportedLanguage({required final String languageId}) =
      _$UnsupportedLanguageImpl;

  String get languageId;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnsupportedLanguageImplCopyWith<_$UnsupportedLanguageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectionFailedImplCopyWith<$Res> {
  factory _$$ConnectionFailedImplCopyWith(
    _$ConnectionFailedImpl value,
    $Res Function(_$ConnectionFailedImpl) then,
  ) = __$$ConnectionFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$ConnectionFailedImplCopyWithImpl<$Res>
    extends _$LspFailureCopyWithImpl<$Res, _$ConnectionFailedImpl>
    implements _$$ConnectionFailedImplCopyWith<$Res> {
  __$$ConnectionFailedImplCopyWithImpl(
    _$ConnectionFailedImpl _value,
    $Res Function(_$ConnectionFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$ConnectionFailedImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ConnectionFailedImpl implements _ConnectionFailed {
  const _$ConnectionFailedImpl({required this.reason});

  @override
  final String reason;

  @override
  String toString() {
    return 'LspFailure.connectionFailed(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionFailedImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionFailedImplCopyWith<_$ConnectionFailedImpl> get copyWith =>
      __$$ConnectionFailedImplCopyWithImpl<_$ConnectionFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return connectionFailed(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return connectionFailed?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
    TResult Function(String message, Object? error)? unexpected,
    required TResult orElse(),
  }) {
    if (connectionFailed != null) {
      return connectionFailed(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return connectionFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return connectionFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (connectionFailed != null) {
      return connectionFailed(this);
    }
    return orElse();
  }
}

abstract class _ConnectionFailed implements LspFailure {
  const factory _ConnectionFailed({required final String reason}) =
      _$ConnectionFailedImpl;

  String get reason;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionFailedImplCopyWith<_$ConnectionFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    extends _$LspFailureCopyWithImpl<$Res, _$UnexpectedImpl>
    implements _$$UnexpectedImplCopyWith<$Res> {
  __$$UnexpectedImplCopyWithImpl(
    _$UnexpectedImpl _value,
    $Res Function(_$UnexpectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LspFailure
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
    return 'LspFailure.unexpected(message: $message, error: $error)';
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

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedImplCopyWith<_$UnexpectedImpl> get copyWith =>
      __$$UnexpectedImplCopyWithImpl<_$UnexpectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) sessionNotFound,
    required TResult Function(String reason) initializationFailed,
    required TResult Function(String method, String? reason) requestFailed,
    required TResult Function(String message) serverNotResponding,
    required TResult Function(String languageId) unsupportedLanguage,
    required TResult Function(String reason) connectionFailed,
    required TResult Function(String message, Object? error) unexpected,
  }) {
    return unexpected(message, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? sessionNotFound,
    TResult? Function(String reason)? initializationFailed,
    TResult? Function(String method, String? reason)? requestFailed,
    TResult? Function(String message)? serverNotResponding,
    TResult? Function(String languageId)? unsupportedLanguage,
    TResult? Function(String reason)? connectionFailed,
    TResult? Function(String message, Object? error)? unexpected,
  }) {
    return unexpected?.call(message, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? sessionNotFound,
    TResult Function(String reason)? initializationFailed,
    TResult Function(String method, String? reason)? requestFailed,
    TResult Function(String message)? serverNotResponding,
    TResult Function(String languageId)? unsupportedLanguage,
    TResult Function(String reason)? connectionFailed,
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
    required TResult Function(_SessionNotFound value) sessionNotFound,
    required TResult Function(_InitializationFailed value) initializationFailed,
    required TResult Function(_RequestFailed value) requestFailed,
    required TResult Function(_ServerNotResponding value) serverNotResponding,
    required TResult Function(_UnsupportedLanguage value) unsupportedLanguage,
    required TResult Function(_ConnectionFailed value) connectionFailed,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SessionNotFound value)? sessionNotFound,
    TResult? Function(_InitializationFailed value)? initializationFailed,
    TResult? Function(_RequestFailed value)? requestFailed,
    TResult? Function(_ServerNotResponding value)? serverNotResponding,
    TResult? Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult? Function(_ConnectionFailed value)? connectionFailed,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SessionNotFound value)? sessionNotFound,
    TResult Function(_InitializationFailed value)? initializationFailed,
    TResult Function(_RequestFailed value)? requestFailed,
    TResult Function(_ServerNotResponding value)? serverNotResponding,
    TResult Function(_UnsupportedLanguage value)? unsupportedLanguage,
    TResult Function(_ConnectionFailed value)? connectionFailed,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class _Unexpected implements LspFailure {
  const factory _Unexpected({
    required final String message,
    final Object? error,
  }) = _$UnexpectedImpl;

  String get message;
  Object? get error;

  /// Create a copy of LspFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnexpectedImplCopyWith<_$UnexpectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
