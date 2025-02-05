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
  final String contactNo;
  final String password;
  final String confirmpassword;
  final String role; // Seeker or Helper
  final List? skills; // Required for Helper
  final String? image;
  final String? experience; // Required for Helper

  const RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.confirmpassword,
    required this.role,
    this.skills,
    this.image, // For Helper
    this.experience, // For Helper
  });

  @override
  List<Object> get props => [
        context,
        fullName,
        email,
        contactNo,
        password,
        confirmpassword,
        role,
        skills ?? [],
        image ?? "",
        experience ?? ""
      ];
}

// Add the new UploadProfileImageEvent class here
class UploadProfileImageEvent extends RegisterEvent {
  final File image;
  final String role;
  final String email;
  final BuildContext context; // Add context property

  const UploadProfileImageEvent({
    required this.image,
    required this.role,
    required this.email,
    required this.context, // Pass context in the constructor
  });

  @override
  List<Object> get props => [image, role, email, context]; // Add context to props
}
