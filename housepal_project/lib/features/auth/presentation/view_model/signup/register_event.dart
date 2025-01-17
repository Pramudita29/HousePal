part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmpassword;
  final String role; // Seeker or Helper
  final List? skills; // Required for Helper
  final String? experience; // Required for Helper

  const RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmpassword,
    required this.role,
    this.skills, // For Helper
    this.experience, // For Helper
  });
}
