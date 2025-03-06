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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return Left(
            SharedPrefsFailure(message: "No authentication token found"));
      }
      final user = await _authRemoteDataSource.getCurrentUser(token);
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to fetch user data: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    try {
      final token = await _authRemoteDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst("Exception: ", "")));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      await _authRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst("Exception: ", "")));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(
      File file, String role, String email) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return Left(
            SharedPrefsFailure(message: "No authentication token found"));
      }
      final imageUrl =
          await _authRemoteDataSource.uploadProfilePicture(file, role, email);
      return Right(imageUrl);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst("Exception: ", "")));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateUser(AuthEntity user) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return Left(
            SharedPrefsFailure(message: "No authentication token found"));
      }
      final updatedUser = await _authRemoteDataSource.updateUser(user, token);
      await _saveUserData(updatedUser);
      return Right(updatedUser);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst("Exception: ", "")));
    }
  }

  Future<void> _saveUserData(AuthEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.userId ?? '');
    await prefs.setString('fullName', user.fullName);
    await prefs.setString('email', user.email);
    await prefs.setString('contactNo', user.contactNo);
    await prefs.setString('role', user.role);
    if (user.role == 'Helper') {
      await prefs.setStringList('skills', user.skills?.cast<String>() ?? []);
      await prefs.setString('experience', user.experience ?? '');
    }
    print("User data saved successfully");
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return const Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: "Failed to logout: $e"));
    }
  }
}
