import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/data/data_source/job_remote_data_source.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';

class JobRemoteRepository implements IJobRepository {
  final JobRemoteDataSource jobRemoteDataSource;

  JobRemoteRepository(this.jobRemoteDataSource);

  @override
  Future<Either<Failure, List<JobPosting>>> getAllJobs() async {
    try {
      final jobPostings = await jobRemoteDataSource.getAllJobs();
      return Right(jobPostings);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, JobPosting>> createJob(JobPosting jobPosting) async {
    try {
      final result = await jobRemoteDataSource.createJob(jobPosting);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, JobPosting>> updateJob(
      String jobId, JobPosting jobPosting) async {
    try {
      final updatedJob = await jobRemoteDataSource.updateJob(jobId, jobPosting);
      return Right(updatedJob);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(String jobId) async {
    // Changed to void
    try {
      await jobRemoteDataSource.deleteJob(jobId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<JobPosting>>> filterJobs({
    String? contractType,
    String? category,
    String? location,
    String? salaryRange,
  }) async {
    try {
      final jobPostings = await jobRemoteDataSource.filterJobs(
        contractType: contractType,
        category: category,
        location: location,
        salaryRange: salaryRange,
      );
      return Right(jobPostings);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }
}
