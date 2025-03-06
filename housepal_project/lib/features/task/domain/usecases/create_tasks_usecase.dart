import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';

class CreateTaskUseCase {
  final ITaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<Either<Failure, void>> call(String jobId, String applicationId, String seekerEmail, String helperEmail, DateTime scheduledTime) async {
    return await repository.createTask(jobId, applicationId, seekerEmail, helperEmail, scheduledTime);
  }
}