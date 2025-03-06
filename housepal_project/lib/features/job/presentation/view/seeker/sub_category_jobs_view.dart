import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/presentation/view/seeker/seeker_job_details_view.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';

class SubcategoryJobsView extends StatelessWidget {
  final String category;
  final String subcategory;

  const SubcategoryJobsView({
    super.key,
    required this.category,
    required this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch all jobs when the page is built
    context.read<JobPostingBloc>().add(GetAllJobsEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(subcategory),
      ),
      body: BlocBuilder<JobPostingBloc, JobPostingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.jobPostings != null) {
            // Filter jobs by the selected category and subcategory
            final filteredJobs = state.jobPostings!
                .where((job) =>
                    job.category == category && job.subCategory == subcategory)
                .toList();

            if (filteredJobs.isEmpty) {
              return const Center(
                  child: Text('No jobs found for this subcategory'));
            }

            return ListView.builder(
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final job = filteredJobs[index];
                return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SeekerJobDetailsView(job: job),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.jobTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              job.subCategory,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              job.jobDescription ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
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
