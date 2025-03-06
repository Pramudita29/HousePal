part of 'review_bloc.dart';

class ReviewState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<ReviewEntity> reviews;

  const ReviewState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    required this.reviews,
  });

  factory ReviewState.initial() => const ReviewState(
        isLoading: false,
        isSuccess: false,
        errorMessage: null,
        reviews: [],
      );

  ReviewState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<ReviewEntity>? reviews,
  }) => ReviewState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        errorMessage: errorMessage ?? this.errorMessage,
        reviews: reviews ?? this.reviews,
      );

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage, reviews];
}