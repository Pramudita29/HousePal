import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/notification/domain/usecases/create_notification_usecase.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:housepal_project/features/task/domain/usecases/get_helper_task_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/get_seeker_bookings_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/update_task_status.dart';
import 'package:housepal_project/features/task/presentation/view_model/task_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHelperTasksUseCase extends Mock implements GetHelperTasksUseCase {}

class MockGetSeekerBookingsUseCase extends Mock
    implements GetSeekerBookingsUseCase {}

class MockUpdateTaskStatusUseCase extends Mock
    implements UpdateTaskStatusUseCase {}

class MockCreateNotificationUseCase extends Mock
    implements CreateNotificationUseCase {}

void main() {
  late TaskBloc taskBloc;
  late MockGetHelperTasksUseCase mockGetHelperTasksUseCase;
  late MockGetSeekerBookingsUseCase mockGetSeekerBookingsUseCase;
  late MockUpdateTaskStatusUseCase mockUpdateTaskStatusUseCase;
  late MockCreateNotificationUseCase mockCreateNotificationUseCase;

  setUp(() {
    mockGetHelperTasksUseCase = MockGetHelperTasksUseCase();
    mockGetSeekerBookingsUseCase = MockGetSeekerBookingsUseCase();
    mockUpdateTaskStatusUseCase = MockUpdateTaskStatusUseCase();
    mockCreateNotificationUseCase = MockCreateNotificationUseCase();
    taskBloc = TaskBloc(
      getHelperTasksUseCase: mockGetHelperTasksUseCase,
      getSeekerBookingsUseCase: mockGetSeekerBookingsUseCase,
      updateTaskStatusUseCase: mockUpdateTaskStatusUseCase,
    );
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc', () {
    final tTask = TaskEntity(
      taskId: 'task1',
      jobId: 'job1',
      seekerEmail: 'seeker@example.com',
      helperFullName: 'Helper',
      helperEmail: 'helper@example.com',
      jobTitle: 'Test Job',
      scheduledTime: DateTime.now(),
      status: 'pending',
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, success] on fetch helper tasks success',
      build: () {
        when(() => mockGetHelperTasksUseCase(any()))
            .thenAnswer((_) async => Right([tTask]));
        return taskBloc;
      },
      act: (bloc) =>
          bloc.add(const FetchHelperTasksEvent('helper@example.com')),
      expect: () => [
        const TaskState(isLoading: true),
        TaskState(isLoading: false, tasks: [tTask]),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, success] on update task status success',
      build: () {
        when(() => mockUpdateTaskStatusUseCase(any(), any()))
            .thenAnswer((_) async => const Right(unit)); // Fixed null with unit
        when(() => mockGetHelperTasksUseCase(any())).thenAnswer(
            (_) async => Right([tTask.copyWith(status: 'completed')]));
        when(() => mockGetSeekerBookingsUseCase()).thenAnswer(
            (_) async => Right([tTask.copyWith(status: 'completed')]));
        when(() => mockCreateNotificationUseCase(any(), any(), any(), any()))
            .thenAnswer((_) async => const Right(unit)); // Fixed null with unit
        return taskBloc..add(const FetchHelperTasksEvent('helper@example.com'));
      },
      seed: () => TaskState(tasks: [tTask], isLoading: false),
      act: (bloc) => bloc.add(const UpdateTaskStatusEvent('task1', 'completed',
          helperEmail: 'helper@example.com')),
      expect: () => [
        TaskState(isLoading: true, tasks: [tTask]),
        TaskState(
            isLoading: false, tasks: [tTask.copyWith(status: 'completed')]),
        TaskState(
            isLoading: false, tasks: [tTask.copyWith(status: 'completed')]),
      ],
    );
  });
}
