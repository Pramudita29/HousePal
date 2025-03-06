import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class GetUserUseCase {
  final IAuthRepository repository;

  GetUserUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
