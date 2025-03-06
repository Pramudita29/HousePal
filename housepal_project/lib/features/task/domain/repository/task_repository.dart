import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';

abstract interface class ITaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getHelperTasks(String helperEmail);
  Future<Either<Failure, List<TaskEntity>>> getSeekerBookings();
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status);
  Future<Either<Failure, void>> createTask(
      String jobId,
      String applicationId,
      String seekerEmail,
      String helperEmail,
      DateTime scheduledTime); // New method
}
