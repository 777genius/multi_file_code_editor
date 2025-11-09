// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_tree_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileTreeNode _$FileTreeNodeFromJson(Map<String, dynamic> json) =>
    _FileTreeNode(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$FileTreeNodeTypeEnumMap, json['type']),
      parentId: json['parentId'] as String?,
      language: json['language'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => FileTreeNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isExpanded: json['isExpanded'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$FileTreeNodeToJson(_FileTreeNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$FileTreeNodeTypeEnumMap[instance.type]!,
      'parentId': instance.parentId,
      'language': instance.language,
      'children': instance.children,
      'isExpanded': instance.isExpanded,
      'metadata': instance.metadata,
    };

const _$FileTreeNodeTypeEnumMap = {
  FileTreeNodeType.file: 'file',
  FileTreeNodeType.folder: 'folder',
};
