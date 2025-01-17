import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmpassword;
  final String role; // Role can be Seeker or Helper
  final List? skills;
  final String? experience; // Only for Helper

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmpassword,
    required this.role,
    this.skills,
    this.experience,
  });

  @override
  List<Object?> get props => [
        userId,
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
