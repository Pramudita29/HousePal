import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/review/data/data_sources/review_datasource.dart';
import 'package:housepal_project/features/review/domain/entity/review.dart';
import 'package:housepal_project/features/review/domain/repository/review_repository.dart';

class ReviewRemoteRepository implements IReviewRepository {
  final IReviewDataSource dataSource;

  ReviewRemoteRepository(this.dataSource);

  @override
  Future<Either<Failure, void>> submitReview(
    String helperEmail,
    int rating,
    String? comment, {
    required String taskId,
    required String seekerEmail,
    required String seekerFullName,
    String? seekerImage,
  }) async {
    try {
      await dataSource.submitReview(
        helperEmail,
        rating,
        comment,
        taskId: taskId,
        seekerEmail: seekerEmail,
        seekerFullName: seekerFullName,
        seekerImage: seekerImage,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getHelperReviews(
      String helperEmail) async {
    try {
      final reviews = await dataSource.getHelperReviews(helperEmail);
      return Right(reviews.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
