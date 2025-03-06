// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_posting_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobPostingApiModel _$JobPostingApiModelFromJson(Map<String, dynamic> json) =>
    JobPostingApiModel(
      id: json['_id'] as String?,
      posterEmail: json['posterEmail'] as String?,
      jobTitle: json['jobTitle'] as String,
      jobDescription: json['jobDescription'] as String,
      datePosted: json['datePosted'] == null
          ? null
          : DateTime.parse(json['datePosted'] as String),
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      location: json['location'] as String?,
      salaryRange: json['salaryRange'] as String,
      contractType: json['contractType'] as String,
      applicationDeadline: json['applicationDeadline'] == null
          ? null
          : DateTime.parse(json['applicationDeadline'] as String),
      contactInfo: json['contactInfo'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$JobPostingApiModelToJson(JobPostingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'posterEmail': instance.posterEmail,
      'jobTitle': instance.jobTitle,
      'jobDescription': instance.jobDescription,
      'datePosted': instance.datePosted?.toIso8601String(),
      'category': instance.category,
      'subCategory': instance.subCategory,
      'location': instance.location,
      'salaryRange': instance.salaryRange,
      'contractType': instance.contractType,
      'applicationDeadline': instance.applicationDeadline?.toIso8601String(),
      'contactInfo': instance.contactInfo,
      'status': instance.status,
    };
