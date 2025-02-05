import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String fullName;

  final String contactNo;

  final String email;

  final String password;

  final String confirmPassword;

  final String role;
  final List? skills;
  final String? image;
  final String? experience;

  const AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.confirmPassword,
    required this.role,
    this.skills,
    this.image,
    this.experience,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: id,
      fullName: fullName,
      email: email,
      contactNo: contactNo,
      password: password,
      confirmPassword: confirmPassword,
      role: role,
      skills: skills,
      image: image,
      experience: experience,
    );
  }

  // From Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      contactNo: entity.contactNo,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      role: entity.role,
      skills: entity.skills,
      image: entity.image,
      experience: entity.experience,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        contactNo,
        password,
        confirmPassword,
        role,
        skills,
        experience,
      ];
}
