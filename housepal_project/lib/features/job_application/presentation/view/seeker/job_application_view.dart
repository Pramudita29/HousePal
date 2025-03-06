import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/auth/data/repositories/auth_remote_repository.dart';
import 'package:housepal_project/features/job_application/domain/usecases/apply_for_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/get_appication_job_usecase.dart';
import 'package:housepal_project/features/job_application/domain/usecases/update_application_usecase.dart';
import 'package:housepal_project/features/job_application/presentation/view/seeker/job_application_item.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';

class JobApplicationsView extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicationsView({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JobApplicationBloc>(
      create: (context) => JobApplicationBloc(
        applyForJobUseCase: getIt<ApplyForJobUseCase>(),
        getApplicationsForJobUseCase: getIt<GetApplicationsForJobUseCase>(),
        updateApplicationStatusUseCase: getIt<UpdateApplicationStatusUseCase>(),
        authRepo: getIt<AuthRemoteRepository>(),
      )..add(GetApplicationsForJobEvent(jobId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Job Applications'),
          backgroundColor: Colors.green,
        ),
        body: BlocConsumer<JobApplicationBloc, JobApplicationState>(
          listener: (context, state) {
            if (state.appliedJobId != null && state.appliedJobId == jobId) {
              showMySnackBar(
                  context: context,
                  message: 'A Helper has applied for "$jobTitle"!',
                  color: Colors.green);
            }
            if (state.errorMessage.isNotEmpty) {
              showMySnackBar(
                  context: context,
                  message: state.errorMessage,
                  color: Colors.red);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage.isNotEmpty &&
                state.jobApplications == null) {
              return Center(child: Text(state.errorMessage));
            }
            if (state.jobApplications == null ||
                state.jobApplications!.isEmpty) {
              return const Center(child: Text('No applications for this job.'));
            }
            return ListView.builder(
              itemCount: state.jobApplications!.length,
              itemBuilder: (context, index) {
                final jobApplication = state.jobApplications![index];
                return JobApplicationItem(
                  jobApplication: jobApplication,
                  jobTitle: jobTitle,
                  onStatusUpdated: () {
                    // No immediate refresh here; let the bloc handle it
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
