import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/notification/domain/repository/notification_repository.dart';

class CreateNotificationUseCase {
  final INotificationRepository repository;

  CreateNotificationUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String title, String message, String jobId, String recipientEmail) async {
    return await repository.createNotification(title, message, jobId, recipientEmail);
  }
}