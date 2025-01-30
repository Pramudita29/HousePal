import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/helper_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/seeker_dashboard_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUserUseCase;

  LoginBloc({
    required RegisterBloc registerBloc,
    required LoginUseCase loginUserUseCase,
  })  : _loginUserUseCase = loginUserUseCase,
        super(LoginState.initial()) {
    on<LoginUserEvent>(_onLoginUserEvent);
  }

  // Handles the login process and role-based redirection
  Future<void> _onLoginUserEvent(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    print("LoginUserEvent triggered for email: ${event.email}");

    // Prevent duplicate login attempts
    if (state.isLoading) {
      print("Already processing login, ignoring duplicate request.");
      return;
    }

    emit(state.copyWith(isLoading: true)); // Show loading state
    print("State updated: isLoading = ${state.isLoading}");

    final result = await _loginUserUseCase(
        LoginParams(email: event.email, password: event.password));

    print("API call completed, processing result...");

    result.fold(
      (failure) {
        print('Login failed: ${failure.message}');
        emit(state.copyWith(isLoading: false, isSuccess: false, role: null));

        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (token) {
        // Token received, now decode it to get the role
        try {
          print("Token received: $token");

          // Decode the token to extract the role
          final decodedToken = JwtDecoder.decode(token);
          final role =
              decodedToken['role']; // Assuming 'role' is part of the payload

          print("Extracted role: $role");

          emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            role: role, // Store the extracted role
          ));

          print(
              "🛠 Final state update: isSuccess = ${state.isSuccess}, role = ${state.role}");

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (role == "Seeker") {
              Navigator.pushReplacement(
                event.context,
                MaterialPageRoute(
                    builder: (context) => const SeekerDashboardView()),
              );
            } else if (role == "Helper") {
              Navigator.pushReplacement(
                event.context,
                MaterialPageRoute(
                    builder: (context) => const HelperDashboardView()),
              );
            } else {
              print("Unexpected role: $role");
              showMySnackBar(
                context: event.context,
                message: "Unexpected Role: $role",
                color: Colors.red,
              );
            }
          });
        } catch (e) {
          print(' Error decoding token: $e');
          emit(state.copyWith(isLoading: false, isSuccess: false, role: null));
          showMySnackBar(
            context: event.context,
            message: "Failed to decode token.",
            color: Colors.red,
          );
        }
      },
    );
  }
}
