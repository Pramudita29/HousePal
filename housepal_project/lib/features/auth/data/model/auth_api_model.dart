import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: 'id') // Map '_id' from backend to 'id'
  final String? id;

  final String? fullName;
  final String? contactNo;
  final String? email;
  final String? password; // Only sent in requests, not responses
  final String? role;
  final List<String>? skills; // Changed to List<String> to match backend
  final String? image;
  final String? experience;

  const AuthApiModel({
    this.id,
    this.fullName,
    this.email,
    this.contactNo,
    this.password,
    this.role,
    this.skills,
    this.image,
    this.experience,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  AuthEntity toEntity() {
    return AuthEntity(
      userId: id ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      contactNo: contactNo ?? '',
      password: password ?? '',
      confirmPassword: password ?? '', // Not in response, default to password
      role: role ?? '',
      skills: skills ?? [],
      image: image ?? '',
      experience: experience ?? '',
    );
  }

  static AuthApiModel fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      contactNo: entity.contactNo,
      password: entity.password,
      role: entity.role,
      skills: entity.skills?.cast<String>(),
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
        role,
        skills,
        image,
        experience,
      ];
}
