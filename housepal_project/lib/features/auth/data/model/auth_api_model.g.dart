// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      contactNo: json['contactNo'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      image: json['image'] as String?,
      experience: json['experience'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'contactNo': instance.contactNo,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
      'skills': instance.skills,
      'image': instance.image,
      'experience': instance.experience,
    };
