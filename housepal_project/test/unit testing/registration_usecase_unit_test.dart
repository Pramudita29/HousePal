import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUseCase registerUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  group('RegisterUseCase', () {
    final tAuthEntity = AuthEntity(
      fullName: 'John Doe',
      email: 'test@example.com',
      contactNo: '1234567890',
      password: 'password',
      confirmPassword: 'password',
      role: 'user',
    );

    test('should return void when registration is successful', () async {
      // Arrange
      when(() => mockAuthRepository.registerUser(tAuthEntity))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await registerUseCase(tAuthEntity);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.registerUser(tAuthEntity)).called(1);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Registration failed');
      when(() => mockAuthRepository.registerUser(tAuthEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await registerUseCase(tAuthEntity);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.registerUser(tAuthEntity)).called(1);
    });
  });
}
