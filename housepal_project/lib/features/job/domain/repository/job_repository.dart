import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';

abstract interface class IJobRepository {
  Future<Either<Failure, List<JobPosting>>> getAllJobs();
  Future<Either<Failure, JobPosting>> createJob(JobPosting job);
  Future<Either<Failure, JobPosting>> updateJob(String jobId, JobPosting job);
  Future<Either<Failure, void>> deleteJob(String jobId); // Changed to void
  Future<Either<Failure, List<JobPosting>>> filterJobs({
    String? contractType,
    String? category,
    String? location,
    String? salaryRange,
  });
}
