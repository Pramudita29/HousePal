import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String message;
  final bool isRead;
  final String jobId;

  const NotificationApiModel({
    this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.jobId,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  NotificationEntity toEntity() => NotificationEntity(
        id: id ?? '',
        title: title,
        message: message,
        isRead: isRead,
        jobId: jobId,
      );

  static NotificationApiModel fromEntity(NotificationEntity notification) =>
      NotificationApiModel(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        isRead: notification.isRead,
        jobId: notification.jobId,
      );

  @override
  List<Object?> get props => [id, title, message, isRead, jobId];
}
