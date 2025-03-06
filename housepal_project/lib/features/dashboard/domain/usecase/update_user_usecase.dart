import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';

class UpdateUserUseCase {
  final AuthRemoteRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call(AuthEntity user) async {
    return await repository.updateUser(user);
  }
}
