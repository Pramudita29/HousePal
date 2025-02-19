import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/usecase/usecase.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String contactNo;
  final String password;
  final String confirmPassword;
  final String role;
  final List? skills;
  final String? image; // Non-nullable, defaults to empty string
  final String? experience; // Non-nullable, defaults to empty string

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.confirmPassword,
    required this.role,
    this.skills,
    this.image, // Default to empty string if not provided
    this.experience , // Default to empty string if not provided
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        contactNo,
        password,
        confirmPassword,
        role,
        skills, // Provide an empty list as fallback for skills
        image, // Will never be null now
        experience, // Will never be null now
      ];
}

class RegisterUseCase implements UsecaseWithParams<void, AuthEntity> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AuthEntity params) async {
    final authEntity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      contactNo: params.contactNo,
      password: params.password,
      confirmPassword: params.confirmPassword,
      role: params.role,
      skills: params.skills,
      experience: params.experience,
    );

    // Call the repository to register the user
    return repository.registerUser(params);
  }
}
