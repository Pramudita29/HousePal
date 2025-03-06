part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {
  const FetchNotificationsEvent();
}

class MarkAllNotificationsAsReadEvent extends NotificationEvent {
  const MarkAllNotificationsAsReadEvent();
}
