import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';

part 'job_posting_api_model.g.dart'; // This links the generated file

@JsonSerializable()
class JobPostingApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String jobTitle;
  final String jobDescription; // Renamed from jobDetails
  final DateTime datePosted;
  final String status;
  final String category;
  final String? subCategory; // Nullable
  final String? location; // Nullable
  final String salaryRange;
  final String contractType;
  final DateTime applicationDeadline;
  final String? contactInfo; // Nullable
  final String? posterFullName; // Nullable
  final String? posterEmail; // Nullable
  final String? posterImage; // Nullable

  const JobPostingApiModel({
    this.id,
    required this.jobTitle,
    required this.jobDescription, // Renamed from jobDetails
    required this.datePosted,
    required this.status,
    required this.category,
    this.subCategory,
    this.location,
    required this.salaryRange,
    required this.contractType,
    required this.applicationDeadline,
    this.contactInfo,
    this.posterFullName,
    this.posterEmail,
    this.posterImage,
  });

  factory JobPostingApiModel.fromJson(Map<String, dynamic> json) =>
      _$JobPostingApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobPostingApiModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    jobTitle,
    jobDescription, // Renamed from jobDetails
    datePosted,
    status,
    category,
    subCategory,
    location,
    salaryRange,
    contractType,
    applicationDeadline,
    contactInfo,
    posterFullName,
    posterEmail,
    posterImage,
  ];

  JobPosting toEntity() {
    return JobPosting(
      jobId: id ?? '',
      jobTitle: jobTitle,
      jobDescription: jobDescription, // Renamed from jobDetails
      datePosted: datePosted,
      status: status,
      category: category,
      subCategory: subCategory ?? '',
      location: location ?? '',
      salaryRange: salaryRange,
      contractType: contractType,
      applicationDeadline: applicationDeadline,
      contactInfo: contactInfo ?? '',
      posterFullName: posterFullName ?? '',
      posterEmail: posterEmail ?? '',
      posterImage: posterImage ?? '',
    );
  }

  static JobPostingApiModel fromEntity(JobPosting jobPosting) {
    return JobPostingApiModel(
      id: jobPosting.jobId,
      jobTitle: jobPosting.jobTitle,
      jobDescription: jobPosting.jobDescription, // Renamed from jobDetails
      datePosted: jobPosting.datePosted,
      status: jobPosting.status,
      category: jobPosting.category,
      subCategory: jobPosting.subCategory,
      location: jobPosting.location,
      salaryRange: jobPosting.salaryRange,
      contractType: jobPosting.contractType,
      applicationDeadline: jobPosting.applicationDeadline,
      contactInfo: jobPosting.contactInfo,
      posterFullName: jobPosting.posterFullName,
      posterEmail: jobPosting.posterEmail,
      posterImage: jobPosting.posterImage,
    );
  }

  JobPostingApiModel copyWith({
    String? id,
    String? jobTitle,
    String? jobDescription, // Renamed from jobDetails
    DateTime? datePosted,
    String? status,
    String? category,
    String? subCategory,
    String? location,
    String? salaryRange,
    String? contractType,
    DateTime? applicationDeadline,
    String? contactInfo,
    String? posterFullName,
    String? posterEmail,
    String? posterImage,
  }) {
    return JobPostingApiModel(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      jobDescription: jobDescription ?? this.jobDescription, // Renamed from jobDetails
      datePosted: datePosted ?? this.datePosted,
      status: status ?? this.status,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      location: location ?? this.location,
      salaryRange: salaryRange ?? this.salaryRange,
      contractType: contractType ?? this.contractType,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      contactInfo: contactInfo ?? this.contactInfo,
      posterFullName: posterFullName ?? this.posterFullName,
      posterEmail: posterEmail ?? this.posterEmail,
      posterImage: posterImage ?? this.posterImage,
    );
  }
}