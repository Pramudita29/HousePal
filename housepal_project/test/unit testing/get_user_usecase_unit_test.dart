import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/get_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetUserUseCase getUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getUserUseCase = GetUserUseCase(repository: mockAuthRepository);
  });

  group('GetUserUseCase', () {
    final tUser = AuthEntity(
      fullName: 'John Doe',
      email: 'test@example.com',
      contactNo: '1234567890',
      password: 'password',
      confirmPassword: 'password',
      role: 'user',
    );

    test('should return user when successful', () async {
      // Arrange
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Right(tUser));

      // Act
      final result = await getUserUseCase();

      // Assert
      expect(result, Right(tUser));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
    });

    test('should return failure when get user fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'User not found');
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getUserUseCase();

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
    });
  });
}
