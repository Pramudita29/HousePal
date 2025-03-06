part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? role;
  final String? errorMessage; // Added errorMessage field

  const LoginState({
    required this.isLoading,
    this.isSuccess = false,
    this.role,
    this.errorMessage,
  });

  factory LoginState.initial() => const LoginState(isLoading: false);

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? role,
    String? errorMessage,
  }) =>
      LoginState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        role: role ?? this.role,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [isLoading, isSuccess, role, errorMessage];
}
