// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_save_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AutoSaveConfig _$AutoSaveConfigFromJson(Map<String, dynamic> json) =>
    _AutoSaveConfig(
      enabled: json['enabled'] as bool,
      interval: SaveInterval.fromJson(json['interval'] as Map<String, dynamic>),
      onlyWhenIdle: json['onlyWhenIdle'] as bool? ?? false,
      showNotifications: json['showNotifications'] as bool? ?? true,
    );

Map<String, dynamic> _$AutoSaveConfigToJson(_AutoSaveConfig instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'interval': instance.interval,
      'onlyWhenIdle': instance.onlyWhenIdle,
      'showNotifications': instance.showNotifications,
    };
