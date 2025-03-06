import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';

class GetSeekerBookingsUseCase {
  final ITaskRepository repository;

  GetSeekerBookingsUseCase(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call() async {
    return await repository.getSeekerBookings();
  }
}