import 'package:hive_flutter/hive_flutter.dart';
import 'package:housepal_project/app/constants/hive_table_constant.dart';
import 'package:housepal_project/features/auth/data/model/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  // Initialize Hive and register adapters
  static Future<void> init() async {
    try {
      var directory = await getApplicationDocumentsDirectory();
      var path = '${directory.path}/housepal.db';
      Hive.init(path);

      // Register AuthHiveModel adapter
      if (!Hive.isAdapterRegistered(AuthHiveModelAdapter().typeId)) {
        Hive.registerAdapter(AuthHiveModelAdapter());
      }
    } catch (e) {
      throw Exception("Hive initialization failed: $e");
    }
  }

  // Save user data (Seeker or Helper)
  Future<void> saveRole(String role, AuthHiveModel auth) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(role == "Seeker"
          ? HiveTableConstant.seekerBox
          : HiveTableConstant.helperBox);

      await box.put(auth.userId, auth);
      print("✅ Saved role: $role for ${auth.fullName}");
    } catch (e) {
      throw Exception("Error saving role: $e");
    }
  }

  // Get user data based on email and password (Seeker or Helper)
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      // Check Seeker box
      var seekerBox =
          await Hive.openBox<AuthHiveModel>(HiveTableConstant.seekerBox);
      for (var seeker in seekerBox.values) {
        if (seeker.email == email && seeker.password == password) {
          print("✅ Seeker login success: ${seeker.fullName}");
          return seeker;
        }
      }

      // Check Helper box
      var helperBox =
          await Hive.openBox<AuthHiveModel>(HiveTableConstant.helperBox);
      for (var helper in helperBox.values) {
        if (helper.email == email && helper.password == password) {
          print("✅ Helper login success: ${helper.fullName}");
          return helper;
        }
      }

      print("❌ No user found with these credentials.");
      return null;
    } catch (e) {
      throw Exception("Error during login: $e");
    }
  }

  // Register a new user (Seeker or Helper)
  Future<void> register(AuthHiveModel auth) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(auth.role == "Seeker"
          ? HiveTableConstant.seekerBox
          : HiveTableConstant.helperBox);

      await box.put(auth.userId, auth);
      print("✅ Registered ${auth.role ?? 'Unknown'}: ${auth.fullName}");
    } catch (e) {
      throw Exception("Error registering user: $e");
    }
  }

  // Get the current authenticated user
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      var seekerBox =
          await Hive.openBox<AuthHiveModel>(HiveTableConstant.seekerBox);
      var helperBox =
          await Hive.openBox<AuthHiveModel>(HiveTableConstant.helperBox);

      // Check Seeker box
      if (seekerBox.isNotEmpty) {
        return seekerBox.values.first;
      }

      // Check Helper box
      if (helperBox.isNotEmpty) {
        return helperBox.values.first;
      }

      print("❌ No authenticated user found.");
      return null; // Return null if no authenticated user is found
    } catch (e) {
      throw Exception("Error retrieving current user: $e");
    }
  }

  // Update existing user details
  Future<void> updateUser(AuthHiveModel updatedUser) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(updatedUser.role == "Seeker"
          ? HiveTableConstant.seekerBox
          : HiveTableConstant.helperBox);

      if (box.containsKey(updatedUser.userId)) {
        await box.put(updatedUser.userId, updatedUser);
        print("✅ Updated user: ${updatedUser.fullName}");
      } else {
        throw Exception("User not found for update.");
      }
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }

  // Delete user based on userId and role (Seeker or Helper)
  Future<void> deleteAuth(String userId, String role) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(role == "Seeker"
          ? HiveTableConstant.seekerBox
          : HiveTableConstant.helperBox);

      await box.delete(userId);
      print("🗑 Deleted user with ID: $userId, Role: $role");
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
  }

  // Get all users from Seeker or Helper box
  Future<List<AuthHiveModel>> getAllAuth(String role) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(role == "Seeker"
          ? HiveTableConstant.seekerBox
          : HiveTableConstant.helperBox);

      return box.values.toList();
    } catch (e) {
      throw Exception("Error retrieving users: $e");
    }
  }

  // Clear all users from the Seeker or Helper box
  Future<void> clearAll(String role) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(role == "Seeker"
          ? HiveTableConstant.seekerBox
          : HiveTableConstant.helperBox);

      await box.clear();
      print("🗑 Cleared all users for role: $role");
    } catch (e) {
      throw Exception("Error clearing users: $e");
    }
  }

  // Close the Hive database
  Future<void> close() async {
    try {
      await Hive.close();
      print("📦 Hive database closed");
    } catch (e) {
      throw Exception("Error closing Hive database: $e");
    }
  }
}
