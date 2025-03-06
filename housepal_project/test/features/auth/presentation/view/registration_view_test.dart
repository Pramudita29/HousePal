import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/auth/presentation/view/registration_view.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  late MockRegisterBloc mockRegisterBloc;

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<RegisterBloc>.value(
        value: mockRegisterBloc,
        child: const RegisterPage(),
      ),
    );
  }

  testWidgets('shows success snackbar and navigates on successful registration',
      (tester) async {
    whenListen(
      mockRegisterBloc,
      Stream.fromIterable([
        RegisterState.initial(),
        RegisterState.initial().copyWith(isSuccess: true)
      ]),
      initialState: RegisterState.initial(),
    );
    await tester.pumpWidget(buildTestWidget());

    await tester.enterText(find.byType(TextField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), '1234567890');
    await tester.enterText(find.byType(TextField).at(3), 'password');
    await tester.enterText(find.byType(TextField).at(4), 'password');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seeker').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Registered Successfully!'), findsOneWidget);
  });

  testWidgets('shows error snackbar when fields are empty', (tester) async {
    when(() => mockRegisterBloc.state).thenReturn(RegisterState.initial());
    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Please fill in all fields!'), findsOneWidget);
  });
}
