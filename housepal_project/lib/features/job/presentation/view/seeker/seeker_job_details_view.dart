import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/presentation/view/seeker/update_job_view.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';

class SeekerJobDetailsView extends StatelessWidget {
  final JobPosting job;

  const SeekerJobDetailsView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          job.jobTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<JobPostingBloc, JobPostingState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  job.posterEmail.isNotEmpty ? job.posterEmail : 'N/A',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Category', job.category),
                        _buildDetailRow('Subcategory', job.subCategory),
                        _buildDetailRow('Location', job.location),
                        _buildDetailRow('Salary Range', job.salaryRange),
                        _buildDetailRow('Contract Type', job.contractType),
                        _buildDetailRow(
                          'Application Deadline',
                          job.applicationDeadline
                              .toLocal()
                              .toString()
                              .split('.')[0],
                        ),
                        _buildDetailRow('Contact Info', job.contactInfo),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context: context,
                      label: 'Update',
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateJobView(job: job),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      context: context,
                      label: 'Delete',
                      color: Colors.red,
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, job.jobId),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this job?'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                print('Deleting job with jobId: $jobId');
                context.read<JobPostingBloc>().add(DeleteJobEvent(jobId));
                Navigator.pop(context); // Close dialog
                // Wait for Bloc state update before popping back
                context
                    .read<JobPostingBloc>()
                    .stream
                    .firstWhere((state) => !state.isLoading)
                    .then((_) {
                  Navigator.pop(context); // Go back to previous screen
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
