import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  // Save token
  Future<Either<Failure, bool>> saveToken(String token) async {
    try {
      final success = await _sharedPreferences.setString('token', token);
      print("Token saved: $success");
      return Right(success);
    } catch (e) {
      print("Error saving token: $e");
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve token
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      print("Token retrieved: $token");
      return Right(token);
    } catch (e) {
      print("Error retrieving token: $e");
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's email
  Future<Either<Failure, bool>> saveEmail(String email) async {
    try {
      final success = await _sharedPreferences.setString('email', email);
      print("Email saved: $success");
      return Right(success);
    } catch (e) {
      print("Error saving email: $e");
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's email
  Future<Either<Failure, String?>> getEmail() async {
    try {
      final email = _sharedPreferences.getString('email');
      print("Email retrieved: $email");
      return Right(email);
    } catch (e) {
      print("Error retrieving email: $e");
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's role (Helper or Seeker)
  Future<Either<Failure, bool>> saveRole(String role) async {
    try {
      final success = await _sharedPreferences.setString('role', role);
      print("Role saved: $success");
      return Right(success);
    } catch (e) {
      print("Error saving role: $e");
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's role
  Future<Either<Failure, String?>> getRole() async {
    try {
      final role = _sharedPreferences.getString('role');
      print("Role retrieved: $role");
      return Right(role);
    } catch (e) {
      print("Error retrieving role: $e");
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's profile details (fullName, email, contactNumber)
  Future<void> saveUserDetails(String fullName, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('posterFullName', fullName);
    await prefs.setString('posterEmail', email);

    // Debugging: Print the saved user details
    print('saveUserDetails - Saved Poster Full Name: $fullName');
    print('saveUserDetails - Saved Poster Email: $email');
  }
}
