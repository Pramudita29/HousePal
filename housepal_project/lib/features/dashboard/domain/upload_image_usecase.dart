import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:housepal_project/app/usecase/usecase.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class UploadImageParams {
  final File file;
  final String role;
  final String email;

  const UploadImageParams({
    required this.file,
    required this.role,
    required this.email,
  });
}

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final IAuthRepository _repository;

  UploadImageUsecase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return _repository.uploadProfilePicture(
        params.file, params.role, params.email);
  }
}
