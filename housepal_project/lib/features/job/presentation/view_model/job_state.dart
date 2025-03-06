part of 'job_bloc.dart';

class JobPostingState extends Equatable {
  final bool isLoading;
  final List<JobPosting>? jobPostings;
  final List<JobPosting>? filteredJobs;
  final String errorMessage; // Changed from String? to String
  final bool isSuccess;

  const JobPostingState({
    this.isLoading = false,
    this.jobPostings,
    this.filteredJobs,
    this.errorMessage = '', // Default to empty string
    this.isSuccess = false,
  });

  factory JobPostingState.initial() => const JobPostingState();

  JobPostingState copyWith({
    bool? isLoading,
    List<JobPosting>? jobPostings,
    List<JobPosting>? filteredJobs,
    String? errorMessage, // Still accept String? in copyWith
    bool? isSuccess,
  }) {
    return JobPostingState(
      isLoading: isLoading ?? this.isLoading,
      jobPostings: jobPostings ?? this.jobPostings,
      filteredJobs: filteredJobs ?? this.filteredJobs,
      errorMessage: errorMessage ?? this.errorMessage, // Use ?? to keep default
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, jobPostings, filteredJobs, errorMessage, isSuccess];
}
