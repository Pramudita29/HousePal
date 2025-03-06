import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final INotificationRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.markAllNotificationsAsRead();
  }
}