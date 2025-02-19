// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_posting_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobPostingApiModel _$JobPostingApiModelFromJson(Map<String, dynamic> json) =>
    JobPostingApiModel(
      id: json['_id'] as String?, // Already nullable
      jobTitle: json['jobTitle'] as String? ?? '', // Provide default value
      jobDescription: json['jobDescription'] as String? ?? '',
      datePosted: json['datePosted'] != null
          ? DateTime.parse(json['datePosted'] as String)
          : DateTime.now(), // Default value to prevent parsing error
      status: json['status'] as String? ?? 'pending', // Example default
      category: json['category'] as String? ?? '',
      subCategory: json['subCategory'] as String?,
      location: json['location'] as String?,
      salaryRange: json['salaryRange'] as String? ?? 'Negotiable',
      contractType: json['contractType'] as String? ?? '',
      applicationDeadline: json['applicationDeadline'] != null
          ? DateTime.parse(json['applicationDeadline'] as String)
          : DateTime.now(),
      contactInfo: json['contactInfo'] as String?,
      posterFullName: json['posterFullName'] as String?,
      posterEmail: json['posterEmail'] as String?,
      posterImage: json['posterImage'] as String?,
    );

Map<String, dynamic> _$JobPostingApiModelToJson(JobPostingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'jobTitle': instance.jobTitle,
      'jobDescription': instance.jobDescription,
      'datePosted': instance.datePosted.toIso8601String(),
      'status': instance.status,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'location': instance.location,
      'salaryRange': instance.salaryRange,
      'contractType': instance.contractType,
      'applicationDeadline': instance.applicationDeadline.toIso8601String(),
      'contactInfo': instance.contactInfo,
      'posterFullName': instance.posterFullName,
      'posterEmail': instance.posterEmail,
      'posterImage': instance.posterImage,
    };
