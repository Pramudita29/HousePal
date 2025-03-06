import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/data/data_sources/task_datasource.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';

class TaskRemoteRepository implements ITaskRepository {
  final ITaskDataSource dataSource;

  TaskRemoteRepository(this.dataSource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getHelperTasks(
      String helperEmail) async {
    try {
      final tasks = await dataSource.getHelperTasks(helperEmail);
      return Right(tasks);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getSeekerBookings() async {
    try {
      final tasks = await dataSource.getSeekerBookings();
      return Right(tasks);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTaskStatus(
      String taskId, String status) async {
    try {
      await dataSource.updateTaskStatus(taskId, status);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createTask(String jobId, String applicationId,
      String seekerEmail, String helperEmail, DateTime scheduledTime) async {
    try {
      await dataSource.createTask(
          jobId, applicationId, seekerEmail, helperEmail, scheduledTime);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
