import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class UploadImageParams extends Equatable {
  final File file;
  final String email;
  final String role;
  final String? token; // Add this

  const UploadImageParams({
    required this.file,
    required this.email,
    required this.role,
    this.token,
  });

  @override
  List<Object?> get props => [file, email, role, token];
}

class UploadImageUsecase {
  final IAuthRepository repository;

  UploadImageUsecase(this.repository);

  Future<Either<Failure, String>> call(UploadImageParams params) async {
    return await repository.uploadProfilePicture(
        params.file, params.role, params.email);
    // Note: If your backend needs the token, ensure AuthRemoteDataSource uses it
  }
}
