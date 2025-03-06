// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewApiModel _$ReviewApiModelFromJson(Map<String, dynamic> json) =>
    ReviewApiModel(
      id: json['_id'] as String?,
      helperId: json['helperId'] as String?,
      seekerId: json['seekerId'] as String?,
      seekerFullName: json['seekerFullName'] as String?,
      seekerImage: json['seekerImage'] as String?,
      rating: (json['rating'] as num).toInt(),
      comments: json['comments'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ReviewApiModelToJson(ReviewApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'helperId': instance.helperId,
      'seekerId': instance.seekerId,
      'seekerFullName': instance.seekerFullName,
      'seekerImage': instance.seekerImage,
      'rating': instance.rating,
      'comments': instance.comments,
      'createdAt': instance.createdAt,
    };
