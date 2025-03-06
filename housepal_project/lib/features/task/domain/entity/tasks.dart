import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String taskId;
  final String jobId;
  final String seekerEmail;
  final String helperFullName;
  final String helperEmail;
  final String jobTitle; // New field
  final DateTime scheduledTime;
  final String status;

  const TaskEntity({
    required this.taskId,
    required this.jobId,
    required this.seekerEmail,
    required this.helperFullName,
    required this.helperEmail,
    required this.jobTitle,
    required this.scheduledTime,
    required this.status,
  });

  TaskEntity copyWith({
    String? taskId,
    String? jobId,
    String? seekerEmail,
    String? helperFullName,
    String? helperEmail,
    String? jobTitle,
    DateTime? scheduledTime,
    String? status,
  }) =>
      TaskEntity(
        taskId: taskId ?? this.taskId,
        jobId: jobId ?? this.jobId,
        seekerEmail: seekerEmail ?? this.seekerEmail,
        helperFullName: helperFullName ?? this.helperFullName,
        helperEmail: helperEmail ?? this.helperEmail,
        jobTitle: jobTitle ?? this.jobTitle,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        taskId,
        jobId,
        seekerEmail,
        helperFullName,
        helperEmail,
        jobTitle,
        scheduledTime,
        status,
      ];

  get salary => null;
}