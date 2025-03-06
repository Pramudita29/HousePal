part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class FetchHelperTasksEvent extends TaskEvent {
  final String helperEmail;
  const FetchHelperTasksEvent(this.helperEmail);
  @override
  List<Object?> get props => [helperEmail];
}

class FetchSeekerBookingsEvent extends TaskEvent {}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final String status;
  final String? helperEmail; // Added helperEmail

  const UpdateTaskStatusEvent(this.taskId, this.status, {this.helperEmail});
  @override
  List<Object?> get props => [taskId, status, helperEmail];
}
