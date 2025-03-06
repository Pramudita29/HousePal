import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final INotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}