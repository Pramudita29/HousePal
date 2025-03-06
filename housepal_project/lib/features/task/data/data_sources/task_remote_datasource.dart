import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/features/task/data/data_sources/task_datasource.dart';
import 'package:housepal_project/features/task/data/model/task_api_model.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';

class TaskRemoteDataSource implements ITaskDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  TaskRemoteDataSource(this._dio, this._tokenSharedPrefs);

  Future<String?> _getToken() async {
    final tokenEither = await _tokenSharedPrefs.getToken();
    return tokenEither.getOrElse(() => null);
  }

  @override
  Future<List<TaskEntity>> getHelperTasks(String helperEmail) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final response = await _dio.get(
        ApiEndpoints.getHelperTasks(helperEmail),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> tasksJson = response.data;
        final tasks = tasksJson
            .map((json) => TaskApiModel.fromJson(json).toEntity())
            .toList();
        print('getHelperTasks: Fetched ${tasks.length} tasks');
        return tasks;
      } else {
        throw Exception(
            "Failed to fetch helper tasks: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Fetch helper tasks error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<List<TaskEntity>> getSeekerBookings() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final response = await _dio.get(
        ApiEndpoints.getSeekerBookings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> tasksJson = response.data;
        final tasks = tasksJson
            .map((json) => TaskApiModel.fromJson(json).toEntity())
            .toList();
        final uniqueTasks = <String, TaskEntity>{};
        for (var task in tasks) {
          uniqueTasks[task.jobId] = task;
        }
        final filteredTasks = uniqueTasks.values.toList();
        print(
            'getSeekerBookings: Fetched ${filteredTasks.length} unique tasks');
        for (var task in filteredTasks) {
          print(
              'Task: taskId=${task.taskId}, status=${task.status}, helperEmail=${task.helperEmail}, helperFullName=${task.helperFullName}');
        }
        return filteredTasks;
      } else {
        throw Exception(
            "Failed to fetch seeker bookings: ${response.data['message']}");
      }
    } on DioException catch (e) {
      throw Exception(
          "Fetch seeker bookings error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final response = await _dio.put(
        ApiEndpoints.updateTaskStatus(taskId),
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update task status: ${response.data['message']}");
      }
      print('Updated task $taskId status to $status');
    } on DioException catch (e) {
      throw Exception(
          "Update task status error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future<void> createTask(String jobId, String applicationId,
      String seekerEmail, String helperEmail, DateTime scheduledTime) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("No authentication token found.");

      final taskData = {
        'jobId': jobId,
        'applicationId': applicationId,
        'seekerEmail': seekerEmail,
        'helperDetails': {
          'email': helperEmail,
          'fullName': (await _fetchHelperFullName(helperEmail)) ??
              'Unknown', // Fetch full name if available
        },
        'scheduledDateTime': scheduledTime.toIso8601String(),
        'status': 'pending',
      };

      final response = await _dio.post(
        ApiEndpoints.createTask,
        data: taskData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create task: ${response.data['message']}");
      }
      print('Created task for jobId: $jobId');
    } on DioException catch (e) {
      throw Exception(
          "Create task error: ${e.response?.data['message'] ?? e.message}");
    }
  }

  Future<String?> _fetchHelperFullName(String helperEmail) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}/users/profile?email=$helperEmail', // Adjust endpoint as per your backend
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['fullName'] as String?;
      }
      return null;
    } catch (e) {
      print('Failed to fetch helper full name: $e');
      return null;
    }
  }
}
