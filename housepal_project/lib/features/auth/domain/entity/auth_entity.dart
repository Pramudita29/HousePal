import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String contactNo;
  final String password;
  final String confirmPassword;
  final String role; // Role can be Seeker or Helper
  final List? skills;
  final String? image;
  final String? experience; // Only for Helper

  const AuthEntity({
    this.userId,
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
  List<Object?> get props => [
        userId,
        fullName,
        email,
        contactNo,
        password,
        confirmPassword,
        role,
        skills,
        image,
        experience,
      ];
}
