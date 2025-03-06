import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_api_model.g.dart';

@JsonSerializable()
class TaskApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final dynamic jobId; // Changed to dynamic to handle Map or String
  final String seekerEmail;
  final Map<String, dynamic> helperDetails;
  final String scheduledTime;
  final String status;

  const TaskApiModel({
    this.id,
    required this.jobId,
    required this.seekerEmail,
    required this.helperDetails,
    required this.scheduledTime,
    required this.status,
  });

  factory TaskApiModel.fromJson(Map<String, dynamic> json) {
    print('TaskApiModel.fromJson: $json');
    final helperDetails = json['helperDetails'] as Map<String, dynamic>? ?? {};
    final model = TaskApiModel(
      id: json['_id'] as String?,
      jobId: json['jobId'], // Keep as dynamic to handle Map or String
      seekerEmail: json['seekerEmail'] as String,
      helperDetails: helperDetails,
      scheduledTime: json['scheduledDateTime'] as String,
      status: json['status'] as String,
    );
    print(
        'TaskApiModel created: id=${model.id}, jobId=${model.jobId}, helperDetails=${model.helperDetails}');
    return model;
  }

  Map<String, dynamic> toJson() => _$TaskApiModelToJson(this);

  TaskEntity toEntity() {
    final helperFullName = helperDetails['fullName'] as String? ?? 'Unknown';
    final helperEmail = helperDetails['email'] as String? ?? 'Unknown';
    final jobTitle = jobId is Map<String, dynamic>
        ? (jobId as Map<String, dynamic>)['jobTitle'] as String? ??
            'Unknown Job'
        : 'Unknown Job'; // Extract jobTitle from jobId Map
    final jobIdString = jobId is String
        ? jobId as String
        : (jobId as Map<String, dynamic>)['_id'] as String;
    final entity = TaskEntity(
      taskId: id ?? '',
      jobId: jobIdString,
      seekerEmail: seekerEmail,
      helperFullName: helperFullName,
      helperEmail: helperEmail,
      jobTitle: jobTitle,
      scheduledTime: DateTime.parse(scheduledTime),
      status: status,
    );
    print(
        'TaskEntity created: taskId=${entity.taskId}, jobId=${entity.jobId}, jobTitle=${entity.jobTitle}, helperFullName=${entity.helperFullName}, helperEmail=${entity.helperEmail}');
    return entity;
  }

  static TaskApiModel fromEntity(TaskEntity entity) => TaskApiModel(
        id: entity.taskId,
        jobId: {'_id': entity.jobId, 'jobTitle': entity.jobTitle},
        seekerEmail: entity.seekerEmail,
        helperDetails: {
          'fullName': entity.helperFullName,
          'email': entity.helperEmail,
        },
        scheduledTime: entity.scheduledTime.toIso8601String(),
        status: entity.status,
      );

  @override
  List<Object?> get props =>
      [id, jobId, seekerEmail, helperDetails, scheduledTime, status];
}
