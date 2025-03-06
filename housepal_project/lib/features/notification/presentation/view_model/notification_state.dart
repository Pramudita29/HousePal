part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<NotificationEntity>? notifications;
  final String? errorMessage;

  const NotificationState({
    required this.isLoading,
    this.notifications,
    this.errorMessage,
  });

  factory NotificationState.initial() =>
      const NotificationState(isLoading: false);

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationEntity>? notifications,
    String? errorMessage,
  }) =>
      NotificationState(
        isLoading: isLoading ?? this.isLoading,
        notifications: notifications ?? this.notifications,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [isLoading, notifications, errorMessage];
}
