// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileDocument _$FileDocumentFromJson(Map<String, dynamic> json) =>
    _FileDocument(
      id: json['id'] as String,
      name: json['name'] as String,
      folderId: json['folderId'] as String,
      content: json['content'] as String,
      language: json['language'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FileDocumentToJson(_FileDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'folderId': instance.folderId,
      'content': instance.content,
      'language': instance.language,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };
