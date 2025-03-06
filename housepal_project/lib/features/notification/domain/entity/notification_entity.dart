import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String jobId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.jobId,
  });

  @override
  List<Object?> get props => [id, title, message, isRead, jobId];

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    bool? isRead,
    String? jobId,
  }) =>
      NotificationEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        message: message ?? this.message,
        isRead: isRead ?? this.isRead,
        jobId: jobId ?? this.jobId,
      );

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      NotificationEntity(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        isRead: json['isRead'] ?? false,
        jobId: json['jobId'] ?? '',
      );
}
