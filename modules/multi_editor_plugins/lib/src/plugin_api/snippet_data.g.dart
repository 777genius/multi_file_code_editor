// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snippet_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SnippetData _$SnippetDataFromJson(Map<String, dynamic> json) => _SnippetData(
  prefix: json['prefix'] as String,
  label: json['label'] as String,
  body: json['body'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$SnippetDataToJson(_SnippetData instance) =>
    <String, dynamic>{
      'prefix': instance.prefix,
      'label': instance.label,
      'body': instance.body,
      'description': instance.description,
    };
