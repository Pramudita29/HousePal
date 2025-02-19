import 'dart:io';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';

abstract class IAuthDataSource {
  Future<String> loginUser(String email, String password);
  Future<void> registerUser(AuthEntity user);
  Future<AuthEntity> getCurrentUser(String token);
  Future<AuthEntity> updateUser(AuthEntity user, String token);
  Future<String> uploadProfilePicture(File file, String role, String email);
}

