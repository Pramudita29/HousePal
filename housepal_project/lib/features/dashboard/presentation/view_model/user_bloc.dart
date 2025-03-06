import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/get_user_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/logout_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/update_user_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/upload_image_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final UploadImageUsecase _uploadImageUsecase;
  final LogoutUseCase _logoutUseCase;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserBloc({
    required GetUserUseCase getUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required UploadImageUsecase uploadImageUsecase,
    required LogoutUseCase logoutUseCase,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _getUserUseCase = getUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        _logoutUseCase = logoutUseCase,
        _tokenSharedPrefs = tokenSharedPrefs,
        super(UserState.initial()) {
    on<FetchUserEvent>(_onFetchUserEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<UploadProfileImageEvent>(_onUploadProfileImageEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onFetchUserEvent(
      FetchUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tokenResult = await _tokenSharedPrefs.getToken();
    String? token = tokenResult.fold((failure) => null, (token) => token);
    if (token == null) {
      print('No token found in shared prefs');
      emit(state.copyWith(
          isLoading: false, errorMessage: 'No authentication token found'));
      return;
    }
    print('Fetching current user with token: $token');
    int retries = 2;
    String? lastError;

    for (int i = 0; i <= retries; i++) {
      final result = await _getUserUseCase.call();
      final userOrError = result.fold(
        (failure) {
          print('Fetch attempt ${i + 1} failed: ${failure.message}');
          lastError = failure.message;
          return null;
        },
        (user) => user,
      );

      if (userOrError != null) {
        print(
            'User fetched successfully: email=${userOrError.email}, fullName=${userOrError.fullName}, image=${userOrError.image}');
        emit(state.copyWith(
          isLoading: false,
          user: userOrError,
          originalImageUrl: userOrError.image,
          imageName: userOrError.image?.split('/').last ?? '',
          errorMessage: '',
        ));
        return;
      }

      if (i < retries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    emit(state.copyWith(
      isLoading: false,
      errorMessage: lastError ?? 'Failed to fetch user after retries',
    ));
  }

  Future<void> _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _updateUserUseCase.call(event.updatedUser);
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          user: user,
          errorMessage: '',
        ));
      },
    );
  }

  Future<void> _onUploadProfileImageEvent(
      UploadProfileImageEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    print('Uploading image for email: ${event.email}, role: ${event.role}');
    final tokenResult = await _tokenSharedPrefs.getToken();
    String? token;
    tokenResult.fold(
      (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get token: ${failure.message}')),
      (tokenValue) => token = tokenValue,
    );
    if (token == null) return;

    final result = await _uploadImageUsecase(UploadImageParams(
      file: event.image,
      email: event.email,
      role: event.role,
      token: token,
    ));
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (imageUrl) => emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        imageName: imageUrl.split('/').last,
        originalImageUrl: imageUrl,
        errorMessage: '',
      )),
    );
    add(const FetchUserEvent(''));
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _logoutUseCase.call();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          user: null, // Clear user on logout
          originalImageUrl: null,
          imageName: '',
          errorMessage: '',
        ));
        // Navigation moved to the listener in the views
      },
    );
  }
}
