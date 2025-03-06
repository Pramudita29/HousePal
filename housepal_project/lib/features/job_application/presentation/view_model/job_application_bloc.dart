import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';
import 'package:housepal_project/features/job_application/domain/usecases/apply_for_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/get_appication_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/update_application_usecase.dart';
import 'package:housepal_project/features/notification/domain/usecases/create_notification_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/create_tasks_usecase.dart';

part 'job_application_event.dart';
part 'job_application_state.dart';

class JobApplicationBloc
    extends Bloc<JobApplicationEvent, JobApplicationState> {
  final ApplyForJobUseCase applyForJobUseCase;
  final GetApplicationsForJobUseCase getApplicationsForJobUseCase;
  final UpdateApplicationStatusUseCase updateApplicationStatusUseCase;
  final AuthRemoteRepository authRepo;
  final CreateTaskUseCase _createTaskUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;

  JobApplicationBloc({
    required this.applyForJobUseCase,
    required this.getApplicationsForJobUseCase,
    required this.updateApplicationStatusUseCase,
    required this.authRepo,
  })  : _createTaskUseCase = getIt<CreateTaskUseCase>(),
        _createNotificationUseCase = getIt<CreateNotificationUseCase>(),
        super(JobApplicationState.initial()) {
    on<FetchCurrentUserEvent>(_onFetchCurrentUser);
    on<ApplyForJobEvent>(_onApplyForJobEvent);
    on<GetApplicationsForJobEvent>(_onGetApplicationsForJobEvent);
    on<UpdateApplicationStatusEvent>(_onUpdateApplicationStatusEvent);
    on<FetchAllSeekerApplicationsEvent>(_onFetchAllSeekerApplicationsEvent);
    add(const FetchCurrentUserEvent());
  }

  Future<void> _onFetchCurrentUser(
      FetchCurrentUserEvent event, Emitter<JobApplicationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await authRepo.getCurrentUser();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (user) => emit(state.copyWith(isLoading: false, helperDetails: user)),
    );
  }

  Future<void> _onApplyForJobEvent(
      ApplyForJobEvent event, Emitter<JobApplicationState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final helperDetails = state.helperDetails;
    if (helperDetails == null) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'Helper details not found'));
      return;
    }

    final result = await applyForJobUseCase(event.jobId, helperDetails);
    await result.fold(
      (failure) async {
        emit(state.copyWith(
            isLoading: false, isSuccess: false, errorMessage: failure.message));
      },
      (_) async {
        // Update state immediately after applying
        emit(state.copyWith(
            isLoading: false, isSuccess: true, appliedJobId: event.jobId));

        // Notify seeker asynchronously without blocking
        final helperEmail = helperDetails.email;
        try {
          final notificationResult = await _createNotificationUseCase(
            'New Job Application',
            '$helperEmail has applied for your job: ${event.jobId}',
            event.jobId,
            'pbhattarai0129@gmail.com', // Replace with actual seeker email if available
          );
          notificationResult.fold(
            (failure) => print('Failed to notify seeker: ${failure.message}'),
            (_) => print(
                'Seeker notified about application for job ${event.jobId}'),
          );
        } catch (e) {
          print('Notification attempt failed: $e');
        }
      },
    );
  }

  Future<void> _onGetApplicationsForJobEvent(GetApplicationsForJobEvent event,
      Emitter<JobApplicationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getApplicationsForJobUseCase(event.jobId);
    result.fold(
      (failure) => emit(state.copyWith(
          isLoading: false, isSuccess: false, errorMessage: failure.message)),
      (applications) {
        print(
            'Fetched applications for job ${event.jobId}: ${applications.length} applications');
        print('Raw applications data: $applications');
        if (applications.isEmpty) {
          print('No applications returned for job ${event.jobId}');
        } else {
          print('First application details: ${applications.first.toString()}');
          print('First application jobTitle: ${applications.first.jobTitle}');
        }
        try {
          final currentApplications = state.jobApplications ?? [];
          final updatedApplications = applications;
          final mergedApplications =
              {...currentApplications, ...updatedApplications}.toList();
          print('Merged applications: $mergedApplications');
          emit(state.copyWith(
              isLoading: false,
              isSuccess: true,
              jobApplications: mergedApplications,
              errorMessage: ''));
        } catch (e) {
          print('Error processing applications: $e');
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'Failed to process applications: $e',
            jobApplications: state.jobApplications ?? [],
          ));
        }
      },
    );
  }

  Future<void> _onUpdateApplicationStatusEvent(
      UpdateApplicationStatusEvent event,
      Emitter<JobApplicationState> emit) async {
    final updatedApplications = state.jobApplications?.map((app) {
      if (app.applicationId == event.applicationId) {
        return JobApplication(
          applicationId: app.applicationId,
          jobId: app.jobId,
          jobTitle: app.jobTitle,
          applicantDetails: app.applicantDetails,
          status: event.status,
        );
      }
      return app;
    }).toList();
    print(
        'Optimistically updating status for ${event.applicationId} to ${event.status}');
    emit(state.copyWith(isLoading: true, jobApplications: updatedApplications));

    try {
      final result = await updateApplicationStatusUseCase(
          event.applicationId, event.status, event.jobId);
      await result.fold(
        (failure) async {
          print('Server update failed: ${failure.message}');
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'Failed to update status: ${failure.message}',
            jobApplications: updatedApplications,
          ));
        },
        (_) async {
          print(
              'Server update succeeded: ${event.applicationId} to ${event.status}');
          if (event.status == 'accepted') {
            final app = updatedApplications
                ?.firstWhere((a) => a.applicationId == event.applicationId);
            if (app != null) {
              final seekerEmail = (await authRepo.getCurrentUser())
                      .fold((_) => '', (user) => user.email) ??
                  '';
              final scheduledTime = DateTime.now().add(const Duration(days: 1));
              final taskResult = await _createTaskUseCase(
                  event.jobId,
                  event.applicationId,
                  seekerEmail,
                  app.applicantDetails.email,
                  scheduledTime);
              taskResult.fold(
                (failure) => print('Failed to create task: ${failure.message}'),
                (_) => print('Task created for job ${event.jobId}'),
              );

              // Notify helper
              final notificationResult = await _createNotificationUseCase(
                'Job Accepted',
                'Your application for job ${event.jobId} has been accepted by $seekerEmail',
                event.jobId,
                app.applicantDetails.email,
              );
              notificationResult.fold(
                (failure) =>
                    print('Failed to notify helper: ${failure.message}'),
                (_) => print(
                    'Helper notified about acceptance for job ${event.jobId}'),
              );
            }
          }
          emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            errorMessage: '',
            jobApplications: updatedApplications,
          ));
        },
      );
    } catch (e) {
      print('Exception during status update: $e');
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'Failed to update status: $e',
        jobApplications: updatedApplications,
      ));
    }
  }

  Future<void> _onFetchAllSeekerApplicationsEvent(
      FetchAllSeekerApplicationsEvent event,
      Emitter<JobApplicationState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await getApplicationsForJobUseCase(null);
    result.fold(
      (failure) => emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage:
              'Failed to fetch all applications: ${failure.message}')),
      (applications) {
        print(
            'Fetched all seeker applications: ${applications.length} applications');
        print('Raw all seeker applications: $applications');
        if (applications.isEmpty) {
          print('No seeker applications returned');
        } else {
          print(
              'First seeker application details: ${applications.first.toString()}');
        }
        try {
          emit(state.copyWith(
              isLoading: false,
              isSuccess: true,
              jobApplications: applications,
              errorMessage: ''));
        } catch (e) {
          print('Error processing all seeker applications: $e');
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'Failed to process all applications: $e',
            jobApplications: applications,
          ));
        }
      },
    );
  }
}
