import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/notification/data/data_source/notification_datasource.dart';
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';

class NotificationRepository implements INotificationRepository {
  final INotificationDataSource dataSource;

  NotificationRepository(this.dataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await dataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllNotificationsAsRead() async {
    try {
      await dataSource.markAllNotificationsAsRead();
      return const Right(unit);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createNotification(String title, String message, String jobId, String recipientEmail) async {
    try {
      await dataSource.createNotification(title, message, jobId, recipientEmail);
      return const Right(unit);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}