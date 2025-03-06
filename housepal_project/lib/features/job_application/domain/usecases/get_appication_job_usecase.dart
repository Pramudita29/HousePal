import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';

class GetApplicationsForJobUseCase {
  final IJobApplicationRepository jobApplicationRepository;

  GetApplicationsForJobUseCase({required this.jobApplicationRepository});

  Future<Either<Failure, List<JobApplication>>> call(String? jobId) async {
    if (jobId == null) {
      // Fetch all applications for the Seeker
      return await jobApplicationRepository.getAllSeekerApplications();
    } else {
      return await jobApplicationRepository.getApplicationsForJob(jobId);
    }
  }
}
