import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';

class CategoryJobsView extends StatelessWidget {
  final String category;

  const CategoryJobsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Fetch all jobs when the page is built
    context.read<JobPostingBloc>().add(GetAllJobsEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: BlocBuilder<JobPostingBloc, JobPostingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.jobPostings != null) {
            // Filter jobs by the selected category
            final filteredJobs = state.jobPostings!
                .where((job) => job.category == category)
                .toList();

            if (filteredJobs.isEmpty) {
              return const Center(
                  child: Text('No jobs found for this category'));
            }

            return ListView.builder(
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final job = filteredJobs[index];
                return ListTile(
                  title: Text(job.jobTitle),
                  subtitle: Text(job.subCategory),
                );
              },
            );
          } else {
            return const Center(child: Text('No jobs found'));
          }
        },
      ),
    );
  }
}
