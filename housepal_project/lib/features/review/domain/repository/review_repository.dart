import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/review/domain/entity/review.dart';

abstract class IReviewRepository {
  Future<Either<Failure, void>> submitReview(
    String helperEmail,
    int rating,
    String? comment, {
    required String taskId,
    required String seekerEmail,
    required String seekerFullName,
    String? seekerImage,
  });

  Future<Either<Failure, List<ReviewEntity>>> getHelperReviews(
      String helperEmail);
}
