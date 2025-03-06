import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late RegisterBloc registerBloc;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerBloc = RegisterBloc(registerUserUseCase: mockRegisterUseCase);
  });

  tearDown(() {
    registerBloc.close();
  });

  group('RegisterBloc', () {
    const tEvent = RegisterUserEvent(
      fullName: 'John Doe',
      email: 'test@example.com',
      contactNo: '1234567890',
      password: 'password',
      confirmPassword: 'password',
      role: 'user',
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [loading, success] on successful registration',
      build: () {
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return registerBloc;
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(isLoading: false, isSuccess: true),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [loading, failure] on registration failure',
      build: () {
        when(() => mockRegisterUseCase(any())).thenAnswer(
            (_) async => Left(ApiFailure(message: 'Register failed')));
        return registerBloc;
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'Register failed'),
      ],
    );
  });
}
