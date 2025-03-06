import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/task/domain/repository/task_repository.dart';
import 'package:housepal_project/features/task/domain/usecases/create_tasks_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements ITaskRepository {}

void main() {
  late CreateTaskUseCase createTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    createTaskUseCase = CreateTaskUseCase(mockTaskRepository);
  });

  group('CreateTaskUseCase', () {
    const tJobId = 'job123';
    const tApplicationId = 'app123';
    const tSeekerEmail = 'seeker@example.com';
    const tHelperEmail = 'helper@example.com';
    final tScheduledTime = DateTime.now();

    test('should return void when task creation is successful', () async {
      // Arrange
      when(() => mockTaskRepository.createTask(tJobId, tApplicationId, tSeekerEmail, tHelperEmail, tScheduledTime))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await createTaskUseCase(tJobId, tApplicationId, tSeekerEmail, tHelperEmail, tScheduledTime);

      // Assert
      expect(result, const Right(null));
      verify(() => mockTaskRepository.createTask(tJobId, tApplicationId, tSeekerEmail, tHelperEmail, tScheduledTime)).called(1);
    });

    test('should return failure when task creation fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Task creation failed');
      when(() => mockTaskRepository.createTask(tJobId, tApplicationId, tSeekerEmail, tHelperEmail, tScheduledTime))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await createTaskUseCase(tJobId, tApplicationId, tSeekerEmail, tHelperEmail, tScheduledTime);

      // Assert
      expect(result, Left(failure));
      verify(() => mockTaskRepository.createTask(tJobId, tApplicationId, tSeekerEmail, tHelperEmail, tScheduledTime)).called(1);
    });
  });
}