// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PluginConfiguration _$PluginConfigurationFromJson(Map<String, dynamic> json) =>
    _PluginConfiguration(
      pluginId: PluginId.fromJson(json['pluginId'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$PluginConfigurationToJson(
  _PluginConfiguration instance,
) => <String, dynamic>{
  'pluginId': instance.pluginId,
  'enabled': instance.enabled,
  'settings': instance.settings,
  'lastModified': instance.lastModified?.toIso8601String(),
};
