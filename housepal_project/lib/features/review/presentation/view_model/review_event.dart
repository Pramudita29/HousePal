part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class SubmitReviewEvent extends ReviewEvent {
  final String helperEmail;
  final String seekerEmail;
  final String seekerFullName;
  final String? seekerImage;
  final int rating;
  final String? comment;
  final String taskId;

  const SubmitReviewEvent({
    required this.helperEmail,
    required this.seekerEmail,
    required this.seekerFullName,
    this.seekerImage,
    required this.rating,
    this.comment,
    required this.taskId,
  });

  @override
  List<Object?> get props => [helperEmail, seekerEmail, seekerFullName, seekerImage, rating, comment, taskId];
}

class FetchHelperReviewsEvent extends ReviewEvent {
  final String helperEmail;

  const FetchHelperReviewsEvent(this.helperEmail);

  @override
  List<Object> get props => [helperEmail];
}