// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobApplicationApiModel _$JobApplicationApiModelFromJson(
        Map<String, dynamic> json) =>
    JobApplicationApiModel(
      applicationId: json['_id'] as String?,
      jobId: json['jobId'],
      applicantDetails:
          AuthApiModel.fromJson(json['helperDetails'] as Map<String, dynamic>),
      status: json['status'] as String,
    );

Map<String, dynamic> _$JobApplicationApiModelToJson(
        JobApplicationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.applicationId,
      'jobId': instance.jobId,
      'helperDetails': instance.applicantDetails,
      'status': instance.status,
    };
