import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/auth/presentation/view/onboarding_view.dart';

void main() {
  testWidgets('displays first onboarding page and navigates to next',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    expect(find.text('Welcome to HousePal!'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Browse Available Helpers'), findsOneWidget);
  });

  testWidgets('skips onboarding and navigates to RegisterPage', (tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {'/RegisterView': (_) => const Scaffold(body: Text('Register'))},
      home: const OnboardingScreen(),
    ));
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Register'), findsOneWidget);
  });
}
