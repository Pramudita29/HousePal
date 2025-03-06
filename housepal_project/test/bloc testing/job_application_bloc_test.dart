import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';
import 'package:housepal_project/features/job_application/domain/usecases/apply_for_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/get_appication_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/update_application_usecase.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';
import 'package:housepal_project/features/notification/domain/usecases/create_notification_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/create_tasks_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockApplyForJobUseCase extends Mock implements ApplyForJobUseCase {}

class MockGetApplicationsForJobUseCase extends Mock
    implements GetApplicationsForJobUseCase {}

class MockUpdateApplicationStatusUseCase extends Mock
    implements UpdateApplicationStatusUseCase {}

class MockAuthRemoteRepository extends Mock implements AuthRemoteRepository {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

class MockCreateNotificationUseCase extends Mock
    implements CreateNotificationUseCase {}

void main() {
  late JobApplicationBloc jobApplicationBloc;
  late MockApplyForJobUseCase mockApplyForJobUseCase;
  late MockGetApplicationsForJobUseCase mockGetApplicationsForJobUseCase;
  late MockUpdateApplicationStatusUseCase mockUpdateApplicationStatusUseCase;
  late MockAuthRemoteRepository mockAuthRemoteRepository;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockCreateNotificationUseCase mockCreateNotificationUseCase;

  setUp(() {
    mockApplyForJobUseCase = MockApplyForJobUseCase();
    mockGetApplicationsForJobUseCase = MockGetApplicationsForJobUseCase();
    mockUpdateApplicationStatusUseCase = MockUpdateApplicationStatusUseCase();
    mockAuthRemoteRepository = MockAuthRemoteRepository();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockCreateNotificationUseCase = MockCreateNotificationUseCase();
    jobApplicationBloc = JobApplicationBloc(
      applyForJobUseCase: mockApplyForJobUseCase,
      getApplicationsForJobUseCase: mockGetApplicationsForJobUseCase,
      updateApplicationStatusUseCase: mockUpdateApplicationStatusUseCase,
      authRepo: mockAuthRemoteRepository,
    );
    registerFallbackValue(AuthEntity(
      fullName: '',
      email: '',
      contactNo: '',
      password: '',
      confirmPassword: '',
      role: '',
    ));
  });

  tearDown(() {
    jobApplicationBloc.close();
  });

  group('JobApplicationBloc', () {
    final tHelper = AuthEntity(
      fullName: 'Helper',
      email: 'helper@example.com',
      contactNo: '123',
      password: 'pass',
      confirmPassword: 'pass',
      role: 'helper',
    );
    final tApplication = JobApplication(
      applicationId: 'app1',
      jobId: 'job1',
      jobTitle: 'Test Job',
      applicantDetails: tHelper,
      status: 'pending',
    );

    blocTest<JobApplicationBloc, JobApplicationState>(
      'emits [loading, success] on apply for job success',
      build: () {
        when(() => mockAuthRemoteRepository.getCurrentUser())
            .thenAnswer((_) async => Right(tHelper));
        when(() => mockApplyForJobUseCase(any(), any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockCreateNotificationUseCase(any(), any(), any(), any()))
            .thenAnswer((_) async => const Right(unit)); // Fixed null with unit
        return jobApplicationBloc..add(const FetchCurrentUserEvent());
      },
      act: (bloc) => bloc.add(const ApplyForJobEvent('job1')),
      expect: () => [
        const JobApplicationState(
            isLoading: true, isSuccess: false, errorMessage: ''),
        JobApplicationState(
            isLoading: false,
            isSuccess: false,
            errorMessage: '',
            helperDetails: tHelper),
        JobApplicationState(
            isLoading: false,
            isSuccess: true,
            errorMessage: '',
            helperDetails: tHelper,
            appliedJobId: 'job1'),
      ],
    );

    blocTest<JobApplicationBloc, JobApplicationState>(
      'emits [loading, success] on get applications success',
      build: () {
        when(() => mockGetApplicationsForJobUseCase(any()))
            .thenAnswer((_) async => Right([tApplication]));
        return jobApplicationBloc;
      },
      act: (bloc) => bloc.add(const GetApplicationsForJobEvent('job1')),
      expect: () => [
        const JobApplicationState(
            isLoading: true, isSuccess: false, errorMessage: ''),
        JobApplicationState(
            isLoading: false,
            isSuccess: true,
            errorMessage: '',
            jobApplications: [tApplication]),
      ],
    );
  });
}
