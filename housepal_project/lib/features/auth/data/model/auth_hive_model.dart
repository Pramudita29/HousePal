import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:housepal_project/app/constants/hive_table_constant.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart'; // For generating unique user IDs

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final String role;

  @HiveField(6)
  final List? skills;

  @HiveField(7)
  final String? experience;

  // Normal constructor, userId will be generated at runtime
  AuthHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.skills,
    this.experience,
  }) : userId = userId ?? Uuid().v4();  // Generate userId only when needed

  // Updated initial constructor with proper defaults
  AuthHiveModel.initial()
      : userId = Uuid().v4(),  // Generate userId at runtime
        fullName = '',
        email = '',
        phone = '',
        password = '',
        role = '',
        skills = const [],
        experience = null;

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
      role: entity.role,
      skills: entity.skills,
      experience: entity.experience,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
      skills: skills,
      experience: experience, confirmpassword: '',
    );
  }

  @override
  List<Object?> get props =>
      [userId, fullName, email, phone, password, role, skills, experience];
}
