import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/app/usecase/usecase.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : email = '',
        password = '';

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) {
    // Save token in Shared Preferences after successful login
    return repository
        .loginUser(
            params.email, params.password) // Use loginUser for the API request
        .then((value) {
      return value.fold(
        (failure) => Left(failure),
        (token) {
          tokenSharedPrefs.saveToken(token); // Save token to SharedPreferences
          tokenSharedPrefs.getToken().then((savedToken) {
            print(savedToken); // Print saved token
          });
          return Right(token); // Return token wrapped in Right
        },
      );
    });
  }
}
