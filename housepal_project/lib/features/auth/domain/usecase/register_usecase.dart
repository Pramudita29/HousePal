import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/usecase/usecase.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmpassword;
  final String role; // Role can be Seeker or Helper
  final List? skills; // Only for Helper
  final String? experience; // Only for Helper

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmpassword,
    required this.role,
    this.skills,
    this.experience,
  });

  // Initial constructor for default state
  const RegisterUserParams.initial()
      : fullName = '',
        email = '',
        phone = '',
        password = '',
        confirmpassword = '',
        role = '',
        skills = null,
        experience = null;

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        password,
        confirmpassword,
        role,
        skills,
        experience,
      ];
}

class RegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    final authEntity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      confirmpassword: params.confirmpassword,
      role: params.role,
      skills: params.skills,
      experience: params.experience,
    );

    // Call the repository to register the user
    return repository.registerUser(authEntity);
  }
}
