import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/features/notification/domain/usecases/create_notification_usecase.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:housepal_project/features/task/domain/usecases/get_helper_task_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/get_seeker_bookings_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/update_task_status.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetHelperTasksUseCase getHelperTasksUseCase;
  final GetSeekerBookingsUseCase getSeekerBookingsUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;

  TaskBloc({
    required this.getHelperTasksUseCase,
    required this.getSeekerBookingsUseCase,
    required this.updateTaskStatusUseCase,
  })  : _createNotificationUseCase = getIt<CreateNotificationUseCase>(),
        super(TaskState.initial()) {
    on<FetchHelperTasksEvent>(_onFetchHelperTasks);
    on<FetchSeekerBookingsEvent>(_onFetchSeekerBookings);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
  }

  Future<void> _onFetchHelperTasks(
      FetchHelperTasksEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getHelperTasksUseCase(event.helperEmail);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (tasks) {
        final uniqueTasks = <String, TaskEntity>{};
        for (var task in tasks) {
          uniqueTasks[task.jobId] = task;
        }
        final filteredTasks = uniqueTasks.values.toList();
        print('Fetched helper tasks: ${filteredTasks.length} unique tasks');
        for (var task in filteredTasks) {
          print(
              'Helper task: taskId=${task.taskId}, status=${task.status}, jobId=${task.jobId}');
        }
        emit(state.copyWith(
            isLoading: false, tasks: filteredTasks, errorMessage: null));
      },
    );
  }

  Future<void> _onFetchSeekerBookings(
      FetchSeekerBookingsEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getSeekerBookingsUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (tasks) {
        final uniqueTasks = <String, TaskEntity>{};
        for (var task in tasks) {
          uniqueTasks[task.jobId] = task;
        }
        final filteredTasks = uniqueTasks.values.toList();
        print('Fetched seeker bookings: ${filteredTasks.length} unique tasks');
        for (var task in filteredTasks) {
          print(
              'Seeker task: taskId=${task.taskId}, status=${task.status}, jobId=${task.jobId}');
        }
        emit(state.copyWith(
            isLoading: false, tasks: filteredTasks, errorMessage: null));
      },
    );
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatusEvent event, Emitter<TaskState> emit) async {
    print('Updating task ${event.taskId} to ${event.status}');
    emit(state.copyWith(isLoading: true));
    final result = await updateTaskStatusUseCase(event.taskId, event.status);
    await result.fold(
      (failure) async {
        print('Failed to update task status: ${failure.message}');
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) async {
        print('Task status updated successfully on backend');
        // Update local tasks first
        final updatedTasks = state.tasks
                ?.map((task) => task.taskId == event.taskId
                    ? task.copyWith(status: event.status)
                    : task)
                .toList() ??
            [];
        if (event.status == 'completed') {
          final task = updatedTasks.firstWhere((t) => t.taskId == event.taskId);
          print('Sending notification for completed task ${task.taskId}');
          final notificationResult = await _createNotificationUseCase(
            'Job Completed',
            'The job ${task.jobId} has been completed by ${task.helperEmail}',
            task.jobId,
            task.seekerEmail,
          );
          notificationResult.fold(
            (failure) => print('Failed to notify seeker: ${failure.message}'),
            (_) =>
                print('Seeker notified about completion of job ${task.jobId}'),
          );
        }
        // Emit updated state immediately
        emit(state.copyWith(
            isLoading: false, tasks: updatedTasks, errorMessage: null));
        print('Emitted updated state with ${updatedTasks.length} tasks');

        // Refresh tasks in background with delay to allow backend sync
        await Future.delayed(
            const Duration(seconds: 2)); // Temporary workaround
        if (event.helperEmail != null) {
          final helperResult = await getHelperTasksUseCase(event.helperEmail!);
          helperResult.fold(
            (failure) =>
                print('Failed to refresh helper tasks: ${failure.message}'),
            (helperTasks) {
              final uniqueHelperTasks = <String, TaskEntity>{};
              for (var task in helperTasks) {
                uniqueHelperTasks[task.jobId] = task;
              }
              // Merge with local updates
              final mergedTasks = updatedTasks.map((localTask) {
                return helperTasks.firstWhere(
                  (remoteTask) => remoteTask.taskId == localTask.taskId,
                  orElse: () => localTask,
                );
              }).toList();
              print(
                  'Refreshed helper tasks: ${mergedTasks.length} unique tasks');
              emit(state.copyWith(tasks: mergedTasks));
            },
          );
        }
        final seekerResult = await getSeekerBookingsUseCase();
        seekerResult.fold(
          (failure) =>
              print('Failed to refresh seeker tasks: ${failure.message}'),
          (seekerTasks) {
            final uniqueSeekerTasks = <String, TaskEntity>{};
            for (var task in seekerTasks) {
              uniqueSeekerTasks[task.jobId] = task;
            }
            // Merge with local updates
            final mergedTasks = updatedTasks.map((localTask) {
              return seekerTasks.firstWhere(
                (remoteTask) => remoteTask.taskId == localTask.taskId,
                orElse: () => localTask,
              );
            }).toList();
            print(
                'Refreshed seeker bookings: ${mergedTasks.length} unique tasks');
            emit(state.copyWith(tasks: mergedTasks));
          },
        );
      },
    );
  }
}

// ... (TaskEvent and TaskState unchanged)
