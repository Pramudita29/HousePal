import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/usecases/create_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/delete_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/filter_jobs_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/get_all_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/update_job_usecase.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateJobUseCase extends Mock implements CreateJobPostingUseCase {}

class MockFilterJobsUseCase extends Mock implements FilterJobsUseCase {}

class MockGetAllJobUseCase extends Mock implements GetAllJobUseCase {}

class MockUpdateJobUseCase extends Mock implements UpdateJobUseCase {}

class MockDeleteJobUseCase extends Mock implements DeleteJobUseCase {}

void main() {
  late JobPostingBloc jobPostingBloc;
  late MockCreateJobUseCase mockCreateJobUseCase;
  late MockFilterJobsUseCase mockFilterJobsUseCase;
  late MockGetAllJobUseCase mockGetAllJobUseCase;
  late MockUpdateJobUseCase mockUpdateJobUseCase;
  late MockDeleteJobUseCase mockDeleteJobUseCase;

  setUp(() {
    mockCreateJobUseCase = MockCreateJobUseCase();
    mockFilterJobsUseCase = MockFilterJobsUseCase();
    mockGetAllJobUseCase = MockGetAllJobUseCase();
    mockUpdateJobUseCase = MockUpdateJobUseCase();
    mockDeleteJobUseCase = MockDeleteJobUseCase();
    jobPostingBloc = JobPostingBloc(
      createJobPostingUseCase: mockCreateJobUseCase,
      filterJobsUseCase: mockFilterJobsUseCase,
      getAllJobUseCase: mockGetAllJobUseCase,
      updateJobUseCase: mockUpdateJobUseCase,
      deleteJobUseCase: mockDeleteJobUseCase,
    );
  });

  tearDown(() {
    jobPostingBloc.close();
  });

  group('JobPostingBloc', () {
    final tJob = JobPosting(
      jobId: 'job1',
      jobTitle: 'Test Job',
      jobDescription: '',
      datePosted: DateTime.now(),
      status: 'open',
      category: 'General',
      subCategory: '',
      location: '',
      salaryRange: '',
      contractType: '',
      applicationDeadline:
          DateTime.now().add(const Duration(days: 30)), // Fixed null
      contactInfo: '',
      posterFullName: '',
      posterEmail: '',
      posterImage: '',
    );

    blocTest<JobPostingBloc, JobPostingState>(
      'emits [loading, success] on create job success',
      build: () {
        when(() => mockCreateJobUseCase(any()))
            .thenAnswer((_) async => Right(tJob));
        return jobPostingBloc;
      },
      act: (bloc) => bloc.add(CreateJobPostingEvent(tJob)),
      expect: () => [
        const JobPostingState(isLoading: true),
        JobPostingState(isLoading: false, isSuccess: true, jobPostings: [tJob]),
      ],
    );

    blocTest<JobPostingBloc, JobPostingState>(
      'emits [loading, success] on get all jobs success',
      build: () {
        when(() => mockGetAllJobUseCase())
            .thenAnswer((_) async => Right([tJob]));
        return jobPostingBloc;
      },
      act: (bloc) => bloc.add(const GetAllJobsEvent()),
      expect: () => [
        const JobPostingState(isLoading: true),
        JobPostingState(isLoading: false, isSuccess: true, jobPostings: [tJob]),
      ],
    );
  });
}
