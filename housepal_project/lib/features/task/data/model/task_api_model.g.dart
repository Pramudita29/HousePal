// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskApiModel _$TaskApiModelFromJson(Map<String, dynamic> json) => TaskApiModel(
      id: json['_id'] as String?,
      jobId: json['jobId'],
      seekerEmail: json['seekerEmail'] as String,
      helperDetails: json['helperDetails'] as Map<String, dynamic>,
      scheduledTime: json['scheduledTime'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$TaskApiModelToJson(TaskApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'jobId': instance.jobId,
      'seekerEmail': instance.seekerEmail,
      'helperDetails': instance.helperDetails,
      'scheduledTime': instance.scheduledTime,
      'status': instance.status,
    };
