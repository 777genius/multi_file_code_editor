// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_rpc_protocol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JsonRpcRequestImpl _$$JsonRpcRequestImplFromJson(Map<String, dynamic> json) =>
    _$JsonRpcRequestImpl(
      jsonrpc: json['jsonrpc'] as String? ?? '2.0',
      id: json['id'],
      method: json['method'] as String,
      params: json['params'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$JsonRpcRequestImplToJson(
  _$JsonRpcRequestImpl instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'method': instance.method,
  'params': instance.params,
};

_$JsonRpcResponseImpl _$$JsonRpcResponseImplFromJson(
  Map<String, dynamic> json,
) => _$JsonRpcResponseImpl(
  jsonrpc: json['jsonrpc'] as String? ?? '2.0',
  id: json['id'],
  result: json['result'] as Map<String, dynamic>?,
  error: json['error'] == null
      ? null
      : JsonRpcError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$JsonRpcResponseImplToJson(
  _$JsonRpcResponseImpl instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
  'error': instance.error,
};

_$JsonRpcErrorImpl _$$JsonRpcErrorImplFromJson(Map<String, dynamic> json) =>
    _$JsonRpcErrorImpl(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$$JsonRpcErrorImplToJson(_$JsonRpcErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

_$JsonRpcNotificationImpl _$$JsonRpcNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$JsonRpcNotificationImpl(
  jsonrpc: json['jsonrpc'] as String? ?? '2.0',
  method: json['method'] as String,
  params: json['params'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$JsonRpcNotificationImplToJson(
  _$JsonRpcNotificationImpl instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params,
};
