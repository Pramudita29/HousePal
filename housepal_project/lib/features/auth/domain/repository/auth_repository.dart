import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepository {
  /// Registers a new user with the provided details.
  Future<Either<Failure, void>> registerUser(AuthEntity user);

  /// Logs in a user with the given email and password, returning a token on success.
  Future<Either<Failure, String>> loginUser(String email, String password);

  /// Uploads a profile picture for the user identified by email and role.
  Future<Either<Failure, String>> uploadProfilePicture(
      File file, String role, String email);

  /// Retrieves the currently authenticated user's details.
  Future<Either<Failure, AuthEntity>> getCurrentUser();

  /// Updates the authenticated user's details.
  Future<Either<Failure, AuthEntity>> updateUser(AuthEntity user);

  /// Logs out the current user, invalidating their session.
  Future<Either<Failure, void>> logoutUser(); // Added for completeness
}
