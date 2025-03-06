import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/features/notification/data/data_source/notification_datasource.dart';
import 'package:housepal_project/features/notification/domain/entity/notification_entity.dart';

class NotificationRemoteDataSource implements INotificationDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  NotificationRemoteDataSource(this._dio,
      this._tokenSharedPrefs); // Fixed typo: _tokenShared_prefs -> _tokenSharedPrefs

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final tokenEither = await _tokenSharedPrefs.getToken();
      final emailEither = await _tokenSharedPrefs.getEmail();

      final token = tokenEither.getOrElse(() => null);
      final userEmail = emailEither.getOrElse(() => null);

      print('Token: $token, Email: $userEmail');

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final response = await _dio.get(
        ApiEndpoints.getNotifications,
        queryParameters: userEmail != null ? {'email': userEmail} : {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to fetch notifications: ${response.data['message']}");
      }

      final List<dynamic> notificationsJson = response.data;
      return notificationsJson
          .map((json) => NotificationEntity.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          "Failed to fetch notifications: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      final tokenEither = await _tokenSharedPrefs.getToken();
      final token = tokenEither.getOrElse(() => null);

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final response = await _dio.patch(
        ApiEndpoints.markAllNotificationsAsRead,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to mark notifications as read: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Failed to mark notifications as read: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> createNotification(
      String title, String message, String jobId, String recipientEmail) async {
    try {
      final tokenEither = await _tokenSharedPrefs.getToken();
      final token = tokenEither.getOrElse(() => null);

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final notificationData = {
        'title': title,
        'message': message,
        'jobId': jobId, // Send as a string, not nested
        'recipientEmail': recipientEmail,
        'recipientType': recipientEmail.contains('pbhattarai0129@gmail.com')
            ? 'Seeker'
            : 'Helper',
      };

      final response = await _dio.post(
        ApiEndpoints.addNotification,
        data: notificationData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201) {
        throw Exception(
            "Failed to create notification: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Create notification error: ${e.response?.data['message'] ?? e.message}");
    }
  }
}
