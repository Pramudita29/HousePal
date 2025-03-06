import 'package:housepal_project/features/review/data/model/review_api_model.dart';

abstract class IReviewDataSource {
  Future<void> submitReview(
    String helperEmail,
    int rating,
    String? comment, {
    required String taskId,
    required String seekerEmail,
    required String seekerFullName,
    String? seekerImage,
  });
  Future<List<ReviewApiModel>> getHelperReviews(String helperEmail);
}
