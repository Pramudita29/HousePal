import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';

class GetAllJobUseCase {
  final IJobRepository repository;

  GetAllJobUseCase(this.repository);

  Future<Either<Failure, List<JobPosting>>> call() async {
    // Changed to call
    return await repository.getAllJobs();
  }
}
