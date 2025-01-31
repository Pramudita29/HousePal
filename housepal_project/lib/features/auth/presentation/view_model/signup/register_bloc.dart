import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/upload_image_usecase.dart'; // Import the new UploadImageUsecase

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUserUseCase;
  final UploadImageUsecase _uploadImageUsecase; // Add the use case for uploading the image

  RegisterBloc({
    required RegisterUseCase registerUserUseCase,
    required UploadImageUsecase uploadImageUsecase, // Add the new use case in constructor
  })  : _registerUserUseCase = registerUserUseCase,
        _uploadImageUsecase = uploadImageUsecase, // Initialize the use case
        super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterEvent);
    on<UploadProfileImageEvent>(_onUploadProfileImageEvent); // Handle image upload event
  }

  // Handle the image upload event
  void _onUploadProfileImageEvent(
      UploadProfileImageEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _uploadImageUsecase(
      UploadImageParams(file: event.image, role: event.role, email: event.email),
    );

    result.fold(
      (l) {
        // emit(state.copyWith(isLoading: false, errorMessage: l.message));
        // showMySnackBar(
        //   context: event.context,
        //   message: "Image upload failed: ${l.message}",
        //   color: Colors.red,
        // );
      },
      (r) {
        emit(state.copyWith(isLoading: false, imageName: r));
        showMySnackBar(
          context: event.context,
          message: "Image uploaded successfully",
          color: Colors.green,
        );
      },
    );
  }

  // Handle the registration event
  void _onRegisterEvent(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _registerUserUseCase(
      RegisterUserParams(
        fullName: event.fullName,
        email: event.email,
        contactNo: event.contactNo,
        password: event.password,
        confirmPassword: event.confirmpassword,
        role: event.role,
        skills: event.skills,
        image: event.image,
        experience: event.experience,
      ),
    );

    result.fold(
      (l) {
        emit(state.copyWith(
            isLoading: false, isSuccess: false, errorMessage: l.message));
        showMySnackBar(
          context: event.context,
          message: "Registration failed: ${l.message}",
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
          color: Colors.green,
        );
      },
    );
  }
}
