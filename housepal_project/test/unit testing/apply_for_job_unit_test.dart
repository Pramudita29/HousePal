import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/job_application/domain/repository/job_application_repository.dart';
import 'package:housepal_project/features/job_application/domain/usecases/apply_for_job_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockJobApplicationRepository extends Mock
    implements IJobApplicationRepository {}

void main() {
  late ApplyForJobUseCase applyForJobUseCase;
  late MockJobApplicationRepository mockJobApplicationRepository;

  setUp(() {
    mockJobApplicationRepository = MockJobApplicationRepository();
    applyForJobUseCase = ApplyForJobUseCase(
        jobApplicationRepository: mockJobApplicationRepository);
  });

  group('ApplyForJobUseCase', () {
    const tJobId = 'job123';
    final tHelperDetails = AuthEntity(
      fullName: 'Jane Helper',
      email: 'jane@example.com',
      contactNo: '9876543210',
      password: 'securepass',
      role: 'helper',
      confirmPassword: 'securepass',
    );

    test('should return true when application is successful', () async {
      // Arrange
      when(() =>
              mockJobApplicationRepository.applyForJob(tJobId, tHelperDetails))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await applyForJobUseCase(tJobId, tHelperDetails);

      // Assert
      expect(result, const Right(true));
      verify(() =>
              mockJobApplicationRepository.applyForJob(tJobId, tHelperDetails))
          .called(1);
    });

    test('should return failure when application fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Application failed');
      when(() =>
              mockJobApplicationRepository.applyForJob(tJobId, tHelperDetails))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await applyForJobUseCase(tJobId, tHelperDetails);

      // Assert
      expect(result, Left(failure));
      verify(() =>
              mockJobApplicationRepository.applyForJob(tJobId, tHelperDetails))
          .called(1);
    });
  });
}
