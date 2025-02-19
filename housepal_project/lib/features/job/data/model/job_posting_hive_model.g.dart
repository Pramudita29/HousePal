// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_posting_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobPostingHiveModelAdapter extends TypeAdapter<JobPostingHiveModel> {
  @override
  final int typeId = 1;

  @override
  JobPostingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobPostingHiveModel(
      id: fields[0] as String?,
      seekerId: fields[1] as String,
      jobDetails: fields[2] as String,
      datePosted: fields[3] as DateTime,
      status: fields[4] as String,
      category: fields[5] as String,
      subCategory: fields[6] as String,
      referenceImages: (fields[7] as List).cast<String>(),
      location: fields[8] as String,
      salaryRange: fields[9] as String,
      contractType: fields[10] as String,
      applicationDeadline: fields[11] as DateTime,
      contactInfo: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JobPostingHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seekerId)
      ..writeByte(2)
      ..write(obj.jobDetails)
      ..writeByte(3)
      ..write(obj.datePosted)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.subCategory)
      ..writeByte(7)
      ..write(obj.referenceImages)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.salaryRange)
      ..writeByte(10)
      ..write(obj.contractType)
      ..writeByte(11)
      ..write(obj.applicationDeadline)
      ..writeByte(12)
      ..write(obj.contactInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobPostingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
