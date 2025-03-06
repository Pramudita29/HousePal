import 'package:housepal_project/features/review/domain/entity/review.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? helperId;
  final String? seekerId;
  final String? seekerFullName; // Made nullable
  final String? seekerImage;
  final int rating;
  final String? comments;
  final String? createdAt;

  ReviewApiModel({
    this.id,
    this.helperId,
    this.seekerId,
    this.seekerFullName,
    this.seekerImage,
    required this.rating,
    this.comments,
    this.createdAt,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) {
    print('Parsing review JSON: $json'); // Debug log
    return _$ReviewApiModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  ReviewEntity toEntity() => ReviewEntity(
        id: id ?? '',
        helperEmail: helperId ?? '',
        seekerEmail: seekerId ?? '',
        seekerFullName: seekerFullName ?? 'Unknown', // Fallback for null
        seekerImage: seekerImage,
        rating: rating,
        comment: comments,
        createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
      );
}
