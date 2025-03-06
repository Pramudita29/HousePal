import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/features/job/data/data_source/job_data_source.dart';
import 'package:housepal_project/features/job/data/model/job_posting_api_model.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobRemoteDataSource implements IJobDataSource {
  final Dio _dio;

  JobRemoteDataSource(this._dio);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Future<List<JobPosting>> getAllJobs() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        ApiEndpoints.getPublicJobs, // Use public endpoint for all jobs
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jobJson = response.data;
        return jobJson
            .map((job) => JobPostingApiModel.fromJson(job).toEntity())
            .toList();
      } else {
        throw Exception("Failed to load jobs: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Failed to load jobs: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<JobPosting> createJob(JobPosting job) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token is missing");

      final prefs = await SharedPreferences.getInstance();
      final posterEmail = prefs.getString('posterEmail') ??
          prefs.getString('email') ??
          'unknown@example.com';

      final updatedJob = job.copyWith(posterEmail: posterEmail);
      final jobApiModel = JobPostingApiModel.fromEntity(updatedJob);

      final response = await _dio.post(
        ApiEndpoints.createJob,
        data: jobApiModel.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return JobPostingApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception("Failed to create job: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Create job error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<JobPosting> updateJob(String jobId, JobPosting job) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token is missing");

      final response = await _dio.put(
        ApiEndpoints.updateJob(jobId),
        data: JobPostingApiModel.fromEntity(job).toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return JobPostingApiModel.fromJson(response.data['data']).toEntity();
      } else {
        throw Exception("Failed to update job: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Update job error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token is missing");

      final response = await _dio.delete(
        ApiEndpoints.deleteJob(jobId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to delete job: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Delete job error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<List<JobPosting>> filterJobs({
    String? contractType,
    String? category,
    String? location,
    String? salaryRange,
  }) async {
    final queryParams = {
      if (contractType != null) 'contractType': contractType,
      if (category != null) 'category': category,
      if (location != null) 'location': location,
      if (salaryRange != null) 'salaryRange': salaryRange,
    };

    try {
      final token = await _getToken();
      final response = await _dio.get(
        ApiEndpoints.filterJobs,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jobJson = response.data['jobs'];
        return jobJson
            .map((job) => JobPostingApiModel.fromJson(job).toEntity())
            .toList();
      } else {
        throw Exception("Failed to filter jobs: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Filter jobs error: ${e.response?.data['message'] ?? e.message}");
    }
  }
}
