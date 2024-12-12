import 'package:flutter/material.dart';
import 'package:housepal_project/view/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Assignment',
      home: OnboardingScreen(), // Start with the Dashboard view
    );
  }
}
