import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/di/di.dart'; // Import getIt
import 'package:housepal_project/core/theme/app_theme.dart';
import 'package:housepal_project/features/splash/presentation/view/splash_view.dart';
import 'package:housepal_project/features/splash/presentation/view_model/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HousePal',
      theme: AppTheme.getApplicationTheme(isDarkMode: false),
      home: BlocProvider.value(
        value: getIt<SplashCubit>(),
        child: SplashView(),
      ),
    );
  }
}
