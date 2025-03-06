// In user_state.dart
part of 'user_bloc.dart';

class UserState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final String imageName;
  final AuthEntity? user;
  final String? originalImageUrl;

  const UserState({
    required this.isLoading,
    required this.isSuccess,
    required this.errorMessage,
    required this.imageName,
    this.user,
    this.originalImageUrl,
  });

  factory UserState.initial() => const UserState(
        isLoading: false,
        isSuccess: false,
        errorMessage: '',
        imageName: '',
        user: null,
        originalImageUrl: null,
      );

  UserState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? imageName,
    AuthEntity? user,
    String? originalImageUrl,
  }) =>
      UserState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        errorMessage: errorMessage ?? this.errorMessage,
        imageName: imageName ?? this.imageName,
        user: user ?? this.user,
        originalImageUrl: originalImageUrl ?? this.originalImageUrl,
      );

  @override
  List<Object?> get props =>
      [isLoading, isSuccess, errorMessage, imageName, user, originalImageUrl];
}
