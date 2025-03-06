import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job_application/domain/entity/job_application.dart';
import 'package:housepal_project/features/job_application/presentation/view_model/job_application_bloc.dart';

class JobApplicationItem extends StatelessWidget {
  final JobApplication jobApplication;
  final String jobTitle;
  final VoidCallback onStatusUpdated;

  const JobApplicationItem({
    super.key,
    required this.jobApplication,
    required this.jobTitle,
    required this.onStatusUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Helper:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Name: ${jobApplication.applicantDetails.fullName}'),
            Text('Email: ${jobApplication.applicantDetails.email}'),
            Text(
                'Contact: ${jobApplication.applicantDetails.contactNo ?? 'N/A'}'),
            if (jobApplication.applicantDetails.skills != null &&
                jobApplication.applicantDetails.skills!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                    'Skills: ${jobApplication.applicantDetails.skills!.join(', ')}'),
              ),
            if (jobApplication.applicantDetails.experience != null &&
                jobApplication.applicantDetails.experience!.isNotEmpty)
              Text('Experience: ${jobApplication.applicantDetails.experience}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status: ${jobApplication.status}',
                    style: const TextStyle(fontSize: 14)),
                DropdownButton<String>(
                  value: jobApplication.status,
                  items: const <String>['pending', 'accepted', 'rejected']
                      .map((value) =>
                          DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null &&
                        newStatus != jobApplication.status) {
                      context
                          .read<JobApplicationBloc>()
                          .add(UpdateApplicationStatusEvent(
                            applicationId: jobApplication.applicationId ?? '',
                            status: newStatus,
                            jobId: jobApplication.jobId, // Pass jobId
                          ));
                      onStatusUpdated();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
