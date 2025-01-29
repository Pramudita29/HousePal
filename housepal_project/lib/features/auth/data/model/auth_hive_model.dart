import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:housepal_project/app/constants/hive_table_constant.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

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
  final String contactNo;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final String role;

  @HiveField(6)
  final List<String>? skills;

  @HiveField(7)
  final String? experience;

  AuthHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.role,
    this.skills,
    this.experience,
  }) : userId = userId ?? const Uuid().v4();

  AuthHiveModel.initial()
      : userId = const Uuid().v4(),
        fullName = '',
        email = '',
        contactNo = '',
        password = '',
        role = '',
        skills = null,
        experience = null;

  factory AuthHiveModel.fromEntity(AuthEntity entity) => AuthHiveModel(
        userId: entity.userId,
        fullName: entity.fullName,
        email: entity.email,
        contactNo: entity.contactNo,
        password: entity.password,
        role: entity.role,
        skills: entity.skills?.cast<String>(),
        experience: entity.experience,
      );

  AuthEntity toEntity() => AuthEntity(
        userId: userId,
        fullName: fullName,
        email: email,
        contactNo: contactNo,
        password: password,
        confirmPassword: password,
        role: role,
        skills: skills,
        experience: experience,
      );

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        contactNo,
        password,
        role,
        skills,
        experience,
      ];
}
