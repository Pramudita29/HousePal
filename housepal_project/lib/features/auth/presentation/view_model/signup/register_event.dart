part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

// Event for registering the user
class RegisterUserEvent extends RegisterEvent {
  final String fullName;
  final String email;
  final String contactNo;
  final String password;
  final String confirmPassword;
  final String role;
  final List<String>? skills;
  final String? image;
  final String? experience;

  const RegisterUserEvent({
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.confirmPassword,
    required this.role,
    this.skills,
    this.image,
    this.experience,
  });

  @override
  List<Object> get props => [
        fullName,
        email,
        contactNo,
        password,
        confirmPassword,
        role,
        skills ?? [],
        image ?? '',
        experience ?? ''
      ];
}
