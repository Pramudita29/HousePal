import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/domain/repository/job_repository.dart';
import 'package:housepal_project/features/job/domain/usecases/create_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockJobRepository extends Mock implements IJobRepository {}

void main() {
  late CreateJobPostingUseCase createJobPostingUseCase;
  late MockJobRepository mockJobRepository;

  setUp(() {
    mockJobRepository = MockJobRepository();
    createJobPostingUseCase = CreateJobPostingUseCase(mockJobRepository);
  });

  group('CreateJobPostingUseCase', () {
    final tJobPosting = JobPosting(
      jobId: 'job123',
      jobTitle: 'Test Job',
      jobDescription: 'This is a test job description',
      datePosted: DateTime.now(),
      status: 'open',
      category: 'General',
      subCategory: 'Cleaning',
      location: 'Test City',
      salaryRange: '1000-2000',
      contractType: 'Part-time',
      applicationDeadline: DateTime.now().add(const Duration(days: 30)),
      contactInfo: 'test@example.com',
      posterFullName: 'John Doe',
      posterEmail: 'john@example.com',
      posterImage: 'https://example.com/poster.jpg',
    );

    test('should return job posting when creation is successful', () async {
      // Arrange
      when(() => mockJobRepository.createJob(tJobPosting))
          .thenAnswer((_) async => Right(tJobPosting));

      // Act
      final result = await createJobPostingUseCase(tJobPosting);

      // Assert
      expect(result, Right(tJobPosting));
      verify(() => mockJobRepository.createJob(tJobPosting)).called(1);
    });

    test('should return failure when creation fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Job creation failed');
      when(() => mockJobRepository.createJob(tJobPosting))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await createJobPostingUseCase(tJobPosting);

      // Assert
      expect(result, Left(failure));
      verify(() => mockJobRepository.createJob(tJobPosting)).called(1);
    });
  });
}
