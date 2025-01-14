import 'package:hive_flutter/hive_flutter.dart';
import 'package:housepal_project/app/constants/hive_table_constant.dart';
import 'package:housepal_project/features/auth/data/model/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  // Initialize Hive and register adapters
  static Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/housepal.db';
    Hive.init(path);

    // Register AuthHiveModel adapter
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  // Save the role after registration
  Future<void> saveRole(String role) async {
    var box = await Hive.openBox('userBox');
    await box.put('role', role);
  }

  // Get role to navigate to the correct dashboard
  Future<String> getRole() async {
    var box = await Hive.openBox('userBox');
    return box.get('role', defaultValue: ''); // Default to empty if not found
  }

  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Login using username and password
  Future<AuthHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var student = box.values.firstWhere(
        (element) => element.email == email && element.password == password);
    box.close();
    return student;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
