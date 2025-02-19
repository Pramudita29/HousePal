part of 'register_bloc.dart';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  RegisterState({
    required this.isLoading,
    required this.isSuccess,
    required this.errorMessage,
  });

  RegisterState.initial()
      : isLoading = false,
        isSuccess = false,
        errorMessage = '';

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
