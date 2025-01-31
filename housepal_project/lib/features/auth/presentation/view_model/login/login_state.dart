// part of 'login_bloc.dart';

// class LoginState {
//   final bool isLoading;
//   final bool isSuccess;
//   final String? role;

//   LoginState({
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.role,
//   });

//   // ✅ Factory constructor to create an initial state
//   factory LoginState.initial() {
//     return LoginState(
//       isLoading: false,
//       isSuccess: false,
//       role: null,
//     );
//   }

//   LoginState copyWith({
//     bool? isLoading,
//     bool? isSuccess,
//     String? role,
//   }) {
//     return LoginState(
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       role: role ?? this.role,
//     );
//   }
// }
part of 'login_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? role;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.role,
  });

  LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        role = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? role,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      role: role ?? this.role,
    );
  }
}
