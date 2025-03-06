part of 'job_application_bloc.dart';

abstract class JobApplicationEvent extends Equatable {
  const JobApplicationEvent();

  @override
  List<Object?> get props => [];
}

class FetchCurrentUserEvent extends JobApplicationEvent {
  const FetchCurrentUserEvent();
}

class ApplyForJobEvent extends JobApplicationEvent {
  final String jobId;

  const ApplyForJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class GetApplicationsForJobEvent extends JobApplicationEvent {
  final String jobId;

  const GetApplicationsForJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class UpdateApplicationStatusEvent extends JobApplicationEvent {
  final String applicationId;
  final String status;
  final String jobId;

  const UpdateApplicationStatusEvent({
    required this.applicationId,
    required this.status,
    required this.jobId,
  });

  @override
  List<Object?> get props => [applicationId, status, jobId];
}

class FetchAllSeekerApplicationsEvent extends JobApplicationEvent {
  const FetchAllSeekerApplicationsEvent();
}

