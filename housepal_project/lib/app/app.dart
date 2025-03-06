import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/core/theme/app_theme.dart'; // Assuming this is where AppTheme will live
import 'package:housepal_project/features/splash/presentation/view/splash_view.dart';
import 'package:housepal_project/features/splash/presentation/view_model/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HousePal',
      theme: AppTheme.getApplicationTheme(isDarkMode: false), // Light theme
      darkTheme: AppTheme.getApplicationTheme(isDarkMode: true), // Dark theme
      themeMode: ThemeMode.system, // Respects device light/dark mode
      home: BlocProvider.value(
        value: getIt<SplashCubit>(),
        child: const SplashView(),
      ),
    );
  }
}
