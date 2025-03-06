import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/auth/presentation/view/login_view.dart';
import 'package:housepal_project/features/auth/presentation/view/onboarding_view.dart';
import 'package:housepal_project/features/auth/presentation/view/registration_view.dart';

void main() {
  testWidgets('navigates from onboarding to login', (tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/login': (_) => const LoginView(),
        '/register': (_) => const RegisterPage(),
      },
      home: const OnboardingScreen(),
    ));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}
