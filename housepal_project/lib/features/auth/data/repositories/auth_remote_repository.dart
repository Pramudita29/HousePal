import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      // Retrieve the stored token and role from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final role = prefs
          .getString('role'); // Assuming role is stored in SharedPreferences

      if (token == null || token.isEmpty) {
        return Left(ApiFailure(message: "No authentication token found"));
      }

      if (role == null || role.isEmpty) {
        return Left(ApiFailure(message: "No user role found"));
      }

      // Call the appropriate method based on the user's role
      final user = role == 'Helper'
          ? await _authRemoteDataSource.getCurrentHelper(token)
          : role == 'Seeker'
              ? await _authRemoteDataSource.getCurrentSeeker(token)
              : throw Exception("Invalid user role");

      return Right(user); // Return the user entity
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    try {
      // Login the user
      final token = await _authRemoteDataSource.loginUser(email, password);
      return Right(token); // Return the JWT token
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      // Register user via the remote data source
      await _authRemoteDataSource.registerUser(user);
      return const Right(null); // Return success if registration is successful
    } catch (e) {
      return Left(ApiFailure(
          message: e.toString())); // Return error if registration fails
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(
      File file, String role, String email) async {
    try {
      // Upload profile picture via the remote data source, passing the role and email
      final imageName = await _authRemoteDataSource.uploadProfilePicture(
          file, role, email);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
