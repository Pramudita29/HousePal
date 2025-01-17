part of 'login_bloc.dart';
 
sealed class LoginEvent extends Equatable {
  const LoginEvent();
 
  @override
  List<Object?> get props => [];
}
 
class NavigateRegisterScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;
 
  const NavigateRegisterScreenEvent({
    required this.context,
    required this.destination,
  });
 
  @override
  List<Object?> get props => [context, destination];
}
 
class NavigateHomeScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;
 
  const NavigateHomeScreenEvent({
    required this.context,
    required this.destination,
  });
 
  @override
  List<Object?> get props => [context, destination];
}
 
class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;
 
  const LoginUserEvent({
    required this.email,
    required this.password,
    required this.context,
  });
 
  @override
  List<Object?> get props => [email, password, context];
}