import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // If there's no token, throw an exception or handle accordingly
      if (token == null || token.isEmpty) {
        return Left(ApiFailure(message: "No authentication token found"));
      }

      final currentUser = await _authLocalDataSource.getCurrentUser(token);
      return Right(currentUser); // Return user entity wrapped in Right
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    try {
      // 🔄 Fetch result from local data source
      final result = await _authLocalDataSource.loginUser(email, password);

      print("🔍 AuthLocalDataSource Result: $result"); // Debugging line

      if (result == "Seeker" || result == "Helper") {
        print("✅ Login success: Role = $result");
        return Right(result);
      } else {
        print("❌ Login failed: Invalid credentials");
        return Left(LocalDatabaseFailure(message: "Invalid credentials"));
      }
    } catch (e) {
      print("🚨 Exception during login: $e");
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      await _authLocalDataSource.registerUser(user);
      return const Right(null); // Registration successful
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString())); // Handle errors
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(
      File file, String role, String email) async {
    try {
      final result =
          await _authLocalDataSource.uploadProfilePicture(file, role, email);
      return Right(result); // Return the result (URL or response)
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString())); // Handle errors
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateUser(
      AuthEntity user, String token) async {
    try {
      final updatedUser = await _authLocalDataSource.updateUser(user, token);
      return Right(updatedUser); // Return the updated user
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString())); // Handle errors
    }
  }
}
