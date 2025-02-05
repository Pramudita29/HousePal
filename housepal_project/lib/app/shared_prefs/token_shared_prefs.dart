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
      return Right(success);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve token
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's full name
  Future<Either<Failure, bool>> saveFullName(String fullName) async {
    try {
      final success = await _sharedPreferences.setString('fullName', fullName);
      return Right(success);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's full name
  Future<Either<Failure, String?>> getFullName() async {
    try {
      final fullName = _sharedPreferences.getString('fullName');
      return Right(fullName);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's email
  Future<Either<Failure, bool>> saveEmail(String email) async {
    try {
      final success = await _sharedPreferences.setString('email', email);
      return Right(success);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's email
  Future<Either<Failure, String?>> getEmail() async {
    try {
      final email = _sharedPreferences.getString('email');
      return Right(email);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's role (Helper or Seeker)
  Future<Either<Failure, bool>> saveRole(String role) async {
    try {
      final success = await _sharedPreferences.setString('role', role);
      return Right(success);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's role
  Future<Either<Failure, String?>> getRole() async {
    try {
      final role = _sharedPreferences.getString('role');
      return Right(role);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's experience
  Future<Either<Failure, bool>> saveExperience(String experience) async {
    try {
      final success =
          await _sharedPreferences.setString('experience', experience);
      return Right(success);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's experience
  Future<Either<Failure, String?>> getExperience() async {
    try {
      final experience = _sharedPreferences.getString('experience');
      return Right(experience);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Save the user's skills
  Future<Either<Failure, bool>> saveSkills(List<String> skills) async {
    try {
      final success = await _sharedPreferences.setStringList('skills', skills);
      return Right(success);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Retrieve the user's skills
  Future<Either<Failure, List<String>>> getSkills() async {
    try {
      final skills = _sharedPreferences.getStringList('skills') ?? [];
      return Right(skills);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
