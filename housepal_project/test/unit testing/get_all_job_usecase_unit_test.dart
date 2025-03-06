import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';
import 'package:housepal_project/features/job/domain/usecases/get_all_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockJobRepository extends Mock implements IJobRepository {}

void main() {
  late GetAllJobUseCase getAllJobUseCase;
  late MockJobRepository mockJobRepository;

  setUp(() {
    mockJobRepository = MockJobRepository();
    getAllJobUseCase = GetAllJobUseCase(mockJobRepository);
  });

  group('GetAllJobUseCase', () {
    final tJobs = [
      JobPosting(
        jobId: 'job123',
        jobTitle: 'Test Job',
        jobDescription: 'Test Description',
        datePosted: DateTime.now(),
        status: 'open',
        category: 'Test Category',
        subCategory: 'Test Subcategory',
        location: 'Test Location',
        salaryRange: '1000-2000',
        contractType: 'Full-time',
        applicationDeadline: DateTime.now().add(const Duration(days: 30)),
        contactInfo: 'test@example.com',
        posterFullName: 'John Doe',
        posterEmail: 'john@example.com',
        posterImage: 'https://example.com/image.jpg',
      )
    ];

    test('should return list of jobs when successful', () async {
      // Arrange
      when(() => mockJobRepository.getAllJobs())
          .thenAnswer((_) async => Right(tJobs));

      // Act
      final result = await getAllJobUseCase();

      // Assert
      expect(result, Right(tJobs));
      verify(() => mockJobRepository.getAllJobs()).called(1);
    });

    test('should return failure when get jobs fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Failed to fetch jobs');
      when(() => mockJobRepository.getAllJobs())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllJobUseCase();

      // Assert
      expect(result, Left(failure));
      verify(() => mockJobRepository.getAllJobs()).called(1);
    });
  });
}
