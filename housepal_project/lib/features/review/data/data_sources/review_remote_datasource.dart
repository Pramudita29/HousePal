import 'package:dio/dio.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/app/shared_prefs/token_shared_prefs.dart';
import 'package:housepal_project/features/review/data/data_sources/review_datasource.dart';
import 'package:housepal_project/features/review/data/model/review_api_model.dart';

class ReviewRemoteDataSource implements IReviewDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  ReviewRemoteDataSource(this._dio, this._tokenSharedPrefs);

  Future<String?> _getToken() async {
    final tokenEither = await _tokenSharedPrefs.getToken();
    return tokenEither.fold((failure) => null, (token) => token);
  }

  @override
  Future<void> submitReview(
    String helperEmail,
    int rating,
    String? comment, {
    required String taskId,
    required String seekerEmail,
    required String seekerFullName,
    String? seekerImage,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      print(
          'Submitting review with payload: {seekerId: $seekerEmail, seekerFullName: $seekerFullName, seekerImage: $seekerImage, helperId: $helperEmail, taskId: $taskId, rating: $rating, comments: $comment}');

      final response = await _dio.post(
        ApiEndpoints.createReview,
        data: {
          'seekerId': seekerEmail,
          'seekerFullName': seekerFullName,
          'seekerImage': seekerImage,
          'helperId': helperEmail,
          'taskId': taskId,
          'rating': rating,
          'comments': comment,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => true,
        ),
      );

      print(
          'Response received: Status=${response.statusCode}, Data=${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = response.data is String
            ? response.data
            : response.data['message'] ?? 'Unknown error: ${response.data}';
        throw Exception(
            'Failed to submit review: Status=${response.statusCode}, Message=$errorMessage');
      }
      print('Review submission successful: ${response.data}');
    } on DioException catch (e) {
      throw Exception('Review submission error: ${e.message}');
    } catch (e) {
      print('Unexpected error during review submission: $e');
      throw Exception('Review submission error: Unexpected error: $e');
    }
  }

  @override
  Future<List<ReviewApiModel>> getHelperReviews(String helperEmail) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await _dio.get(
        ApiEndpoints.getHelperReviews(helperEmail),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print(
          'Raw reviews response: Status=${response.statusCode}, Data=${response.data}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch reviews: ${response.data['message'] ?? 'Unknown error'}');
      }

      final List<dynamic> reviewsJson = response.data;
      final reviewModels = reviewsJson
          .map((json) => ReviewApiModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Added log to verify mapped reviews
      print(
          'Mapped reviews: ${reviewModels.map((r) => "seekerId=${r.seekerId}, fullName=${r.seekerFullName}, image=${r.seekerImage}").toList()}');

      return reviewModels;
    } on DioException catch (e) {
      final errorMessage = e.response != null
          ? 'Status: ${e.response!.statusCode}, Message: ${e.response!.data['message'] ?? e.response!.data}'
          : e.message ?? 'Unknown Dio error';
      throw Exception('Fetch reviews error: $errorMessage');
    }
  }
}
