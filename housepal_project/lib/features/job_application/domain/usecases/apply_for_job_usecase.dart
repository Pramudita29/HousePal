import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';

class ApplyForJobUseCase {
  final IJobApplicationRepository jobApplicationRepository;

  ApplyForJobUseCase({required this.jobApplicationRepository});

  Future<Either<Failure, bool>> call(
      String jobId, AuthEntity helperDetails) async {
    return await jobApplicationRepository.applyForJob(jobId, helperDetails);
  }
}
