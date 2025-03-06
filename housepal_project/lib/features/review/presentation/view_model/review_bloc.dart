import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/features/review/domain/entity/review.dart';
import 'package:housepal_project/features/review/domain/usecases/get_helper_review_usecase.dart';
import 'package:housepal_project/features/review/domain/usecases/sumbit_review_usecase.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReviewUseCase submitReviewUseCase;
  final GetHelperReviewsUseCase getHelperReviewsUseCase;

  ReviewBloc({
    SubmitReviewUseCase? submitReviewUseCase,
    GetHelperReviewsUseCase? getHelperReviewsUseCase,
  })  : submitReviewUseCase =
            submitReviewUseCase ?? getIt<SubmitReviewUseCase>(),
        getHelperReviewsUseCase =
            getHelperReviewsUseCase ?? getIt<GetHelperReviewsUseCase>(),
        super(ReviewState.initial()) {
    on<SubmitReviewEvent>(_onSubmitReview);
    on<FetchHelperReviewsEvent>(_onFetchHelperReviews);
  }

  Future<void> _onSubmitReview(
      SubmitReviewEvent event, Emitter<ReviewState> emit) async {
    print('Submitting review for helper: ${event.helperEmail}');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await submitReviewUseCase(SubmitReviewParams(
      helperEmail: event.helperEmail,
      seekerEmail: event.seekerEmail,
      seekerFullName: event.seekerFullName,
      seekerImage: event.seekerImage,
      rating: event.rating,
      comment: event.comment,
      taskId: event.taskId,
    ));
    result.fold(
      (failure) {
        print('Submit review failed: ${failure.message}');
        emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to submit review: ${failure.message}'));
      },
      (_) {
        print('Submit review succeeded');
        emit(state.copyWith(
            isLoading: false, isSuccess: true, errorMessage: null));
      },
    );
  }

  Future<void> _onFetchHelperReviews(
      FetchHelperReviewsEvent event, Emitter<ReviewState> emit) async {
    print('Fetching reviews for helper: ${event.helperEmail}');
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getHelperReviewsUseCase(event.helperEmail);
    result.fold(
      (failure) {
        print('Fetch reviews failed: ${failure.message}');
        emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to fetch reviews: ${failure.message}'));
      },
      (reviews) {
        print('Fetch reviews succeeded, count: ${reviews.length}');
        emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            reviews: reviews,
            errorMessage: null));
      },
    );
  }
}
