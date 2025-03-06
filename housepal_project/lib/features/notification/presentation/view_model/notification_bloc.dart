import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Ensure this import is correct
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart'; // Interface
import 'package:housepal_project/features/notification/domain/usecases/get_notification_usecases.dart';
import 'package:housepal_project/features/notification/domain/usecases/mark_all_as_read_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final INotificationRepository notificationRepository; // Use interface type

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.notificationRepository,
  }) : super(NotificationState.initial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllNotificationsAsRead);
    print('NotificationBloc created with repository: $notificationRepository');
  }

  Future<void> _onFetchNotifications(
      FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getNotificationsUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (notifications) =>
          emit(state.copyWith(isLoading: false, notifications: notifications)),
    );
  }

  Future<void> _onMarkAllNotificationsAsRead(
      MarkAllNotificationsAsReadEvent event,
      Emitter<NotificationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await markAllNotificationsAsReadUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(
        isLoading: false,
        notifications:
            state.notifications?.map((n) => n.copyWith(isRead: true)).toList(),
      )),
    );
  }
}
