import 'package:equatable/equatable.dart';

class JobPosting extends Equatable {
  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final DateTime datePosted;
  final String status;
  final String category;
  final String subCategory;
  final String location;
  final String salaryRange;
  final String contractType;
  final DateTime applicationDeadline;
  final String contactInfo;
  final String posterFullName;
  final String posterEmail;
  final String posterImage;

  const JobPosting({
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.datePosted,
    required this.status,
    required this.category,
    required this.subCategory,
    required this.location,
    required this.salaryRange,
    required this.contractType,
    required this.applicationDeadline,
    required this.contactInfo,
    required this.posterFullName,
    required this.posterEmail,
    required this.posterImage,
  });

  JobPosting copyWith({
    String? jobId,
    String? jobTitle,
    String? jobDescription,
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
  }) =>
      JobPosting(
        jobId: jobId ?? this.jobId,
        jobTitle: jobTitle ?? this.jobTitle,
        jobDescription: jobDescription ?? this.jobDescription,
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

  @override
  List<Object?> get props => [
        jobId,
        jobTitle,
        jobDescription,
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
}
