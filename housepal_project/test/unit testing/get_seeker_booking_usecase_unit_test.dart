import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/entity/tasks.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';
import 'package:housepal_project/features/task/domain/usecases/get_seeker_bookings_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  late GetSeekerBookingsUseCase getSeekerBookingsUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getSeekerBookingsUseCase = GetSeekerBookingsUseCase(mockTaskRepository);
  });

  group('GetSeekerBookingsUseCase', () {
    final tBookings = [
      TaskEntity(
        taskId: 'task123',
        jobId: 'job123',
        seekerEmail: 'seeker@example.com',
        helperFullName: 'Jane Helper',
        helperEmail: 'jane@example.com',
        jobTitle: 'Test Job',
        scheduledTime: DateTime.now(),
        status: 'scheduled',
      )
    ];

    test('should return list of bookings when successful', () async {
      // Arrange
      when(() => mockTaskRepository.getSeekerBookings())
          .thenAnswer((_) async => Right(tBookings));

      // Act
      final result = await getSeekerBookingsUseCase();

      // Assert
      expect(result, Right(tBookings));
      verify(() => mockTaskRepository.getSeekerBookings()).called(1);
    });

    test('should return failure when get bookings fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Failed to fetch bookings');
      when(() => mockTaskRepository.getSeekerBookings())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getSeekerBookingsUseCase();

      // Assert
      expect(result, Left(failure));
      verify(() => mockTaskRepository.getSeekerBookings()).called(1);
    });
  });
}
