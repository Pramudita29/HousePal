import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/review/domain/repository/review_repository.dart';

class SubmitReviewParams {
  final String helperEmail;
  final String seekerEmail;
  final String seekerFullName;
  final String? seekerImage;
  final int rating;
  final String? comment;
  final String taskId;

  SubmitReviewParams({
    required this.helperEmail,
    required this.seekerEmail,
    required this.seekerFullName,
    this.seekerImage,
    required this.rating,
    this.comment,
    required this.taskId,
  });
}

class SubmitReviewUseCase {
  final IReviewRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<Either<Failure, void>> call(SubmitReviewParams params) async {
    return await repository.submitReview(
      params.helperEmail,
      params.rating,
      params.comment,
      taskId: params.taskId,
      seekerEmail: params.seekerEmail,
      seekerFullName: params.seekerFullName,
      seekerImage: params.seekerImage,
    );
  }
}
