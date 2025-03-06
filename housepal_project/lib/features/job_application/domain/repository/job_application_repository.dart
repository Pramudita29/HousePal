import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';

abstract interface class IJobApplicationRepository {
  Future<Either<Failure, bool>> applyForJob(
      String jobId, AuthEntity helperDetails);
  Future<Either<Failure, List<JobApplication>>> getApplicationsForJob(
      String jobId);
  Future<Either<Failure, List<JobApplication>>> getAllSeekerApplications();
  Future<Either<Failure, bool>> updateApplicationStatus(
      String applicationId, String status, String jobId);
}
