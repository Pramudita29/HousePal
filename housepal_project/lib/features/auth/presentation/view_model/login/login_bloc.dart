import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/helper_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/seeker_dashboard_view.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc _registerBloc;
  final LoginUseCase _loginUserUseCase;

  LoginBloc({
    required RegisterBloc registerBloc,
    required LoginUseCase loginUserUseCase,
  })  : _registerBloc = registerBloc,
        _loginUserUseCase = loginUserUseCase,
        super(LoginState.initial()) {
    on<NavigateRegisterScreenEvent>(_onNavigateRegisterScreen);
    on<LoginUserEvent>(_onLoginUserEvent);
  }

  // Navigates to the Registration screen
  void _onNavigateRegisterScreen(
    NavigateRegisterScreenEvent event,
    Emitter<LoginState> emit,
  ) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _registerBloc,
          child: event.destination,
        ),
      ),
    );
  }

  // Handles the login process and role-based redirection
  Future<void> _onLoginUserEvent(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loginUserUseCase(
        LoginParams(email: event.email, password: event.password));

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        // showMySnackBar(
        //   context: event.context,
        //   message: "",
        //   color: Colors.red,
        // );
      },
      (role) {
        print("Login successful with role: $role");

        emit(state.copyWith(isLoading: false, isSuccess: true));

        // Handle the user role and navigate accordingly
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
          showMySnackBar(
            context: event.context,
            message: "Invalid User Role",
            color: Colors.red,
          );
        }
      },
    );
  }
}
