import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:housepal_project/features/auth/domain/usecase/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository using mocktail
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockAuthRepository);
  });

  final AuthEntity testAuthEntity = AuthEntity(
    fullName: 'Test User',
    email: 'test@example.com',
    contactNo: '1234567890',
    password: 'password123',
    confirmPassword: 'password123',
    role: 'Seeker',
    skills: null,
    experience: null,
  );

  group('RegisterUseCase', () {
    test('should return void when registration is successful', () async {
      // Arrange
      when(() => mockAuthRepository.registerUser(testAuthEntity))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await useCase(testAuthEntity);

      // Assert
      expect(result, Right(null));
      verify(() => mockAuthRepository.registerUser(testAuthEntity)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when registration fails', () async {
      // Arrange
      final failure = ApiFailure(message: "Registration Failed");
      when(() => mockAuthRepository.registerUser(testAuthEntity))
          .thenAnswer((_) async => Left<Failure, void>(failure));

      // Act
      final result = await useCase(testAuthEntity);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.registerUser(testAuthEntity)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
