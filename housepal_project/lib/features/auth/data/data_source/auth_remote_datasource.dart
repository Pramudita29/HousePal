import 'dart:io';

import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/features/auth/data/data_source/auth_datasource.dart';
import 'package:housepal_project/features/auth/data/model/auth_api_model.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);


  @override
  Future<AuthEntity> getCurrentUser() async {
    try {
      // Retrieve token and role from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final role = prefs.getString('role');

      if (token == null || token.isEmpty) {
        throw Exception("No authentication token found");
      }

      if (role == null || role.isEmpty) {
        throw Exception("No user role found");
      }

      // Call the appropriate method based on the user's role
      if (role == 'Helper') {
        return await getCurrentHelper(token);
      } else if (role == 'Seeker') {
        return await getCurrentSeeker(token);
      } else {
        throw Exception("Invalid user role");
      }
    } catch (e) {
      throw Exception("Error fetching current user: $e");
    }
  }

  // Method for fetching the current Helper user
  Future<AuthEntity> getCurrentHelper(String token) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getCurrentHelper,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final authApiModel = AuthApiModel.fromJson(response.data);
        return authApiModel.toEntity();
      } else {
        throw Exception("Failed to fetch current Helper data: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching current Helper: $e");
    }
  }

  // Method for fetching the current Seeker user
  Future<AuthEntity> getCurrentSeeker(String token) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getCurrentSeeker,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final authApiModel = AuthApiModel.fromJson(response.data);
        return authApiModel.toEntity();
      } else {
        throw Exception("Failed to fetch current Seeker data: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching current Seeker: $e");
    }
  }


  @override
  Future<String> loginUser(String email, String password) async {
    try {
      // Send the login request to the backend
      Response response = await _dio.post(ApiEndpoints.login, data: {
        "email": email,
        "password": password,
      });

      // Check if login was successful
      if (response.statusCode == 200) {
        // Return the authentication token
        return response.data[
            'token']; // Assuming the token is returned in the response body
      } else {
        throw Exception("Login failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Login error: ${e.message}");
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.register,
        data: {
          "fullName": user.fullName,
          "email": user.email,
          "contactNo":
              user.contactNo, // This should match `contact_no` in the backend
          "password": user.password,
          // "confirmPassword":
          //     user.confirmPassword, // Ensure it matches the backend
          "role": user.role,
          "skills": user.skills, // Make sure it's in the expected format (list)
          "image": user.image,
          "experience": user.experience,
        },
      );

      if (response.statusCode == 201) {
        return; // Registration successful
      } else {
        throw Exception("Registration failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Registration error: ${e.message}");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file, String role, String email) async {
  try {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
      'email': email, // Add the email here
    });

    // Select the correct endpoint based on the role
    String endpoint = role == 'Helper' ? ApiEndpoints.uploadHelperImage : ApiEndpoints.uploadSeekerImage;

    Response response = await _dio.post(endpoint, data: formData);

    if (response.statusCode == 200) {
      return response.data['data']; // Assuming this is the image name or URL returned by the backend
    } else {
      throw Exception(response.statusMessage);
    }
  } on DioException catch (e) {
    throw Exception(e.message);
  }
}

}
