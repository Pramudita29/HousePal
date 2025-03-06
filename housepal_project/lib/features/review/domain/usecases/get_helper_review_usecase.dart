import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/review/domain/entity/review.dart';
import 'package:housepal_project/features/review/domain/repository/review_repository.dart';

class GetHelperReviewsUseCase {
  final IReviewRepository repository;

  GetHelperReviewsUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(String helperEmail) async {
    return await repository.getHelperReviews(helperEmail);
  }
}
