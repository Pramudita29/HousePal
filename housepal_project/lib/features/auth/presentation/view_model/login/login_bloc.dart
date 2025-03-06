import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/helper_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/seeker_dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUserUseCase;

  LoginBloc({required LoginUseCase loginUserUseCase})
      : _loginUserUseCase = loginUserUseCase,
        super(LoginState.initial()) {
    on<LoginUserEvent>(_onLoginUserEvent);
  }

  Future<void> _onLoginUserEvent(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    final result = await _loginUserUseCase(
        LoginParams(email: event.email, password: event.password));

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (token) async {
        final prefs = await SharedPreferences.getInstance();
        final role = prefs.getString('role');
        emit(state.copyWith(isLoading: false, isSuccess: true, role: role));

        // Perform navigation synchronously within the async handler
        if (role == "Seeker") {
          await Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
                builder: (context) => const SeekerDashboardView()),
          );
        } else if (role == "Helper") {
          await Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
                builder: (context) => const HelperDashboardView()),
          );
        } else {
          showMySnackBar(
            context: event.context,
            message: "Unknown role: $role",
            color: Colors.red,
          );
        }
      },
    );
  }
}
