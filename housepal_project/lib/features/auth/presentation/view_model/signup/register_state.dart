part of 'register_bloc.dart';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final String? imageName;

  RegisterState({
    required this.isLoading,
    required this.isSuccess,
    required this.errorMessage,
    this.imageName,
  });

  RegisterState.initial()
      : isLoading = false,
        isSuccess = false,
        errorMessage = '',
        imageName = null;

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? imageName,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      imageName: imageName??this.imageName,
    );
  }
}
