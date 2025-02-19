import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/features/job/data/data_source/job_data_source.dart';
import 'package:housepal_project/features/job/data/model/job_posting_api_model.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobRemoteDataSource implements IJobDataSource {
  final Dio _dio;

  JobRemoteDataSource(this._dio);

  @override
  Future<List<JobPosting>> getAllJobs() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllJobs);

      if (response.statusCode == 200) {
        final List<dynamic> jobJson = response.data;

        // Retrieve user details from SharedPreferences
        final userDetails = await getUserDetails();
        final posterFullName = userDetails['posterFullName'];
        final posterEmail = userDetails['posterEmail'];

        // Update each job object with the retrieved user details
        final List<JobPosting> jobs = jobJson.map((job) {
          final jobEntity = JobPostingApiModel.fromJson(job).toEntity();
          return jobEntity.copyWith(
            posterFullName: posterFullName,
            posterEmail: posterEmail,
          );
        }).toList();

        return jobs;
      } else {
        throw Exception("Failed to load jobs: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Error in getAllJobs: ${e.message}");
      throw Exception("Failed to load jobs: ${e.message}");
    } catch (e) {
      print("Unexpected error in getAllJobs: $e");
      rethrow;
    }
  }

  @override
  Future<JobPosting> createJob(JobPosting job) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token is missing");
      }

      // Retrieve user details from SharedPreferences
      final userDetails = await getUserDetails();
      final posterFullName = userDetails['posterFullName'];
      final posterEmail = userDetails['posterEmail'];

      // Update the job object with the retrieved user details
      final updatedJob = job.copyWith(
        posterFullName: posterFullName,
        posterEmail: posterEmail,
      );

      final jobApiModel = JobPostingApiModel.fromEntity(updatedJob);
      final jobJson = jobApiModel.toJson();

      Response response = await _dio.post(
        ApiEndpoints.createJob,
        data: jobJson,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        return JobPostingApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception("Failed to create job: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Create job error: ${e.message}");
      throw Exception("Create job error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unexpected error in createJob: $e");
      rethrow;
    }
  }

  Future<Map<String, String>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final posterFullName = prefs.getString('posterFullName') ?? 'Unknown User';
    final posterEmail = prefs.getString('posterEmail') ?? 'No email available';

    // Debugging: Print the retrieved user details
    print('getUserDetails - Retrieved Poster Full Name: $posterFullName');
    print('getUserDetails - Retrieved Poster Email: $posterEmail');

    return {
      'posterFullName': posterFullName,
      'posterEmail': posterEmail,
    };
  }

  @override
  Future<JobPosting> updateJob(String jobId, JobPosting job) async {
    try {
      Response response = await _dio.put(
        ApiEndpoints.updateJob(jobId),
        data: JobPostingApiModel.fromEntity(job).toJson(),
      );

      if (response.statusCode == 200) {
        return JobPostingApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception("Failed to update job: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Update job error: ${e.message}");
      throw Exception("Update job error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unexpected error in updateJob: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      Response response = await _dio.delete(ApiEndpoints.deleteJob(jobId));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete job: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Delete job error: ${e.message}");
      throw Exception("Delete job error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unexpected error in deleteJob: $e");
      rethrow;
    }
  }

  @override
  Future<List<JobPosting>> filterJobs({
    String? employmentType,
    String? category,
    double? minSalary,
    double? maxSalary,
  }) async {
    final queryParams = {
      if (employmentType != null) 'employmentType': employmentType,
      if (category != null) 'category': category,
      if (minSalary != null) 'minSalary': minSalary.toString(),
      if (maxSalary != null) 'maxSalary': maxSalary.toString(),
    };

    try {
      final uri = Uri.parse(ApiEndpoints.filterJobs)
          .replace(queryParameters: queryParams);
      final response = await _dio.get(uri.toString());

      if (response.statusCode == 200) {
        final List<dynamic> jobJson = response.data['jobs'];
        return jobJson
            .map((job) => JobPostingApiModel.fromJson(job).toEntity())
            .toList();
      } else {
        throw Exception("Failed to filter jobs: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Filter jobs error: ${e.message}");
      throw Exception("Filter jobs error: ${e.response?.data ?? e.message}");
    } catch (e) {
      print("Unexpected error in filterJobs: $e");
      rethrow;
    }
  }
}
