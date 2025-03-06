import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';

class JobApplication extends Equatable {
  final String? applicationId;
  final String jobId;
  final String? jobTitle;
  final AuthEntity applicantDetails;
  final String status;

  const JobApplication({
    this.applicationId,
    required this.jobId,
    this.jobTitle,
    required this.applicantDetails,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [applicationId, jobId, jobTitle, applicantDetails, status];

  @override
  String toString() =>
      'JobApplication($applicationId, $jobId, $jobTitle, $applicantDetails, $status)';
}
