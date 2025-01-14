import 'package:get_it/get_it.dart';
import 'package:housepal_project/core/network/hive_service.dart';
import 'package:housepal_project/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_local_repository.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';
import 'package:housepal_project/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/helper_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/seeker_dashboard_view.dart';
import 'package:housepal_project/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();

  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initSplashScreenDependencies();
  await _initDashboardDependencies(); // Initialize onboarding dependencies
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initRegisterDependencies() {
  // init local data source
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  // init local repository
  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  // register use case
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUserUseCase: getIt(),
    ),
  );
}

_initLoginDependencies() {
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      loginUserUseCase: getIt<LoginUseCase>(),
    ),
  );
}

_initDashboardDependencies() {
  // Seeker Dashboard
  getIt.registerFactory<SeekerDashboardView>(
    () => SeekerDashboardView(),
  );

  // Helper Dashboard
  getIt.registerFactory<HelperDashboardView>(
    () => HelperDashboardView(),
  );
}

_initSplashScreenDependencies() {
  getIt.registerLazySingleton<SplashCubit>(
    () => SplashCubit(),
  );
}
