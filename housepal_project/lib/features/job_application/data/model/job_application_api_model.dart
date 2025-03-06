import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/auth/data/model/auth_api_model.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_application_api_model.g.dart';

@JsonSerializable()
class JobApplicationApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? applicationId;
  final dynamic jobId; // Changed to dynamic to handle String or Map
  @JsonKey(name: 'helperDetails')
  final AuthApiModel applicantDetails;
  final String status;

  const JobApplicationApiModel({
    this.applicationId,
    required this.jobId,
    required this.applicantDetails,
    required this.status,
  });

  factory JobApplicationApiModel.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobApplicationApiModelToJson(this);

  JobApplication toEntity() {
    // Extract jobId as a String, handling both direct String and populated Map
    final jobIdString = jobId is Map ? jobId['_id'] as String : jobId as String;
    // Extract jobTitle if jobId is a Map
    final jobTitle = jobId is Map ? jobId['jobTitle'] as String? : null;
    return JobApplication(
      applicationId: applicationId,
      jobId: jobIdString,
      jobTitle: jobTitle, // Now includes jobTitle
      applicantDetails: applicantDetails.toEntity(),
      status: status,
    );
  }

  static JobApplicationApiModel fromEntity(JobApplication entity) =>
      JobApplicationApiModel(
        applicationId: entity.applicationId,
        jobId: entity.jobId, // Entity jobId is String, so no conversion needed
        applicantDetails: AuthApiModel.fromEntity(entity.applicantDetails),
        status: entity.status,
      );

  @override
  List<Object?> get props => [applicationId, jobId, applicantDetails, status];
}