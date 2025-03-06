import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:housepal_project/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() async {
    mockLoginUseCase = MockLoginUseCase();
    mockNavigatorObserver = MockNavigatorObserver();
    loginBloc = LoginBloc(loginUserUseCase: mockLoginUseCase);
    SharedPreferences.setMockInitialValues({'role': 'Seeker'});
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    const tToken = 'valid_token';
    final tContext = _buildTestContext(mockNavigatorObserver);

    blocTest<LoginBloc, LoginState>(
      'emits [loading, success] and navigates on successful login',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Right(tToken));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginUserEvent(
          email: tEmail, password: tPassword, context: tContext)),
      expect: () => [
        const LoginState(isLoading: true),
        const LoginState(isLoading: false, isSuccess: true, role: 'Seeker'),
      ],
      verify: (_) {
        verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading, failure] on login failure',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Login failed')));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginUserEvent(
          email: tEmail, password: tPassword, context: tContext)),
      expect: () => [
        const LoginState(isLoading: true),
        const LoginState(isLoading: false, isSuccess: false),
      ],
    );
  });
}

BuildContext _buildTestContext(NavigatorObserver observer) {
  return Navigator(
    observers: [observer],
    onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => Container()),
  ).createState().context;
}
