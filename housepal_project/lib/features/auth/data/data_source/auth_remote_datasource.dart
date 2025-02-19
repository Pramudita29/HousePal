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
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = AuthApiModel.fromJson(response.data);
        return data.toEntity();
      } else {
        throw Exception("Failed to fetch user data");
      }
    } catch (e) {
      print("Error in getCurrentUser: $e");
      rethrow;
    }
  }


  @override
  Future<String> loginUser(String email, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      // Print the API Response
      print("Login API Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        String? token = response.data['token'];

        if (token == null || token.isEmpty) {
          throw Exception("Login failed: Token is missing in response");
        }

        // Access the user data from the 'user' field
        var user = response.data['user'];

        // Ensure user data is available
        if (user == null) {
          throw Exception("Login failed: User data is missing in response");
        }

        // Validate and format the image URL
        String? image = user['image'] ?? '';
        if (image != null && !image.startsWith('http')) {
          image = ''; // No valid image URL, use initials instead
        }

        // Save the token and user details in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('posterFullName', user['fullName'] ?? '');
        await prefs.setString('posterEmail', user['email'] ?? '');

        // Print the saved token and user details
        print("Token and user details saved successfully!");

        return token;
      } else {
        throw Exception("Login failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Login error: ${e.response?.data ?? e.message}");
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
          "contactNo": user.contactNo,
          "password": user.password,
          "confirmPassword": user.password,
          "role": user.role,
          "skills": user.skills,
          "image": user.image,
          "experience": user.experience,
        },
      );

      if (response.statusCode != 201) {
        throw Exception("Registration failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Registration error: ${e.message}");
    }
  }

  @override
  Future<String> uploadProfilePicture(
      File file, String role, String email) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: fileName),
        'email': email,
        'role': role,
      });

      String endpoint = role == 'Helper'
          ? ApiEndpoints.uploadHelperImage
          : ApiEndpoints.uploadSeekerImage;

      // Send the image upload request to the server
      Response response = await _dio.post(endpoint, data: formData);

      if (response.statusCode == 200 && response.data['imageUrl'] != null) {
        String imageUrl = response.data['imageUrl'];

        // Ensure the URL is fully qualified
        if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
          return imageUrl; // Return the full URL if it's already correct
        } else {
          // Prepend the base URL if the server only returns a relative path
          final baseUrl =
              ApiEndpoints.baseUrl; // Example: 'http://yourserver.com'
          return '$baseUrl$imageUrl'; // Concatenate base URL with the image path
        }
      } else {
        throw Exception(response.data['message'] ?? "Image upload failed");
      }
    } on DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? e.message ?? "Unknown error occurred";
      print('Error during image upload: $errorMessage');
      throw Exception("Error during image upload: $errorMessage");
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<AuthEntity> updateUser(AuthEntity user, String token) async {
    try {
      // Determine the endpoint based on the user's role
      String endpoint;
      if (user.role == 'Helper') {
        endpoint = ApiEndpoints.updateHelper(user.userId ?? '');
      } else if (user.role == 'Seeker') {
        endpoint = ApiEndpoints.updateSeeker(user.userId ?? '');
      } else {
        throw Exception("Invalid user role");
      }

      final response = await _dio.put(
        endpoint,
        data: {
          "fullName": user.fullName,
          "email": user.email,
          "contactNo": user.contactNo,
          "skills": user.skills,
          "image": user.image,
          "experience": user.experience,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final updatedUser = AuthApiModel.fromJson(response.data);
        return updatedUser.toEntity();
      } else {
        throw Exception("Failed to update user");
      }
    } catch (e) {
      print("Error in updateUser: $e");
      rethrow;
    }
  }
}
