import 'dart:io';

import 'package:housepal_project/core/network/hive_service.dart';
import 'package:housepal_project/features/auth/data/data_source/auth_datasource.dart';
import 'package:housepal_project/features/auth/data/model/auth_hive_model.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser() {
    // Return Empty AuthEntity
    return Future.value(AuthEntity(
        userId: "1",
        fullName: "",
        email: "",
        contactNo: "",
        password: "",
        confirmPassword: "",
        role: "",
        skills: [],
        image:"",
        experience: ""));
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      // Try to log in the user and retrieve their role
      final user = await _hiveService.login(email, password);

      // Null check before accessing user.role
      if (user != null) {
        // Return the role of the user, which will be used for navigation
        return user.role; // Return the role (Seeker or Helper)
      } else {
        // Handle case where user is null (e.g., invalid credentials)
        return Future.error("Invalid credentials");
      }
    } catch (e) {
      return Future.error(e); // Handle error and propagate
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      // Convert AuthEntity to AuthHiveModel
      final authHiveModel = AuthHiveModel.fromEntity(user);

      await _hiveService.register(authHiveModel);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file, String role, String email) {
    throw UnimplementedError();
  }
}
