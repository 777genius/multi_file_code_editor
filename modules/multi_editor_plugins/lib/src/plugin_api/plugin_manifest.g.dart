// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PluginManifest _$PluginManifestFromJson(Map<String, dynamic> json) =>
    _PluginManifest(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String?,
      author: json['author'] as String?,
      dependencies:
          (json['dependencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      capabilities:
          (json['capabilities'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      activationEvents:
          (json['activationEvents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$PluginManifestToJson(_PluginManifest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'version': instance.version,
      'description': instance.description,
      'author': instance.author,
      'dependencies': instance.dependencies,
      'capabilities': instance.capabilities,
      'activationEvents': instance.activationEvents,
      'metadata': instance.metadata,
    };
