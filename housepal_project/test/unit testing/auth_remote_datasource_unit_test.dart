// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:housepal_project/features/auth/data/data_source/auth_remote_datasource.dart';
// import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Mock classes
// class MockDio extends Mock implements Dio {}

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// void main() {
//   late AuthRemoteDataSource authRemoteDataSource;
//   late MockDio mockDio;
//   late MockSharedPreferences mockSharedPreferences;

//   setUp(() {
//     mockDio = MockDio();
//     mockSharedPreferences = MockSharedPreferences();
//     authRemoteDataSource = AuthRemoteDataSource(mockDio);

//     // Registering fallbacks for mocked classes
//     when(() => mockSharedPreferences.getString('token'))
//         .thenReturn('valid_token');
//     when(() => mockSharedPreferences.getString('role')).thenReturn('Seeker');
//   });

//   group('AuthRemoteDataSource', () {
//     test('should return AuthEntity when getCurrentUser is successful',
//         () async {
//       // Arrange: Mock SharedPreferences
//       when(() => mockSharedPreferences.getString('token'))
//           .thenReturn('valid_token');
//       when(() => mockSharedPreferences.getString('role')).thenReturn('Seeker');

//       // Mock Dio response
//       final response = Response(
//         requestOptions: RequestOptions(path: ''),
//         data: {
//           'email': 'test@example.com',
//           'fullName': 'Test User',
//           'contactNo': '1234567890',
//           'role': 'Seeker',
//           'skills': ['Flutter, Dart'],
//           'image': 'image_url',
//           'experience': '2 years',
//         },
//         statusCode: 200,
//       );
//       when(() => mockDio.get(any(), options: any(named: 'options')))
//           .thenAnswer((_) async => response);

//       // Act
//       // final result = await authRemoteDataSource.getCurrentUser();

//       // Assert
//       expect(result, isA<AuthEntity>());
//       expect(result.email, 'test@example.com');
//       expect(result.fullName, 'Test User');
//       verify(() => mockDio.get(any(), options: any(named: 'options')))
//           .called(1);

    
//     });

//     test(
//         'should throw Exception when getCurrentUser fails due to missing token',
//         () async {
//       // Arrange: Mock SharedPreferences
//       when(() => mockSharedPreferences.getString('token')).thenReturn(null);

//       // Act & Assert
//       expect(() => authRemoteDataSource.getCurrentUser(),
//           throwsA(isA<Exception>()));

   
//     });

//     test('should throw Exception when getCurrentUser fails due to invalid role',
//         () async {
//       // Arrange: Mock SharedPreferences
//       when(() => mockSharedPreferences.getString('role')).thenReturn(null);

//       // Act & Assert
//       expect(() => authRemoteDataSource.getCurrentUser(),
//           throwsA(isA<Exception>()));

     
//     });

//     test('should throw Exception when loginUser fails with DioException',
//         () async {
//       // Arrange: Mock Dio response for failed login
//       final dioException = DioException(
//         requestOptions: RequestOptions(path: ''),
//         type: DioExceptionType.badResponse, // Use a valid DioExceptionType
//         error: 'Login error',
//       );
//       when(() => mockDio.post(any(), data: any(named: 'data')))
//           .thenThrow(dioException);

//       // Act & Assert
//       expect(
//           () => authRemoteDataSource.loginUser('email@example.com', 'password'),
//           throwsA(isA<Exception>()));

      
//     });

//     test('should return token when loginUser is successful', () async {
//       // Arrange: Mock Dio response for successful login
//       final response = Response(
//         requestOptions: RequestOptions(path: ''),
//         data: {'token': 'valid_token'},
//         statusCode: 200,
//       );
//       when(() => mockDio.post(any(), data: any(named: 'data')))
//           .thenAnswer((_) async => response);

//       // Act
//       final result =
//           await authRemoteDataSource.loginUser('email@example.com', 'password');

//       // Assert
//       expect(result, 'valid_token');
//       verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);

   
//     });

//     test('should throw Exception when registerUser fails with DioException',
//         () async {
//       // Arrange: Mock Dio response for failed registration
//       final dioException = DioException(
//         requestOptions: RequestOptions(path: ''),
//         type: DioExceptionType.badResponse, // Use a valid DioExceptionType
//         error: 'Registration error',
//       );
//       when(() => mockDio.post(any(), data: any(named: 'data')))
//           .thenThrow(dioException);

//       // Act & Assert
//       expect(
//           () => authRemoteDataSource.registerUser(AuthEntity(
//                 fullName: 'Test User',
//                 email: 'email@example.com',
//                 contactNo: '1234567890',
//                 password: 'password',
//                 confirmPassword: 'password',
//                 role: 'Seeker',
//                 skills: ['Flutter'],
//                 image: 'image_url',
//                 experience: '2 years',
//               )),
//           throwsA(isA<Exception>()));

    
//     });

//     test('should successfully register user when registration is successful',
//         () async {
//       // Arrange: Mock Dio response for successful registration
//       final response = Response(
//         requestOptions: RequestOptions(path: ''),
//         statusCode: 201,
//       );
//       when(() => mockDio.post(any(), data: any(named: 'data')))
//           .thenAnswer((_) async => response);

//       // Act
//       await authRemoteDataSource.registerUser(AuthEntity(
//         fullName: 'Test User',
//         email: 'email@example.com',
//         contactNo: '1234567890',
//         password: 'password',
//         confirmPassword: 'password',
//         role: 'Seeker',
//         skills: ['Flutter'],
//         image: 'image_url',
//         experience: '2 years',
//       ));

//       // Assert
//       verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);

 
//     });

//     test(
//         'should upload profile picture and return URL when uploadProfilePicture is successful',
//         () async {
//       // Arrange: Mock Dio response for successful image upload
//       final response = Response(
//         requestOptions: RequestOptions(path: ''),
//         data: {'success': true, 'data': 'image_url'},
//         statusCode: 200,
//       );
//       when(() => mockDio.post(any(), data: any(named: 'data')))
//           .thenAnswer((_) async => response);

//       // Act
//       final result = await authRemoteDataSource.uploadProfilePicture(
//           File('path/to/image.png'), 'Seeker', 'email@example.com');

//       // Assert
//       expect(result, 'image_url');
//       verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);

      
//     });

//     test('should throw Exception when uploadProfilePicture fails', () async {
//       // Arrange: Mock Dio response for failed image upload
//       final response = Response(
//         requestOptions: RequestOptions(path: ''),
//         data: {'success': false, 'message': 'Upload failed'},
//         statusCode: 400,
//       );
//       when(() => mockDio.post(any(), data: any(named: 'data')))
//           .thenAnswer((_) async => response);

//       // Act & Assert
//       expect(
//           () => authRemoteDataSource.uploadProfilePicture(
//               File('path/to/image.png'), 'Seeker', 'email@example.com'),
//           throwsA(isA<Exception>()));

 
//     });
//   });
// }
