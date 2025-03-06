import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';

class CreateJobPostingUseCase {
  final IJobRepository jobRepository;

  CreateJobPostingUseCase(this.jobRepository);

  Future<Either<Failure, JobPosting>> call(JobPosting jobPosting) async {
    return await jobRepository.createJob(jobPosting);
  }
}
