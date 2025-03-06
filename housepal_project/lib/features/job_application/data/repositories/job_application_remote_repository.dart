import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/data/data_source/job_application_remote_data_source.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';

class JobApplicationRemoteRepository implements IJobApplicationRepository {
  final JobApplicationRemoteDataSource jobApplicationRemoteDataSource;

  JobApplicationRemoteRepository(this.jobApplicationRemoteDataSource);

  @override
  Future<Either<Failure, bool>> applyForJob(
      String jobId, AuthEntity helperDetails) async {
    try {
      await jobApplicationRemoteDataSource.applyForJob(jobId, helperDetails);
      return const Right(true);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<JobApplication>>> getApplicationsForJob(
      String jobId) async {
    try {
      final applications =
          await jobApplicationRemoteDataSource.getApplicationsForJob(jobId);
      print(
          'Fetched applications for job $jobId: ${applications.length} applications');
      return Right(
          applications.map((apiModel) => apiModel.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<JobApplication>>>
      getAllSeekerApplications() async {
    try {
      final applications =
          await jobApplicationRemoteDataSource.getAllSeekerApplications();
      print(
          'Fetched all seeker applications: ${applications.length} applications');
      return Right(
          applications.map((apiModel) => apiModel.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> updateApplicationStatus(
      String applicationId, String status, String jobId) async {
    try {
      await jobApplicationRemoteDataSource.updateApplicationStatus(
          jobId, applicationId, status);
      return const Right(true);
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.response?.data['message'] ?? e.message,
          statusCode: e.response?.statusCode));
    }
  }
}
