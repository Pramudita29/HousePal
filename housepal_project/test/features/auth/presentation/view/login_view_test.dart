import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/auth/presentation/view/login_view.dart';
import 'package:housepal_project/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: const LoginView(),
      ),
    );
  }

  testWidgets('shows loading indicator when login is in progress', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState(isLoading: true));
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('triggers login event on button tap with valid input', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState(isLoading: false));
    await tester.pumpWidget(buildTestWidget());

    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pump();

    verify(() => mockLoginBloc.add(LoginUserEvent(
          email: 'test@example.com',
          password: 'password',
          context: any(named: 'context'),
        ))).called(1);
  });
}