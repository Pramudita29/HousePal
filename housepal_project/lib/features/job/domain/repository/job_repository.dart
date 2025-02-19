import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';

abstract interface class IJobRepository {
  // Fetch all jobs
  Future<Either<Failure, List<JobPosting>>> getAllJobs();

  // Create a job posting
  Future<Either<Failure, JobPosting>> createJob(JobPosting job);

  // Update an existing job posting
  Future<Either<Failure, JobPosting>> updateJob(String jobId, JobPosting job);

  // Delete a job posting
  Future<Either<Failure, Unit>> deleteJob(String jobId);

  // Filter jobs based on provided parameters
  Future<Either<Failure, List<JobPosting>>> filterJobs({
    String? employmentType,
    String? category,
    double? minSalary,
    double? maxSalary,
  });
}
