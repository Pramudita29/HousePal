part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class FetchUserEvent extends UserEvent {
  const FetchUserEvent(String email); // Email unused
}

class UpdateUserEvent extends UserEvent {
  final AuthEntity updatedUser;
  const UpdateUserEvent(this.updatedUser);
  @override
  List<Object?> get props => [updatedUser];
}

class UploadProfileImageEvent extends UserEvent {
  final File image;
  final String email;
  final String role;
  const UploadProfileImageEvent({
    required this.image,
    required this.email,
    required this.role,
  });
  @override
  List<Object?> get props => [image, email, role];
}

class LogoutEvent extends UserEvent {
  final BuildContext context;
  const LogoutEvent(this.context);
  @override
  List<Object?> get props => [context];
}
