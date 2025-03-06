import 'package:housepal_project/features/task/domain/entity/tasks.dart';

abstract class ITaskDataSource {
  Future<List<TaskEntity>> getHelperTasks(String helperEmail);
  Future<List<TaskEntity>> getSeekerBookings();
  Future<void> updateTaskStatus(String taskId, String status);
  Future<void> createTask(
      String jobId,
      String applicationId,
      String seekerEmail,
      String helperEmail,
      DateTime scheduledTime); // New method
}
