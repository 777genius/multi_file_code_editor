// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaveTask _$SaveTaskFromJson(Map<String, dynamic> json) => _SaveTask(
  fileId: json['fileId'] as String,
  content: json['content'] as String,
  scheduledAt: DateTime.parse(json['scheduledAt'] as String),
  completed: json['completed'] as bool? ?? false,
  failed: json['failed'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$SaveTaskToJson(_SaveTask instance) => <String, dynamic>{
  'fileId': instance.fileId,
  'content': instance.content,
  'scheduledAt': instance.scheduledAt.toIso8601String(),
  'completed': instance.completed,
  'failed': instance.failed,
  'errorMessage': instance.errorMessage,
};
