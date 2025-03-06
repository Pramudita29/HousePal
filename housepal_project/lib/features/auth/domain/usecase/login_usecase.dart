import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/usecase/usecase.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  const LoginParams.initial() : email = '', password = '';

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await repository.loginUser(params.email, params.password).then(
      (result) async => result.fold(
        (failure) => Left(failure),
        (token) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          // Role is already saved in AuthRemoteDataSource, no need to decode here
          return Right(token);
        },
      ),
    );
  }
}