import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';
import 'package:housepal_project/features/notification/domain/usecases/get_notification_usecases.dart';
import 'package:housepal_project/features/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockMarkAllNotificationsAsReadUseCase extends Mock
    implements MarkAllNotificationsAsReadUseCase {}

class MockNotificationRepository extends Mock
    implements INotificationRepository {}

void main() {
  late NotificationBloc notificationBloc;
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late MockMarkAllNotificationsAsReadUseCase
      mockMarkAllNotificationsAsReadUseCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockMarkAllNotificationsAsReadUseCase =
        MockMarkAllNotificationsAsReadUseCase();
    mockNotificationRepository = MockNotificationRepository();
    notificationBloc = NotificationBloc(
      getNotificationsUseCase: mockGetNotificationsUseCase,
      markAllNotificationsAsReadUseCase: mockMarkAllNotificationsAsReadUseCase,
      notificationRepository: mockNotificationRepository,
    );
  });

  tearDown(() {
    notificationBloc.close();
  });

  group('NotificationBloc', () {
    final tNotification = NotificationEntity(
      id: 'notif1',
      title: 'Test',
      message: 'Test message',
      isRead: false,
      jobId: 'job1',
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [loading, success] on fetch notifications success',
      build: () {
        when(() => mockGetNotificationsUseCase())
            .thenAnswer((_) async => Right([tNotification]));
        return notificationBloc;
      },
      act: (bloc) => bloc.add(const FetchNotificationsEvent()),
      expect: () => [
        const NotificationState(isLoading: true),
        NotificationState(isLoading: false, notifications: [tNotification]),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [loading, success] on mark all as read success',
      build: () {
        when(() => mockMarkAllNotificationsAsReadUseCase())
            .thenAnswer((_) async => const Right(unit)); // Fixed null with unit
        return notificationBloc..add(const FetchNotificationsEvent());
      },
      seed: () =>
          NotificationState(notifications: [tNotification], isLoading: false),
      act: (bloc) => bloc.add(const MarkAllNotificationsAsReadEvent()),
      expect: () => [
        NotificationState(isLoading: true, notifications: [tNotification]),
        NotificationState(
            isLoading: false,
            notifications: [tNotification.copyWith(isRead: true)]),
      ],
    );
  });
}
