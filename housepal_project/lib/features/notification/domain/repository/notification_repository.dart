import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, Unit>> markAllNotificationsAsRead();
  Future<Either<Failure, Unit>> createNotification(String title, String message,
      String jobId, String recipientEmail); // New method
}
