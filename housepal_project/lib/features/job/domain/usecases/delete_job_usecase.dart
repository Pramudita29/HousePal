import 'package:dartz/dartz.dart';
import 'package:housepal_project/core/error/failure.dart';
import 'package:housepal_project/features/job/data/repositories/job_remote_repository.dart';

class DeleteJobUseCase {
  final JobRemoteRepository jobRepository;

  DeleteJobUseCase(this.jobRepository);

  Future<Either<Failure, void>> call(String jobId) async {
    // Changed to call and void
    return await jobRepository.deleteJob(jobId);
  }
}
