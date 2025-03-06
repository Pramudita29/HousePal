import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';

class JobDetailsView extends StatelessWidget {
  final JobPosting job;

  const JobDetailsView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.jobTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Posted by:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.posterEmail.isNotEmpty
                      ? job.posterEmail
                      : 'Email not specified',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              job.location.isNotEmpty ? job.location : 'Location not specified',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Salary: ${job.salaryRange.isNotEmpty ? job.salaryRange : 'Not specified'}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Category', job.category),
            _buildDetailRow('Contract Type', job.contractType),
            _buildDetailRow('Description', job.jobDescription),
            _buildDetailRow('Application Deadline',
                '${job.applicationDeadline.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 24),
            BlocConsumer<JobApplicationBloc, JobApplicationState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Job application successful!')),
                  );
                } else if (state.errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.errorMessage}')),
                  );
                }
              },
              builder: (context, state) {
                print(
                    'JobApplicationState - isLoading: ${state.isLoading}, helperDetails: ${state.helperDetails}'); // Debug state
                return ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          print(
                              "ApplyForJobEvent dispatched for jobId: ${job.jobId}");
                          context
                              .read<JobApplicationBloc>()
                              .add(ApplyForJobEvent(
                                job.jobId,
                              ));
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Apply for this Job',
                          style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
