// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PluginError _$PluginErrorFromJson(Map<String, dynamic> json) => _PluginError(
  pluginId: json['pluginId'] as String,
  pluginName: json['pluginName'] as String,
  type: $enumDecode(_$PluginErrorTypeEnumMap, json['type']),
  message: json['message'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  context: json['context'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$PluginErrorToJson(_PluginError instance) =>
    <String, dynamic>{
      'pluginId': instance.pluginId,
      'pluginName': instance.pluginName,
      'type': _$PluginErrorTypeEnumMap[instance.type]!,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'context': instance.context,
    };

const _$PluginErrorTypeEnumMap = {
  PluginErrorType.initialization: 'initialization',
  PluginErrorType.disposal: 'disposal',
  PluginErrorType.eventHandler: 'eventHandler',
  PluginErrorType.dependency: 'dependency',
  PluginErrorType.configuration: 'configuration',
  PluginErrorType.messaging: 'messaging',
  PluginErrorType.runtime: 'runtime',
};
