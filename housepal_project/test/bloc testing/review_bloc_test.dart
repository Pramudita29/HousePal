import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/features/review/domain/entity/review.dart';
import 'package:housepal_project/features/review/domain/usecases/get_helper_review_usecase.dart';
import 'package:housepal_project/features/review/domain/usecases/sumbit_review_usecase.dart';
import 'package:housepal_project/features/review/presentation/view_model/review_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSubmitReviewUseCase extends Mock implements SubmitReviewUseCase {}

class MockGetHelperReviewsUseCase extends Mock
    implements GetHelperReviewsUseCase {}

void main() {
  late ReviewBloc reviewBloc;
  late MockSubmitReviewUseCase mockSubmitReviewUseCase;
  late MockGetHelperReviewsUseCase mockGetHelperReviewsUseCase;

  setUp(() {
    mockSubmitReviewUseCase = MockSubmitReviewUseCase();
    mockGetHelperReviewsUseCase = MockGetHelperReviewsUseCase();
    reviewBloc = ReviewBloc(
      submitReviewUseCase: mockSubmitReviewUseCase,
      getHelperReviewsUseCase: mockGetHelperReviewsUseCase,
    );
    registerFallbackValue(SubmitReviewParams(
        helperEmail: '',
        seekerEmail: '',
        seekerFullName: '',
        rating: 0,
        taskId: ''));
  });

  tearDown(() {
    reviewBloc.close();
  });

  group('ReviewBloc', () {
    final tReview = ReviewEntity(
      helperEmail: 'helper@example.com',
      seekerEmail: 'seeker@example.com',
      seekerFullName: 'Seeker',
      rating: 5,
      comment: 'Great job',
      id: 'task1',
      createdAt: DateTime.now()
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [loading, success] on submit review success',
      build: () {
        when(() => mockSubmitReviewUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return reviewBloc;
      },
      act: (bloc) => bloc.add(const SubmitReviewEvent(
          helperEmail: 'helper@example.com',
          seekerEmail: 'seeker@example.com',
          seekerFullName: 'Seeker',
          rating: 5,
          taskId: 'task1')),
      expect: () => [
        const ReviewState(isLoading: true, isSuccess: false, reviews: []),
        const ReviewState(isLoading: false, isSuccess: true, reviews: []),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [loading, success] on fetch reviews success',
      build: () {
        when(() => mockGetHelperReviewsUseCase(any()))
            .thenAnswer((_) async => Right([tReview]));
        return reviewBloc;
      },
      act: (bloc) =>
          bloc.add(const FetchHelperReviewsEvent('helper@example.com')),
      expect: () => [
        const ReviewState(isLoading: true, isSuccess: false, reviews: []),
        ReviewState(isLoading: false, isSuccess: false, reviews: [tReview]),
      ],
    );
  });
}
