import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';

class UpdateApplicationStatusUseCase {
  final IJobApplicationRepository jobApplicationRepository;

  UpdateApplicationStatusUseCase({required this.jobApplicationRepository});

  Future<Either<Failure, bool>> call(String applicationId, String status, String jobId) async {
    return await jobApplicationRepository.updateApplicationStatus(applicationId, status, jobId);
  }
}