import 'package:flutter/material.dart';
import 'package:housepal_project/core/app_theme/app_theme.dart';
import 'package:housepal_project/view/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Assignment',
      theme: getApplicationTheme(), // Apply the custom theme here
      home: const OnboardingScreen(),
    );
  }
}
