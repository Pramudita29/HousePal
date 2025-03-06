part of 'job_bloc.dart';

abstract class JobPostingEvent extends Equatable {
  const JobPostingEvent();
  @override
  List<Object?> get props => [];
}

class CreateJobPostingEvent extends JobPostingEvent {
  final JobPosting jobPosting;
  const CreateJobPostingEvent(this.jobPosting);
  @override
  List<Object?> get props => [jobPosting];
}

class FilterJobsEvent extends JobPostingEvent {
  final String? contractType;
  final String? category;
  final String? location;
  final String? salaryRange;
  const FilterJobsEvent(
      {this.contractType, this.category, this.location, this.salaryRange});
  @override
  List<Object?> get props => [contractType, category, location, salaryRange];
}

class GetAllJobsEvent extends JobPostingEvent {
  const GetAllJobsEvent();
}

class UpdateJobEvent extends JobPostingEvent {
  final String jobId;
  final JobPosting jobPosting;
  const UpdateJobEvent(this.jobId, this.jobPosting);
  @override
  List<Object?> get props => [jobId, jobPosting];
}

class DeleteJobEvent extends JobPostingEvent {
  final String jobId;
  const DeleteJobEvent(this.jobId);
  @override
  List<Object?> get props => [jobId];
}
