import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';

class UpdateTaskStatusUseCase {
  final ITaskRepository repository;

  UpdateTaskStatusUseCase(this.repository);

  Future<Either<Failure, void>> call(String taskId, String status) async {
    return await repository.updateTaskStatus(taskId, status);
  }
}
