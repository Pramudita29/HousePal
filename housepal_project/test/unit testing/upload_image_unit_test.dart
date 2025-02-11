import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/auth/domain/repository/auth_repository.dart';
import 'package:housepal_project/features/dashboard/domain/upload_image_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Mocking dependencies
class MockAuthRepository extends Mock implements IAuthRepository {}

class MockFile extends Mock implements File {}

void main() {
  // Register a fallback value for File type
  setUpAll(() {
    registerFallbackValue(MockFile());
  });

  late UploadImageUsecase uploadImageUsecase;
  late MockAuthRepository mockAuthRepository;
  late MockFile mockFile;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockFile = MockFile();
    uploadImageUsecase = UploadImageUsecase(mockAuthRepository);
  });

  group('UploadImageUsecase', () {
    const tRole = 'Seeker';
    const tEmail = 'testuser@example.com';
    const tImageUrl = 'https://example.com/path/to/image.png';

    test('should return image URL when image upload is successful', () async {
      // Arrange
      when(() => mockAuthRepository.uploadProfilePicture(any(), tRole, tEmail))
          .thenAnswer((_) async => Right(tImageUrl));

      // Act
      final result = await uploadImageUsecase(UploadImageParams(
        file: mockFile,
        role: tRole,
        email: tEmail,
      ));

      // Assert
      expect(result, Right(tImageUrl));
      verify(() =>
              mockAuthRepository.uploadProfilePicture(mockFile, tRole, tEmail))
          .called(1);
    });

    test('should return failure when image upload fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Upload failed');
      when(() => mockAuthRepository.uploadProfilePicture(any(), tRole, tEmail))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await uploadImageUsecase(UploadImageParams(
        file: mockFile,
        role: tRole,
        email: tEmail,
      ));

      // Assert
      expect(result, Left(failure));
      verify(() =>
              mockAuthRepository.uploadProfilePicture(mockFile, tRole, tEmail))
          .called(1);
    });

    test(
        'should return failure when uploadProfilePicture throws unexpected error',
        () async {
      // Arrange: Mocking an unexpected exception
      final failure = ApiFailure(message: 'Unexpected error');
      when(() => mockAuthRepository.uploadProfilePicture(any(), tRole, tEmail))
          .thenThrow(Exception('Unexpected error'));

      // Act
      final result = await uploadImageUsecase(UploadImageParams(
        file: mockFile,
        role: tRole,
        email: tEmail,
      ));

      // Assert
      expect(result,
          Left(failure)); // Ensure the exception is wrapped into a Failure
      verify(() =>
              mockAuthRepository.uploadProfilePicture(mockFile, tRole, tEmail))
          .called(1);
    });
  });
}
