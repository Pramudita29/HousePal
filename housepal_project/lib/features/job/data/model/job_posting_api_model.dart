import 'package:equatable/equatable.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_posting_api_model.g.dart';

@JsonSerializable()
class JobPostingApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? posterEmail;
  final String jobTitle;
  final String jobDescription;
  final DateTime? datePosted;
  final String category;
  final String? subCategory;
  final String? location;
  final String salaryRange;
  final String contractType;
  final DateTime? applicationDeadline;
  final String? contactInfo;
  final String? status;

  const JobPostingApiModel({
    this.id,
    this.posterEmail,
    required this.jobTitle,
    required this.jobDescription,
    this.datePosted,
    required this.category,
    this.subCategory,
    this.location,
    required this.salaryRange,
    required this.contractType,
    this.applicationDeadline,
    this.contactInfo,
    this.status,
  });

  factory JobPostingApiModel.fromJson(Map<String, dynamic> json) =>
      _$JobPostingApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobPostingApiModelToJson(this);

  JobPosting toEntity() => JobPosting(
        jobId: id ?? '',
        jobTitle: jobTitle,
        jobDescription: jobDescription,
        datePosted: datePosted ?? DateTime.now(),
        status: status ?? 'Open',
        category: category,
        subCategory: subCategory ?? '',
        location: location ?? '',
        salaryRange: salaryRange,
        contractType: contractType,
        applicationDeadline:
            applicationDeadline ?? DateTime.now().add(const Duration(days: 7)),
        contactInfo: contactInfo ?? '',
        posterFullName: '', // Not returned by backend, handle elsewhere
        posterEmail: posterEmail ?? '',
        posterImage: '', // Not returned by backend
      );

  static JobPostingApiModel fromEntity(JobPosting job) => JobPostingApiModel(
        id: job.jobId,
        posterEmail: job.posterEmail,
        jobTitle: job.jobTitle,
        jobDescription: job.jobDescription,
        datePosted: job.datePosted,
        category: job.category,
        subCategory: job.subCategory,
        location: job.location,
        salaryRange: job.salaryRange,
        contractType: job.contractType,
        applicationDeadline: job.applicationDeadline,
        contactInfo: job.contactInfo,
        status: job.status,
      );

  @override
  List<Object?> get props => [
        id,
        posterEmail,
        jobTitle,
        jobDescription,
        datePosted,
        category,
        subCategory,
        location,
        salaryRange,
        contractType,
        applicationDeadline,
        contactInfo,
        status,
      ];
}
