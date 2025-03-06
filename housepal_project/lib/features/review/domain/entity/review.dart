import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String helperEmail;
  final String seekerEmail;
  final String seekerFullName;
  final String? seekerImage;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.helperEmail,
    required this.seekerEmail,
    required this.seekerFullName,
    this.seekerImage,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        helperEmail,
        seekerEmail,
        seekerFullName,
        seekerImage,
        rating,
        comment,
        createdAt
      ];

  ReviewEntity copyWith({
    String? id,
    String? helperEmail,
    String? seekerEmail,
    String? seekerFullName,
    String? seekerImage,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) =>
      ReviewEntity(
        id: id ?? this.id,
        helperEmail: helperEmail ?? this.helperEmail,
        seekerEmail: seekerEmail ?? this.seekerEmail,
        seekerFullName: seekerFullName ?? this.seekerFullName,
        seekerImage: seekerImage ?? this.seekerImage,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
      );
}
