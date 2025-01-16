import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUserUseCase;

  RegisterBloc({
    required RegisterUseCase registerUserUseCase,
  })  : _registerUserUseCase = registerUserUseCase,
        super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterEvent);
  }

  void _onRegisterEvent(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _registerUserUseCase(
      RegisterUserParams(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        password: event.password,
        confirmpassword: event.confirmpassword,
        role: event.role,
        skills: event.skills, // Pass the skills if present
        experience: event.experience, // Pass the experience if present
      ),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }
}
