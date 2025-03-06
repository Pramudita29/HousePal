import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/data/model/job_application_api_model.dart';

abstract class IJobApplicationDataSource {
  Future<void> applyForJob(String jobId, AuthEntity helperDetails);
  Future<List<JobApplicationApiModel>> getApplicationsForJob(String jobId);
  Future<void> updateApplicationStatus(String jobId, String applicationId,
      String status); // Updated to include jobId
}