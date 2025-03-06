import 'package:housepal_project/features/job/domain/entity/job_posting.dart';

abstract class IJobDataSource {
  Future<List<JobPosting>> getAllJobs();
  Future<JobPosting> createJob(JobPosting job);
  Future<JobPosting> updateJob(String jobId, JobPosting job);
  Future<void> deleteJob(String jobId);
  Future<List<JobPosting>> filterJobs({
    String? contractType, // Align with backend
    String? category,
    String? location,
    String? salaryRange, // Use String to match backend
  });
}
