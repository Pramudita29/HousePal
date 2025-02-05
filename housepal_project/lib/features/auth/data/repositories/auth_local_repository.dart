import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      return Right(currentUser);
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
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file, String role, String email) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
