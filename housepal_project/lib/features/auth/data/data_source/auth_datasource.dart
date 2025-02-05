import 'dart:io';

import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';


abstract interface class IAuthDataSource {
  Future<String> loginUser(String email, String password);

  Future<void> registerUser(AuthEntity user);

  Future<AuthEntity> getCurrentUser();

  Future<String> uploadProfilePicture(File file, String role, String email);
}
