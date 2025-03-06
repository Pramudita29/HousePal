// task_state.dart

part of 'task_bloc.dart';

class TaskState extends Equatable {
  final bool isLoading;
  final List<TaskEntity>? tasks;
  final String? errorMessage;

  const TaskState({
    this.isLoading = false,
    this.tasks,
    this.errorMessage,
  });

  factory TaskState.initial() => const TaskState();

  TaskState copyWith({
    bool? isLoading,
    List<TaskEntity>? tasks,
    String? errorMessage,
  }) =>
      TaskState(
        isLoading: isLoading ?? this.isLoading,
        tasks: tasks ?? this.tasks,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [isLoading, tasks, errorMessage];
}
