import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/core/network/api_service.dart';
import 'package:housepal_project/core/network/hive_service.dart';
import 'package:housepal_project/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:housepal_project/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_local_repository.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';
import 'package:housepal_project/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/get_user_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/logout_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/update_user_usecase.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/upload_image_usecase.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/helper_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/seeker_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:housepal_project/features/job/data/data_source/job_remote_data_source.dart';
import 'package:housepal_project/features/job/data/repositories/job_remote_repository.dart';
import 'package:housepal_project/features/job/domain/usecases/create_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/delete_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/filter_jobs_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/get_all_job_usecase.dart';
import 'package:housepal_project/features/job/domain/usecases/update_job_usecase.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:housepal_project/features/job_application/data/data_source/job_application_remote_data_source.dart';
import 'package:housepal_project/features/job_application/data/repositories/job_application_remote_repository.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';
import 'package:housepal_project/features/job_application/domain/usecases/apply_for_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/get_appication_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/update_application_usecase.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';
import 'package:housepal_project/features/notification/data/data_source/notification_datasource.dart';
import 'package:housepal_project/features/notification/data/data_source/notification_remote_datasource.dart';
import 'package:housepal_project/features/notification/data/repositories/notification_remote_repository.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';
import 'package:housepal_project/features/notification/domain/usecases/create_notification_usecase.dart';
import 'package:housepal_project/features/notification/domain/usecases/get_notification_usecases.dart';
import 'package:housepal_project/features/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:housepal_project/features/review/data/data_sources/review_datasource.dart';
import 'package:housepal_project/features/review/data/data_sources/review_remote_datasource.dart';
import 'package:housepal_project/features/review/data/repositories/review_remote_repository.dart';
import 'package:housepal_project/features/review/domain/repository/review_repository.dart';
import 'package:housepal_project/features/review/domain/usecases/get_helper_review_usecase.dart';
import 'package:housepal_project/features/review/domain/usecases/sumbit_review_usecase.dart';
import 'package:housepal_project/features/review/presentation/view_model/review_bloc.dart';
import 'package:housepal_project/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:housepal_project/features/task/data/data_sources/task_datasource.dart';
import 'package:housepal_project/features/task/data/data_sources/task_remote_datasource.dart';
import 'package:housepal_project/features/task/data/repositories/task_remote_repository.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';
import 'package:housepal_project/features/task/domain/usecases/create_tasks_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/get_helper_task_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/get_seeker_bookings_usecase.dart';
import 'package:housepal_project/features/task/domain/usecases/update_task_status.dart';
import 'package:housepal_project/features/task/presentation/view_model/task_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  print('Starting initDependencies...');
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initSplashScreenDependencies();
  await _initDashboardDependencies();
  await _initUserBlocDependencies();
  await _initJobDependencies();
  await _initNotificationDependencies();
  await _initJobApplicationDependencies();
  await _initTaskDependencies();
  await _initReviewDependencies();
  print('initDependencies completed.');
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  print('SharedPreferences registered.');
}

Future<void> _initApiService() async {
  getIt.registerLazySingleton<Dio>(() => ApiService(Dio()).dio);
  print('Dio registered.');
}

Future<void> _initHiveService() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
  print('HiveService registered.');
}

Future<void> _initRegisterDependencies() async {
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRemoteRepository>()),
  );
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerUserUseCase: getIt<RegisterUseCase>()),
  );
  print('Register dependencies registered.');
}

Future<void> _initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRemoteRepository>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUserUseCase: getIt<LoginUseCase>()),
  );
  print('Login dependencies registered.');
}

Future<void> _initUserBlocDependencies() async {
  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(repository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(repository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<AuthRemoteRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: getIt<AuthRemoteRepository>()),
  );
  getIt.registerFactory<UserBloc>(
    () => UserBloc(
      getUserUseCase: getIt<GetUserUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
      uploadImageUsecase: getIt<UploadImageUsecase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );
  print('UserBloc dependencies registered.');
}

Future<void> _initDashboardDependencies() async {
  getIt.registerFactory<SeekerDashboardView>(() => SeekerDashboardView());
  getIt.registerFactory<HelperDashboardView>(() => HelperDashboardView());
  print('Dashboard dependencies registered.');
}

Future<void> _initSplashScreenDependencies() async {
  getIt.registerFactory<SplashCubit>(() => SplashCubit());
  print('SplashScreen dependencies registered.');
}

Future<void> _initJobDependencies() async {
  getIt.registerLazySingleton<JobRemoteDataSource>(
    () => JobRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<JobRemoteRepository>(
    () => JobRemoteRepository(getIt<JobRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CreateJobPostingUseCase>(
    () => CreateJobPostingUseCase(getIt<JobRemoteRepository>()),
  );
  getIt.registerLazySingleton<UpdateJobUseCase>(
    () => UpdateJobUseCase(jobRepository: getIt<JobRemoteRepository>()),
  );
  getIt.registerLazySingleton<DeleteJobUseCase>(
    () => DeleteJobUseCase(getIt<JobRemoteRepository>()),
  );
  getIt.registerLazySingleton<GetAllJobUseCase>(
    () => GetAllJobUseCase(getIt<JobRemoteRepository>()),
  );
  getIt.registerLazySingleton<FilterJobsUseCase>(
    () => FilterJobsUseCase(getIt<JobRemoteRepository>()),
  );
  getIt.registerFactory<JobPostingBloc>(
    () => JobPostingBloc(
      createJobPostingUseCase: getIt<CreateJobPostingUseCase>(),
      filterJobsUseCase: getIt<FilterJobsUseCase>(),
      getAllJobUseCase: getIt<GetAllJobUseCase>(),
      updateJobUseCase: getIt<UpdateJobUseCase>(),
      deleteJobUseCase: getIt<DeleteJobUseCase>(),
    ),
  );
  print('Job dependencies registered.');
}

Future<void> _initJobApplicationDependencies() async {
  getIt.registerLazySingleton<JobApplicationRemoteDataSource>(
    () => JobApplicationRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<IJobApplicationRepository>(
    () =>
        JobApplicationRemoteRepository(getIt<JobApplicationRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ApplyForJobUseCase>(
    () => ApplyForJobUseCase(
        jobApplicationRepository: getIt<IJobApplicationRepository>()),
  );
  getIt.registerLazySingleton<UpdateApplicationStatusUseCase>(
    () => UpdateApplicationStatusUseCase(
        jobApplicationRepository: getIt<IJobApplicationRepository>()),
  );
  getIt.registerLazySingleton<GetApplicationsForJobUseCase>(
    () => GetApplicationsForJobUseCase(
        jobApplicationRepository: getIt<IJobApplicationRepository>()),
  );
  getIt.registerFactory<JobApplicationBloc>(
    () => JobApplicationBloc(
      applyForJobUseCase: getIt<ApplyForJobUseCase>(),
      getApplicationsForJobUseCase: getIt<GetApplicationsForJobUseCase>(),
      updateApplicationStatusUseCase: getIt<UpdateApplicationStatusUseCase>(),
      authRepo: getIt<AuthRemoteRepository>(),
    ),
  );
  print('JobApplication dependencies registered.');
}

Future<void> _initNotificationDependencies() async {
  getIt.registerLazySingleton<INotificationDataSource>(
    () => NotificationRemoteDataSource(getIt<Dio>(), getIt<TokenSharedPrefs>()),
  );
  getIt.registerLazySingleton<INotificationRepository>(
    () => NotificationRepository(getIt<INotificationDataSource>()),
  );
  getIt.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(getIt<INotificationRepository>()),
  );
  getIt.registerLazySingleton<MarkAllNotificationsAsReadUseCase>(
    () => MarkAllNotificationsAsReadUseCase(getIt<INotificationRepository>()),
  );
  getIt.registerLazySingleton<CreateNotificationUseCase>(
    () => CreateNotificationUseCase(getIt<INotificationRepository>()),
  );
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      markAllNotificationsAsReadUseCase:
          getIt<MarkAllNotificationsAsReadUseCase>(),
      notificationRepository: getIt<INotificationRepository>(),
    ),
  );
  print('Notification dependencies registered.');
}

Future<void> _initTaskDependencies() async {
  getIt.registerLazySingleton<ITaskDataSource>(
    () => TaskRemoteDataSource(getIt<Dio>(), getIt<TokenSharedPrefs>()),
  );
  getIt.registerLazySingleton<ITaskRepository>(
    () => TaskRemoteRepository(getIt<ITaskDataSource>()),
  );
  getIt.registerLazySingleton<GetHelperTasksUseCase>(
    () => GetHelperTasksUseCase(getIt<ITaskRepository>()),
  );
  getIt.registerLazySingleton<GetSeekerBookingsUseCase>(
    () => GetSeekerBookingsUseCase(getIt<ITaskRepository>()),
  );
  getIt.registerLazySingleton<UpdateTaskStatusUseCase>(
    () => UpdateTaskStatusUseCase(getIt<ITaskRepository>()),
  );
  getIt.registerLazySingleton<CreateTaskUseCase>(
    () => CreateTaskUseCase(getIt<ITaskRepository>()),
  );
  getIt.registerFactory<TaskBloc>(
    () => TaskBloc(
      getHelperTasksUseCase: getIt<GetHelperTasksUseCase>(),
      getSeekerBookingsUseCase: getIt<GetSeekerBookingsUseCase>(),
      updateTaskStatusUseCase: getIt<UpdateTaskStatusUseCase>(),
    ),
  );
  print('Task dependencies registered.');
}

Future<void> _initReviewDependencies() async {
  getIt.registerLazySingleton<IReviewDataSource>(
    () => ReviewRemoteDataSource(getIt<Dio>(), getIt<TokenSharedPrefs>()),
  );
  getIt.registerLazySingleton<IReviewRepository>(
    () => ReviewRemoteRepository(getIt<IReviewDataSource>()),
  );
  getIt.registerLazySingleton<ReviewRemoteRepository>(
    () => ReviewRemoteRepository(getIt<ReviewRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SubmitReviewUseCase>(
    () => SubmitReviewUseCase(getIt<IReviewRepository>()),
  );
  getIt.registerLazySingleton<GetHelperReviewsUseCase>(
    () => GetHelperReviewsUseCase(getIt<IReviewRepository>()),
  );
  getIt.registerFactory<ReviewBloc>(
    () => ReviewBloc(
      submitReviewUseCase: getIt<SubmitReviewUseCase>(),
      getHelperReviewsUseCase: getIt<GetHelperReviewsUseCase>(),
    ),
  );
  print('Review dependencies registered.');
}
