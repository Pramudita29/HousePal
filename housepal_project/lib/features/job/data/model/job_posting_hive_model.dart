import 'package:hive/hive.dart';

part 'job_posting_hive_model.g.dart';

@HiveType(typeId: 1)
class JobPostingHiveModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String seekerId;

  @HiveField(2)
  final String jobDetails;

  @HiveField(3)
  final DateTime datePosted;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String subCategory;

  @HiveField(7)
  final List<String> referenceImages;

  @HiveField(8)
  final String location;

  @HiveField(9)
  final String salaryRange;

  @HiveField(10)
  final String contractType;

  @HiveField(11)
  final DateTime applicationDeadline;

  @HiveField(12)
  final String contactInfo;

  JobPostingHiveModel({
    this.id,
    required this.seekerId,
    required this.jobDetails,
    required this.datePosted,
    required this.status,
    required this.category,
    required this.subCategory,
    required this.referenceImages,
    required this.location,
    required this.salaryRange,
    required this.contractType,
    required this.applicationDeadline,
    required this.contactInfo,
  });

  factory JobPostingHiveModel.fromJson(Map<String, dynamic> json) {
    return JobPostingHiveModel(
      id: json['_id'] as String?,
      seekerId: json['seekerId'] as String,
      jobDetails: json['jobDetails'] as String,
      datePosted: DateTime.parse(json['datePosted']),
      status: json['status'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      referenceImages: List<String>.from(json['reference_images']),
      location: json['location'] as String,
      salaryRange: json['salaryRange'] as String,
      contractType: json['contractType'] as String,
      applicationDeadline: DateTime.parse(json['applicationDeadline']),
      contactInfo: json['contactInfo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'seekerId': seekerId,
      'jobDetails': jobDetails,
      'datePosted': datePosted.toIso8601String(),
      'status': status,
      'category': category,
      'subCategory': subCategory,
      'reference_images': referenceImages,
      'location': location,
      'salaryRange': salaryRange,
      'contractType': contractType,
      'applicationDeadline': applicationDeadline.toIso8601String(),
      'contactInfo': contactInfo,
    };
  }
}
