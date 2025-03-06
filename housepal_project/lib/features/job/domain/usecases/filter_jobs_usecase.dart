import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';

class FilterJobsUseCase {
  final IJobRepository jobRepository;

  FilterJobsUseCase(this.jobRepository);

  Future<Either<Failure, List<JobPosting>>> call({
    String? contractType,
    String? category,
    String? location,
    String? salaryRange,
  }) async {
    return await jobRepository.filterJobs(
      contractType: contractType,
      category: category,
      location: location,
      salaryRange: salaryRange,
    );
  }
}
