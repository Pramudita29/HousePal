import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';

class GetHelperTasksUseCase {
  final ITaskRepository repository;

  GetHelperTasksUseCase(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call(String helperEmail) async {
    return await repository.getHelperTasks(helperEmail);
  }
}
