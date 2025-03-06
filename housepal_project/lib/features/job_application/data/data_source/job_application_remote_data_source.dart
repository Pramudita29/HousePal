import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/features/auth/data/model/auth_api_model.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/data/data_source/job_application_data_source.dart';
import 'package:housepal_project/features/job_application/data/model/job_application_api_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobApplicationRemoteDataSource implements IJobApplicationDataSource {
  final Dio _dio;

  JobApplicationRemoteDataSource(this._dio);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Future<void> applyForJob(String jobId, AuthEntity helperDetails) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final applicationData = {
        'jobId': jobId,
        'helperDetails': {
          'fullName': helperDetails.fullName,
          'email': helperDetails.email,
          'contactNo': helperDetails.contactNo,
          'skills': helperDetails.skills,
          'experience': helperDetails.experience,
          'image': helperDetails.image,
        },
      };

      final response = await _dio.post(
        ApiEndpoints.applyForJob(jobId),
        data: applicationData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to apply for job: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Apply for job error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<List<JobApplicationApiModel>> getApplicationsForJob(
      String jobId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final response = await _dio.get(
        ApiEndpoints.getApplicationsForJob(jobId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Get applications for job $jobId response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> applicationJson = response.data;
        return applicationJson.map((json) {
          try {
            return JobApplicationApiModel.fromJson(json);
          } catch (e) {
            print('Error parsing application: $e');
            // Return a fallback model to avoid crash
            return JobApplicationApiModel(
              applicationId: json['_id']?.toString(),
              jobId: json['jobId'] is String
                  ? json['jobId']
                  : json['jobId']['_id'],
              applicantDetails: AuthApiModel(
                fullName: json['helperDetails']['fullName'],
                email: json['helperDetails']['email'],
                contactNo: json['helperDetails']['contactNo'],
                skills: List<String>.from(json['helperDetails']['skills']),
                experience: json['helperDetails']['experience'],
                image: json['helperDetails']['image'],
              ),
              status: json['status'],
            );
          }
        }).toList();
      } else {
        throw Exception(
            "Failed to load applications: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Get applications error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<List<JobApplicationApiModel>> getAllSeekerApplications() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final response = await _dio.get(
        ApiEndpoints.getAllApplications,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Get all seeker applications response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> applicationJson = response.data;
        return applicationJson
            .map((json) => JobApplicationApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            "Failed to load all seeker applications: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Get all seeker applications error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> updateApplicationStatus(
      String jobId, String applicationId, String status) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final response = await _dio.put(
        ApiEndpoints.updateApplicationStatus(jobId, applicationId),
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print(
          'Update application status $applicationId for job $jobId response: ${response.data}');
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update application status: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Update application status error: ${e.response?.data['message'] ?? e.message}");
    }
  }
}
