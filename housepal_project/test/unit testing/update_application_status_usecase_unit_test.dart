import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';
import 'package:housepal_project/features/job_application/domain/usecases/update_application_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockJobApplicationRepository extends Mock implements IJobApplicationRepository {}

void main() {
  late UpdateApplicationStatusUseCase updateApplicationStatusUseCase;
  late MockJobApplicationRepository mockJobApplicationRepository;

  setUp(() {
    mockJobApplicationRepository = MockJobApplicationRepository();
    updateApplicationStatusUseCase = UpdateApplicationStatusUseCase(jobApplicationRepository: mockJobApplicationRepository);
  });

  group('UpdateApplicationStatusUseCase', () {
    const tApplicationId = 'app123';
    const tStatus = 'approved';
    const tJobId = 'job123';

    test('should return true when status update is successful', () async {
      // Arrange
      when(() => mockJobApplicationRepository.updateApplicationStatus(tApplicationId, tStatus, tJobId))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await updateApplicationStatusUseCase(tApplicationId, tStatus, tJobId);

      // Assert
      expect(result, const Right(true));
      verify(() => mockJobApplicationRepository.updateApplicationStatus(tApplicationId, tStatus, tJobId)).called(1);
    });

    test('should return failure when status update fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Status update failed');
      when(() => mockJobApplicationRepository.updateApplicationStatus(tApplicationId, tStatus, tJobId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await updateApplicationStatusUseCase(tApplicationId, tStatus, tJobId);

      // Assert
      expect(result, Left(failure));
      verify(() => mockJobApplicationRepository.updateApplicationStatus(tApplicationId, tStatus, tJobId)).called(1);
    });
  });
}