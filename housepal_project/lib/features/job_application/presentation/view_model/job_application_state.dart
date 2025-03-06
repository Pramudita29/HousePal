part of 'job_application_bloc.dart';

class JobApplicationState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final List<JobApplication>? jobApplications;
  final AuthEntity? helperDetails;
  final String? appliedJobId;

  const JobApplicationState({
    required this.isLoading,
    required this.isSuccess,
    required this.errorMessage,
    this.jobApplications,
    this.helperDetails,
    this.appliedJobId,
  });

  factory JobApplicationState.initial() => const JobApplicationState(
        isLoading: false,
        isSuccess: false,
        errorMessage: '',
        jobApplications: null,
        helperDetails: null,
        appliedJobId: null,
      );

  JobApplicationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<JobApplication>? jobApplications,
    AuthEntity? helperDetails,
    String? appliedJobId,
  }) {
    return JobApplicationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      jobApplications: jobApplications ?? this.jobApplications,
      helperDetails: helperDetails ?? this.helperDetails,
      appliedJobId: appliedJobId ?? this.appliedJobId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        errorMessage,
        jobApplications,
        helperDetails,
        appliedJobId
      ];
}
