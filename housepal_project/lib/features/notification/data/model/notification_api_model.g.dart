// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
        Map<String, dynamic> json) =>
    NotificationApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      jobId: json['jobId'] as String,
    );

Map<String, dynamic> _$NotificationApiModelToJson(
        NotificationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'isRead': instance.isRead,
      'jobId': instance.jobId,
    };
