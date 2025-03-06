import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:housepal_project/features/auth/domain/usecase/login_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  // Initialize the binding before running tests
  TestWidgetsFlutterBinding.ensureInitialized();

  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      'token': '', // Initial empty token value
    });

    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  group('LoginUseCase', () {
    const tEmail = 'testuser@example.com';
    const tPassword = 'testpass';
    const tToken = 'valid_token';

    test('should return token when login is successful', () async {
      // Arrange
      when(() => mockAuthRepository.loginUser(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tToken));

      // Act
      final result = await loginUseCase(
          const LoginParams(email: tEmail, password: tPassword));

      // Assert
      expect(result, const Right(tToken));
      verify(() => mockAuthRepository.loginUser(tEmail, tPassword)).called(1);

      // Verify SharedPreferences was updated
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), tToken);
    });

    test('should return failure when login fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Login failed');
      when(() => mockAuthRepository.loginUser(tEmail, tPassword))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await loginUseCase(
          const LoginParams(email: tEmail, password: tPassword));

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.loginUser(tEmail, tPassword)).called(1);
    });
  });
}
