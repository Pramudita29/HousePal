import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Correct import without alias for Stripe
import 'package:housepal_project/app/app.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/core/network/hive_service.dart';
import 'package:housepal_project/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:housepal_project/features/review/presentation/view_model/review_bloc.dart';
import 'package:housepal_project/features/task/presentation/view_model/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await initDependencies(); // Ensure dependencies are initialized

  // Set Stripe publishable key directly without alias
  Stripe.publishableKey =
      'pk_test_51QwnhfLwN9qJ226iuySukDs0srQUjjpISm3EcM8H7r0EwT1a0guGjoZaSENlsAz6W8uTd8XAfnCt6JzaRxWx36GW00rIcQxHOE';

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => getIt<LoginBloc>(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => getIt<RegisterBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>(),
        ),
        BlocProvider(create: (context) => getIt<JobPostingBloc>()),
        BlocProvider(create: (context) => getIt<NotificationBloc>()),
        BlocProvider(create: (context) => getIt<JobApplicationBloc>()),
        BlocProvider(create: (context) => getIt<TaskBloc>()),
        BlocProvider(create: (context) => getIt<ReviewBloc>()),
      ],
      child: const App(),
    ),
  );
}
