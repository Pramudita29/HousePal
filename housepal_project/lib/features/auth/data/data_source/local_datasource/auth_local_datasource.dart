import 'dart:io';

import 'package:housepal_project/core/network/hive_service.dart';
import 'package:housepal_project/features/auth/data/data_source/auth_datasource.dart';
import 'package:housepal_project/features/auth/data/model/auth_hive_model.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser(String token) async {
    try {
      final user = await _hiveService.getCurrentUser();

      if (user == null) {
        throw Exception("No user found in local storage");
      }

      return AuthEntity(
        userId: user.userId,
        fullName: user.fullName,
        email: user.email,
        contactNo: user.contactNo,
        password: user.password,
        confirmPassword: user.confirmPassword,
        role: user.role,
        skills: user.skills,
        experience: user.experience,
      );
    } catch (e) {
      return Future.error("Error retrieving user: ${e.toString()}");
    }
  }

  @override
  Future<AuthEntity> updateUser(AuthEntity user, String token) async {
    try {
      final existingUser = await _hiveService.getCurrentUser();

      if (existingUser == null) {
        throw Exception("No user found to update");
      }

      final updatedUser = AuthHiveModel(
        userId: existingUser.userId,
        fullName:
            user.fullName.isNotEmpty ? user.fullName : existingUser.fullName,
        email: user.email.isNotEmpty ? user.email : existingUser.email,
        contactNo:
            user.contactNo.isNotEmpty ? user.contactNo : existingUser.contactNo,
        password: existingUser.password, // Preserve the existing password
        confirmPassword: existingUser.confirmPassword,
        role: existingUser.role,
        skills: (user.skills != null && user.skills!.isNotEmpty)
            ? user.skills?.cast<String>()
            : existingUser.skills,
        experience: user.experience?.isNotEmpty == true
            ? user.experience
            : existingUser.experience,
      );

      // Persist updated user
      await _hiveService.updateUser(updatedUser);

      // Convert the updated AuthHiveModel back to AuthEntity
      return AuthEntity(
        userId: updatedUser.userId,
        fullName: updatedUser.fullName,
        email: updatedUser.email,
        contactNo: updatedUser.contactNo,
        password: updatedUser.password,
        confirmPassword: updatedUser.confirmPassword,
        role: updatedUser.role,
        skills: updatedUser.skills,
        experience: updatedUser.experience,
      );
    } catch (e) {
      return Future.error("Error updating user: ${e.toString()}");
    }
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final user = await _hiveService.login(email, password);

      if (user != null) {
        return user.role; // Return the role (Seeker or Helper)
      } else {
        return Future.error("Invalid credentials");
      }
    } catch (e) {
      return Future.error("Login error: ${e.toString()}");
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      final authHiveModel = AuthHiveModel.fromEntity(user);
      await _hiveService.register(authHiveModel);
    } catch (e) {
      return Future.error("Registration error: ${e.toString()}");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file, String role, String email) {
    throw UnimplementedError();
  }
}
