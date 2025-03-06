import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/usecases/create_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/delete_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/filter_jobs_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/get_all_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/update_job_usecase.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobPostingBloc extends Bloc<JobPostingEvent, JobPostingState> {
  final CreateJobPostingUseCase createJobPostingUseCase;
  final FilterJobsUseCase filterJobsUseCase;
  final GetAllJobUseCase getAllJobUseCase;
  final UpdateJobUseCase updateJobUseCase;
  final DeleteJobUseCase deleteJobUseCase;

  JobPostingBloc({
    required this.createJobPostingUseCase,
    required this.filterJobsUseCase,
    required this.getAllJobUseCase,
    required this.updateJobUseCase,
    required this.deleteJobUseCase,
  }) : super(JobPostingState.initial()) {
    on<CreateJobPostingEvent>(_onCreateJobPostingEvent);
    on<FilterJobsEvent>(_onFilterJobsEvent);
    on<GetAllJobsEvent>(_onGetAllJobsEvent);
    on<UpdateJobEvent>(_onUpdateJobEvent);
    on<DeleteJobEvent>(_onDeleteJobEvent);
  }

  Future<void> _onCreateJobPostingEvent(
      CreateJobPostingEvent event, Emitter<JobPostingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await createJobPostingUseCase(event.jobPosting);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (jobPosting) => emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          jobPostings: [...state.jobPostings ?? [], jobPosting])),
    );
  }

  Future<void> _onFilterJobsEvent(
      FilterJobsEvent event, Emitter<JobPostingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final allJobs = state.jobPostings ?? [];
    if (allJobs.isEmpty) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'No jobs available to filter'));
      return;
    }

    // Local filtering logic
    final filteredJobs = allJobs.where((job) {
      final matchesContractType = event.contractType == null ||
          event.contractType!.isEmpty ||
          job.contractType.toLowerCase() == event.contractType!.toLowerCase();
      final matchesCategory = event.category == null ||
          event.category!.isEmpty ||
          job.category.toLowerCase() == event.category!.toLowerCase();
      final matchesLocation = event.location == null ||
          event.location!.isEmpty ||
          job.location.toLowerCase() == event.location!.toLowerCase();
      final matchesSalaryRange = event.salaryRange == null ||
          event.salaryRange!.isEmpty ||
          job.salaryRange.toLowerCase() == event.salaryRange!.toLowerCase();

      return matchesContractType &&
          matchesCategory &&
          matchesLocation &&
          matchesSalaryRange;
    }).toList();

    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
      filteredJobs: filteredJobs.isEmpty ? null : filteredJobs,
    ));
  }

  Future<void> _onGetAllJobsEvent(
      GetAllJobsEvent event, Emitter<JobPostingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllJobUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
          isLoading: false, isSuccess: false, errorMessage: failure.message)),
      (jobPostings) => emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          jobPostings: jobPostings,
          filteredJobs: null)), // Reset filteredJobs on fetch
    );
  }

  Future<void> _onUpdateJobEvent(
      UpdateJobEvent event, Emitter<JobPostingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await updateJobUseCase(event.jobId, event.jobPosting);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (jobPosting) => emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        jobPostings: state.jobPostings
            ?.map((job) => job.jobId == jobPosting.jobId ? jobPosting : job)
            .toList(),
      )),
    );
  }

  Future<void> _onDeleteJobEvent(
      DeleteJobEvent event, Emitter<JobPostingState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await deleteJobUseCase(event.jobId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          jobPostings: state.jobPostings
              ?.where((job) => job.jobId != event.jobId)
              .toList())),
    );
  }
}
