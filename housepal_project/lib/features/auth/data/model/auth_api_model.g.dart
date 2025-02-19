// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['_id'] as String?,
      fullName: (json['fullName'] as String?)?.trim() ??
          "N/A", // Handle null and trim spaces
      email: (json['email'] as String?)?.trim() ??
          "N/A", // Handle null and trim spaces
      contactNo: (json['contactNo'] as String?)?.trim() ??
          "N/A", // Handle null and trim spaces
      password:
          json['password'] as String? ?? "", // Handle null password gracefully
      confirmPassword: json['confirmPassword'] as String? ??
          "", // Handle null confirmPassword gracefully
      role: json['role'] as String? ?? "user", // Default role if not present
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => (e as String?)?.trim() ?? "")
              .toList() ??
          [], // Handle empty or null skills list
      image:
          json['image'] as String? ?? "", // Handle null image path gracefully
      experience: json['experience'] as String? ??
          "No experience listed", // Default experience if not present
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'contactNo': instance.contactNo,
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'role': instance.role,
      'skills': instance.skills,
      'image': instance.image,
      'experience': instance.experience,
    };
