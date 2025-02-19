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
        message: "Failed to load jobs: ${e.message}",
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: "Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, JobPosting>> createJob(JobPosting jobPosting) async {
    try {
      final result = await jobRemoteDataSource.createJob(jobPosting);
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: "Failed to create job posting: ${e.message}",
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: "Unexpected error: $e"));
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
        message: "Failed to update job posting: ${e.message}",
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: "Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteJob(String jobId) async {
    try {
      await jobRemoteDataSource.deleteJob(jobId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: "Failed to delete job posting: ${e.message}",
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: "Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, List<JobPosting>>> filterJobs({
    String? employmentType,
    String? category,
    double? minSalary,
    double? maxSalary,
  }) async {
    try {
      final jobPostings = await jobRemoteDataSource.filterJobs(
        employmentType: employmentType,
        category: category,
        minSalary: minSalary,
        maxSalary: maxSalary,
      );
      return Right(jobPostings);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: "Failed to filter jobs: ${e.message}",
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: "Unexpected error: $e"));
    }
  }
}
