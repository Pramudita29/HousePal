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
  Future<AuthEntity> getCurrentUser(String token) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getCurrentUser,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = AuthApiModel.fromJson(response.data);
        return data.toEntity();
      } else {
        throw Exception("Failed to fetch user: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error in getCurrentUser: $e");
      rethrow;
    }
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );

      print("Login API Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'] as String?;
        final user = response.data['user'] as Map<String, dynamic>?;

        if (token == null || token.isEmpty) {
          throw Exception("Login failed: Token is missing");
        }
        if (user == null) {
          throw Exception("Login failed: User data is missing");
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('posterFullName', user['fullName'] ?? '');
        await prefs.setString('posterEmail', user['email'] ?? '');
        await prefs.setString('role', user['role'] ?? '');

        print("Token and user details saved successfully!");
        return token;
      } else {
        throw Exception("Login failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Login error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          "fullName": user.fullName,
          "email": user.email,
          "contactNo": user.contactNo,
          "password": user.password,
          "confirmPassword": user.password,
          "role": user.role,
          if (user.role == 'Helper') "skills": user.skills,
          if (user.role == 'Helper') "experience": user.experience,
        },
      );

      if (response.statusCode != 201) {
        throw Exception("Registration failed: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Registration error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<String> uploadProfilePicture(
      File file, String role, String email) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: fileName),
        'email': email,
      });

      // Debug role and endpoint selection
      print('UploadProfilePicture - Role: $role, Email: $email');
      final endpoint = role.toLowerCase() == 'helper'
          ? ApiEndpoints.uploadHelperImage
          : ApiEndpoints.uploadSeekerImage;
      print('Selected endpoint: $endpoint');

      final token = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('token'));
      if (token == null) throw Exception('No token found');
      print('Token: $token'); // Debug token

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Upload response: ${response.data}'); // Debug response

      if (response.statusCode == 200 && response.data['imageUrl'] != null) {
        final imageUrl = response.data['imageUrl'] as String;
        return imageUrl.startsWith('http')
            ? imageUrl
            : '${ApiEndpoints.baseUrl}/images/$imageUrl';
      } else {
        throw Exception(response.data['message'] ?? "Image upload failed");
      }
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['error'] ?? e.message ?? 'Unknown error';
      print('Upload error: $errorMsg'); // Debug error
      throw Exception("Image upload error: $errorMsg");
    }
  }

  @override
  Future<AuthEntity> updateUser(AuthEntity user, String token) async {
    try {
      // Debug user and token
      print('Updating user: ${user.toJson()}');
      print('Token: $token');

      final endpoint = user.role == 'helper'
          ? ApiEndpoints.updateHelper(user.userId ?? '')
          : ApiEndpoints.updateSeeker(user.userId ?? '');

      // Debug endpoint
      print('Selected endpoint: $endpoint');

      final response = await _dio.put(
        endpoint,
        data: {
          "id": user.userId,
          "fullName": user.fullName,
          "contactNo": user.contactNo,
          "skills": user.skills,
          "experience": user.experience
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Debug response
      print('Update response: ${response.data}');

      if (response.statusCode == 200) {
        final updatedUser = AuthApiModel.fromJson(response.data);
        return updatedUser.toEntity();
      } else {
        throw Exception("Failed to update user: ${response.data['message']}");
      }
    } catch (e) {
      print("Error in updateUser: $e");
      rethrow;
    }
  }
}
