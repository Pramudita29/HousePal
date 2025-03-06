import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAllNotificationsAsRead();
  Future<void> createNotification(String title, String message, String jobId, String recipientEmail); // New method
}