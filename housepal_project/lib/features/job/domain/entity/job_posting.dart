import 'package:equatable/equatable.dart';

class JobPosting extends Equatable {
  final String jobId;
  final String jobTitle;
  final String jobDescription; // Renamed from jobDetails
  final DateTime datePosted;
  final String status; // Open, booked, completed, cancelled
  final String category;
  final String subCategory; // E.g., deep cleaning, babysitting
  final String location;
  final String salaryRange;
  final String contractType; // Part-time, Full-time
  final DateTime applicationDeadline;
  final String contactInfo; // Contact information for applying
  final String posterFullName;  // Poster's full name
  final String posterEmail;     // Poster's email
  final String posterImage;     // Poster's image

  const JobPosting({
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription, // Renamed from jobDetails
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

  @override
  List<Object?> get props => [
        jobId,
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

  JobPosting copyWith({
    String? jobId,
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
    return JobPosting(
      jobId: jobId ?? this.jobId,
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

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      jobId: json['_id'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      jobDescription: json['jobDescription'] ?? '',
      datePosted: DateTime.parse(json['datePosted'] ?? DateTime.now().toString()),
      status: json['status'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      location: json['location'] ?? '',
      salaryRange: json['salaryRange'] ?? '',
      contractType: json['contractType'] ?? '',
      applicationDeadline: DateTime.parse(json['applicationDeadline'] ?? DateTime.now().toString()),
      contactInfo: json['contactInfo'] ?? '',
      posterFullName: json['posterFullName'] ?? '',
      posterEmail: json['posterEmail'] ?? '',
      posterImage: json['posterImage'] ?? '',
    );
  }
}