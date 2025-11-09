// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'json_rpc_protocol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JsonRpcRequest _$JsonRpcRequestFromJson(Map<String, dynamic> json) {
  return _JsonRpcRequest.fromJson(json);
}

/// @nodoc
mixin _$JsonRpcRequest {
  String get jsonrpc => throw _privateConstructorUsedError;
  dynamic get id => throw _privateConstructorUsedError; // String or int
  String get method => throw _privateConstructorUsedError;
  Map<String, dynamic>? get params => throw _privateConstructorUsedError;

  /// Serializes this JsonRpcRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JsonRpcRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JsonRpcRequestCopyWith<JsonRpcRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsonRpcRequestCopyWith<$Res> {
  factory $JsonRpcRequestCopyWith(
    JsonRpcRequest value,
    $Res Function(JsonRpcRequest) then,
  ) = _$JsonRpcRequestCopyWithImpl<$Res, JsonRpcRequest>;
  @useResult
  $Res call({
    String jsonrpc,
    dynamic id,
    String method,
    Map<String, dynamic>? params,
  });
}

/// @nodoc
class _$JsonRpcRequestCopyWithImpl<$Res, $Val extends JsonRpcRequest>
    implements $JsonRpcRequestCopyWith<$Res> {
  _$JsonRpcRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JsonRpcRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jsonrpc = null,
    Object? id = freezed,
    Object? method = null,
    Object? params = freezed,
  }) {
    return _then(
      _value.copyWith(
            jsonrpc: null == jsonrpc
                ? _value.jsonrpc
                : jsonrpc // ignore: cast_nullable_to_non_nullable
                      as String,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            params: freezed == params
                ? _value.params
                : params // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JsonRpcRequestImplCopyWith<$Res>
    implements $JsonRpcRequestCopyWith<$Res> {
  factory _$$JsonRpcRequestImplCopyWith(
    _$JsonRpcRequestImpl value,
    $Res Function(_$JsonRpcRequestImpl) then,
  ) = __$$JsonRpcRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String jsonrpc,
    dynamic id,
    String method,
    Map<String, dynamic>? params,
  });
}

/// @nodoc
class __$$JsonRpcRequestImplCopyWithImpl<$Res>
    extends _$JsonRpcRequestCopyWithImpl<$Res, _$JsonRpcRequestImpl>
    implements _$$JsonRpcRequestImplCopyWith<$Res> {
  __$$JsonRpcRequestImplCopyWithImpl(
    _$JsonRpcRequestImpl _value,
    $Res Function(_$JsonRpcRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsonRpcRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jsonrpc = null,
    Object? id = freezed,
    Object? method = null,
    Object? params = freezed,
  }) {
    return _then(
      _$JsonRpcRequestImpl(
        jsonrpc: null == jsonrpc
            ? _value.jsonrpc
            : jsonrpc // ignore: cast_nullable_to_non_nullable
                  as String,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        params: freezed == params
            ? _value._params
            : params // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JsonRpcRequestImpl implements _JsonRpcRequest {
  const _$JsonRpcRequestImpl({
    this.jsonrpc = '2.0',
    required this.id,
    required this.method,
    final Map<String, dynamic>? params,
  }) : _params = params;

  factory _$JsonRpcRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$JsonRpcRequestImplFromJson(json);

  @override
  @JsonKey()
  final String jsonrpc;
  @override
  final dynamic id;
  // String or int
  @override
  final String method;
  final Map<String, dynamic>? _params;
  @override
  Map<String, dynamic>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableMapView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'JsonRpcRequest(jsonrpc: $jsonrpc, id: $id, method: $method, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsonRpcRequestImpl &&
            (identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality().equals(other._params, _params));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    jsonrpc,
    const DeepCollectionEquality().hash(id),
    method,
    const DeepCollectionEquality().hash(_params),
  );

  /// Create a copy of JsonRpcRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsonRpcRequestImplCopyWith<_$JsonRpcRequestImpl> get copyWith =>
      __$$JsonRpcRequestImplCopyWithImpl<_$JsonRpcRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JsonRpcRequestImplToJson(this);
  }
}

abstract class _JsonRpcRequest implements JsonRpcRequest {
  const factory _JsonRpcRequest({
    final String jsonrpc,
    required final dynamic id,
    required final String method,
    final Map<String, dynamic>? params,
  }) = _$JsonRpcRequestImpl;

  factory _JsonRpcRequest.fromJson(Map<String, dynamic> json) =
      _$JsonRpcRequestImpl.fromJson;

  @override
  String get jsonrpc;
  @override
  dynamic get id; // String or int
  @override
  String get method;
  @override
  Map<String, dynamic>? get params;

  /// Create a copy of JsonRpcRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsonRpcRequestImplCopyWith<_$JsonRpcRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JsonRpcResponse _$JsonRpcResponseFromJson(Map<String, dynamic> json) {
  return _JsonRpcResponse.fromJson(json);
}

/// @nodoc
mixin _$JsonRpcResponse {
  String get jsonrpc => throw _privateConstructorUsedError;
  dynamic get id => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;
  JsonRpcError? get error => throw _privateConstructorUsedError;

  /// Serializes this JsonRpcResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JsonRpcResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JsonRpcResponseCopyWith<JsonRpcResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsonRpcResponseCopyWith<$Res> {
  factory $JsonRpcResponseCopyWith(
    JsonRpcResponse value,
    $Res Function(JsonRpcResponse) then,
  ) = _$JsonRpcResponseCopyWithImpl<$Res, JsonRpcResponse>;
  @useResult
  $Res call({
    String jsonrpc,
    dynamic id,
    Map<String, dynamic>? result,
    JsonRpcError? error,
  });

  $JsonRpcErrorCopyWith<$Res>? get error;
}

/// @nodoc
class _$JsonRpcResponseCopyWithImpl<$Res, $Val extends JsonRpcResponse>
    implements $JsonRpcResponseCopyWith<$Res> {
  _$JsonRpcResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JsonRpcResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jsonrpc = null,
    Object? id = freezed,
    Object? result = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            jsonrpc: null == jsonrpc
                ? _value.jsonrpc
                : jsonrpc // ignore: cast_nullable_to_non_nullable
                      as String,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as JsonRpcError?,
          )
          as $Val,
    );
  }

  /// Create a copy of JsonRpcResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JsonRpcErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $JsonRpcErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JsonRpcResponseImplCopyWith<$Res>
    implements $JsonRpcResponseCopyWith<$Res> {
  factory _$$JsonRpcResponseImplCopyWith(
    _$JsonRpcResponseImpl value,
    $Res Function(_$JsonRpcResponseImpl) then,
  ) = __$$JsonRpcResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String jsonrpc,
    dynamic id,
    Map<String, dynamic>? result,
    JsonRpcError? error,
  });

  @override
  $JsonRpcErrorCopyWith<$Res>? get error;
}

/// @nodoc
class __$$JsonRpcResponseImplCopyWithImpl<$Res>
    extends _$JsonRpcResponseCopyWithImpl<$Res, _$JsonRpcResponseImpl>
    implements _$$JsonRpcResponseImplCopyWith<$Res> {
  __$$JsonRpcResponseImplCopyWithImpl(
    _$JsonRpcResponseImpl _value,
    $Res Function(_$JsonRpcResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsonRpcResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jsonrpc = null,
    Object? id = freezed,
    Object? result = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$JsonRpcResponseImpl(
        jsonrpc: null == jsonrpc
            ? _value.jsonrpc
            : jsonrpc // ignore: cast_nullable_to_non_nullable
                  as String,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        result: freezed == result
            ? _value._result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as JsonRpcError?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JsonRpcResponseImpl extends _JsonRpcResponse {
  const _$JsonRpcResponseImpl({
    this.jsonrpc = '2.0',
    required this.id,
    final Map<String, dynamic>? result,
    this.error,
  }) : _result = result,
       super._();

  factory _$JsonRpcResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$JsonRpcResponseImplFromJson(json);

  @override
  @JsonKey()
  final String jsonrpc;
  @override
  final dynamic id;
  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final JsonRpcError? error;

  @override
  String toString() {
    return 'JsonRpcResponse(jsonrpc: $jsonrpc, id: $id, result: $result, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsonRpcResponseImpl &&
            (identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    jsonrpc,
    const DeepCollectionEquality().hash(id),
    const DeepCollectionEquality().hash(_result),
    error,
  );

  /// Create a copy of JsonRpcResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsonRpcResponseImplCopyWith<_$JsonRpcResponseImpl> get copyWith =>
      __$$JsonRpcResponseImplCopyWithImpl<_$JsonRpcResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JsonRpcResponseImplToJson(this);
  }
}

abstract class _JsonRpcResponse extends JsonRpcResponse {
  const factory _JsonRpcResponse({
    final String jsonrpc,
    required final dynamic id,
    final Map<String, dynamic>? result,
    final JsonRpcError? error,
  }) = _$JsonRpcResponseImpl;
  const _JsonRpcResponse._() : super._();

  factory _JsonRpcResponse.fromJson(Map<String, dynamic> json) =
      _$JsonRpcResponseImpl.fromJson;

  @override
  String get jsonrpc;
  @override
  dynamic get id;
  @override
  Map<String, dynamic>? get result;
  @override
  JsonRpcError? get error;

  /// Create a copy of JsonRpcResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsonRpcResponseImplCopyWith<_$JsonRpcResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JsonRpcError _$JsonRpcErrorFromJson(Map<String, dynamic> json) {
  return _JsonRpcError.fromJson(json);
}

/// @nodoc
mixin _$JsonRpcError {
  int get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;

  /// Serializes this JsonRpcError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JsonRpcError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JsonRpcErrorCopyWith<JsonRpcError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsonRpcErrorCopyWith<$Res> {
  factory $JsonRpcErrorCopyWith(
    JsonRpcError value,
    $Res Function(JsonRpcError) then,
  ) = _$JsonRpcErrorCopyWithImpl<$Res, JsonRpcError>;
  @useResult
  $Res call({int code, String message, dynamic data});
}

/// @nodoc
class _$JsonRpcErrorCopyWithImpl<$Res, $Val extends JsonRpcError>
    implements $JsonRpcErrorCopyWith<$Res> {
  _$JsonRpcErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JsonRpcError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as int,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JsonRpcErrorImplCopyWith<$Res>
    implements $JsonRpcErrorCopyWith<$Res> {
  factory _$$JsonRpcErrorImplCopyWith(
    _$JsonRpcErrorImpl value,
    $Res Function(_$JsonRpcErrorImpl) then,
  ) = __$$JsonRpcErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int code, String message, dynamic data});
}

/// @nodoc
class __$$JsonRpcErrorImplCopyWithImpl<$Res>
    extends _$JsonRpcErrorCopyWithImpl<$Res, _$JsonRpcErrorImpl>
    implements _$$JsonRpcErrorImplCopyWith<$Res> {
  __$$JsonRpcErrorImplCopyWithImpl(
    _$JsonRpcErrorImpl _value,
    $Res Function(_$JsonRpcErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsonRpcError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(
      _$JsonRpcErrorImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JsonRpcErrorImpl implements _JsonRpcError {
  const _$JsonRpcErrorImpl({
    required this.code,
    required this.message,
    this.data,
  });

  factory _$JsonRpcErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$JsonRpcErrorImplFromJson(json);

  @override
  final int code;
  @override
  final String message;
  @override
  final dynamic data;

  @override
  String toString() {
    return 'JsonRpcError(code: $code, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsonRpcErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    message,
    const DeepCollectionEquality().hash(data),
  );

  /// Create a copy of JsonRpcError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsonRpcErrorImplCopyWith<_$JsonRpcErrorImpl> get copyWith =>
      __$$JsonRpcErrorImplCopyWithImpl<_$JsonRpcErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JsonRpcErrorImplToJson(this);
  }
}

abstract class _JsonRpcError implements JsonRpcError {
  const factory _JsonRpcError({
    required final int code,
    required final String message,
    final dynamic data,
  }) = _$JsonRpcErrorImpl;

  factory _JsonRpcError.fromJson(Map<String, dynamic> json) =
      _$JsonRpcErrorImpl.fromJson;

  @override
  int get code;
  @override
  String get message;
  @override
  dynamic get data;

  /// Create a copy of JsonRpcError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsonRpcErrorImplCopyWith<_$JsonRpcErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JsonRpcNotification _$JsonRpcNotificationFromJson(Map<String, dynamic> json) {
  return _JsonRpcNotification.fromJson(json);
}

/// @nodoc
mixin _$JsonRpcNotification {
  String get jsonrpc => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  Map<String, dynamic>? get params => throw _privateConstructorUsedError;

  /// Serializes this JsonRpcNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JsonRpcNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JsonRpcNotificationCopyWith<JsonRpcNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsonRpcNotificationCopyWith<$Res> {
  factory $JsonRpcNotificationCopyWith(
    JsonRpcNotification value,
    $Res Function(JsonRpcNotification) then,
  ) = _$JsonRpcNotificationCopyWithImpl<$Res, JsonRpcNotification>;
  @useResult
  $Res call({String jsonrpc, String method, Map<String, dynamic>? params});
}

/// @nodoc
class _$JsonRpcNotificationCopyWithImpl<$Res, $Val extends JsonRpcNotification>
    implements $JsonRpcNotificationCopyWith<$Res> {
  _$JsonRpcNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JsonRpcNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jsonrpc = null,
    Object? method = null,
    Object? params = freezed,
  }) {
    return _then(
      _value.copyWith(
            jsonrpc: null == jsonrpc
                ? _value.jsonrpc
                : jsonrpc // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            params: freezed == params
                ? _value.params
                : params // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JsonRpcNotificationImplCopyWith<$Res>
    implements $JsonRpcNotificationCopyWith<$Res> {
  factory _$$JsonRpcNotificationImplCopyWith(
    _$JsonRpcNotificationImpl value,
    $Res Function(_$JsonRpcNotificationImpl) then,
  ) = __$$JsonRpcNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String jsonrpc, String method, Map<String, dynamic>? params});
}

/// @nodoc
class __$$JsonRpcNotificationImplCopyWithImpl<$Res>
    extends _$JsonRpcNotificationCopyWithImpl<$Res, _$JsonRpcNotificationImpl>
    implements _$$JsonRpcNotificationImplCopyWith<$Res> {
  __$$JsonRpcNotificationImplCopyWithImpl(
    _$JsonRpcNotificationImpl _value,
    $Res Function(_$JsonRpcNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsonRpcNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jsonrpc = null,
    Object? method = null,
    Object? params = freezed,
  }) {
    return _then(
      _$JsonRpcNotificationImpl(
        jsonrpc: null == jsonrpc
            ? _value.jsonrpc
            : jsonrpc // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        params: freezed == params
            ? _value._params
            : params // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JsonRpcNotificationImpl implements _JsonRpcNotification {
  const _$JsonRpcNotificationImpl({
    this.jsonrpc = '2.0',
    required this.method,
    final Map<String, dynamic>? params,
  }) : _params = params;

  factory _$JsonRpcNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$JsonRpcNotificationImplFromJson(json);

  @override
  @JsonKey()
  final String jsonrpc;
  @override
  final String method;
  final Map<String, dynamic>? _params;
  @override
  Map<String, dynamic>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableMapView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'JsonRpcNotification(jsonrpc: $jsonrpc, method: $method, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsonRpcNotificationImpl &&
            (identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc) &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality().equals(other._params, _params));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    jsonrpc,
    method,
    const DeepCollectionEquality().hash(_params),
  );

  /// Create a copy of JsonRpcNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsonRpcNotificationImplCopyWith<_$JsonRpcNotificationImpl> get copyWith =>
      __$$JsonRpcNotificationImplCopyWithImpl<_$JsonRpcNotificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JsonRpcNotificationImplToJson(this);
  }
}

abstract class _JsonRpcNotification implements JsonRpcNotification {
  const factory _JsonRpcNotification({
    final String jsonrpc,
    required final String method,
    final Map<String, dynamic>? params,
  }) = _$JsonRpcNotificationImpl;

  factory _JsonRpcNotification.fromJson(Map<String, dynamic> json) =
      _$JsonRpcNotificationImpl.fromJson;

  @override
  String get jsonrpc;
  @override
  String get method;
  @override
  Map<String, dynamic>? get params;

  /// Create a copy of JsonRpcNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsonRpcNotificationImplCopyWith<_$JsonRpcNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
