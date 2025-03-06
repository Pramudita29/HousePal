import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';

class UpdateJobUseCase {
  final IJobRepository jobRepository;

  UpdateJobUseCase({required this.jobRepository});

  Future<Either<Failure, JobPosting>> call(String jobId, JobPosting job) async {
    return await jobRepository.updateJob(jobId, job);
  }
}