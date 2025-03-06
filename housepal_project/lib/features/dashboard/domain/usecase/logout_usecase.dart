import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.logoutUser();
  }
}
