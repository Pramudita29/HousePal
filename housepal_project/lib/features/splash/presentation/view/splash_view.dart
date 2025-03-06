import 'package:flutter/material.dart';
import 'package:housepal_project/features/auth/presentation/view/onboarding_view.dart'; // Assuming app_theme.dart has your theme

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Navigate to onboarding screen after a short delay
  _navigateToNextScreen() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Adjust duration as needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OnboardingScreen()), // Replace with your OnboardingView or initial screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Dynamic primary color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo here
            Image.asset(
              'assets/images/logo.png', // Update path to your logo
              width: 150, // Adjust size as necessary
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to HousePal!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
