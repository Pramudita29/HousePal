class AuthEntity {
  final String? userId;
  final String fullName;
  final String email;
  final String contactNo;
  final String password;
  final String role;
  final List<String>? skills;
  final String? experience;
  final String? image;
  final String confirmPassword;

  AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.role,
    this.skills,
    this.experience,
    this.image,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'contactNo': contactNo,
      'password': password,
      'role': role,
      'skills': skills,
      'experience': experience,
      'image': image,
      'confirmPassword': confirmPassword,
    };
  }
}
