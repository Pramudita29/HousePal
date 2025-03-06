import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/get_user_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/logout_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/update_user_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/upload_image_usecase.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late UserBloc userBloc;
  late MockGetUserUseCase mockGetUserUseCase;
  late MockUpdateUserUseCase mockUpdateUserUseCase;
  late MockUploadImageUsecase mockUploadImageUsecase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    mockUploadImageUsecase = MockUploadImageUsecase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    userBloc = UserBloc(
      getUserUseCase: mockGetUserUseCase,
      updateUserUseCase: mockUpdateUserUseCase,
      uploadImageUsecase: mockUploadImageUsecase,
      logoutUseCase: mockLogoutUseCase,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
    registerFallbackValue(AuthEntity(
        fullName: '',
        email: '',
        contactNo: '',
        password: '',
        confirmPassword: '',
        role: ''));
    registerFallbackValue(File(''));
  });

  tearDown(() {
    userBloc.close();
  });

  group('UserBloc', () {
    final tUser = AuthEntity(
      fullName: 'John Doe',
      email: 'test@example.com',
      contactNo: '1234567890',
      password: 'password',
      confirmPassword: 'password',
      role: 'user',
    );

    blocTest<UserBloc, UserState>(
      'emits [loading, success] on fetch user success',
      build: () {
        when(() => mockTokenSharedPrefs.getToken())
            .thenAnswer((_) async => const Right('token'));
        when(() => mockGetUserUseCase()).thenAnswer((_) async => Right(tUser));
        return userBloc;
      },
      act: (bloc) => bloc.add(const FetchUserEvent('')),
      expect: () => [
        UserState.initial().copyWith(isLoading: true),
        UserState.initial().copyWith(
            isLoading: false,
            user: tUser,
            originalImageUrl: tUser.image,
            imageName: ''),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [loading, upload success] on upload image success',
      build: () {
        when(() => mockTokenSharedPrefs.getToken())
            .thenAnswer((_) async => const Right('token'));
        when(() => mockUploadImageUsecase(any())).thenAnswer(
            (_) async => const Right('https://example.com/image.jpg'));
        when(() => mockGetUserUseCase()).thenAnswer((_) async => Right(tUser));
        return userBloc;
      },
      act: (bloc) => bloc.add(UploadProfileImageEvent(
          image: File('test.jpg'), email: 'test@example.com', role: 'user')),
      expect: () => [
        UserState.initial().copyWith(isLoading: true),
        UserState.initial().copyWith(
            isLoading: false,
            isSuccess: true,
            imageName: 'image.jpg',
            originalImageUrl: 'https://example.com/image.jpg'),
        UserState.initial().copyWith(
            isLoading: false,
            user: tUser,
            originalImageUrl: tUser.image,
            imageName: ''),
      ],
    );
  });
}
