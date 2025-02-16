import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/dashboard/domain/usecase/get_user_usecase.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add shared_preferences import if you haven't

class AddTaskView extends StatefulWidget {
  final GetUserUseCase getUserUseCase;

  const AddTaskView({super.key, required this.getUserUseCase});

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _jobDetailsController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryRangeController = TextEditingController();
  final _contactInfoController = TextEditingController();
  String _category = 'Housekeeping';
  String _subCategory = 'Cleaning';
  String _contractType = 'Full-time';
  DateTime _applicationDeadline = DateTime.now().add(Duration(days: 7));
  final List<File> _referenceImages = [];

  Future<String?> _getPosterId() async {
    // Retrieve the posterId (seekerId or userId) from SharedPreferences or another service.
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('userId'); // Assuming 'userId' was saved during login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_jobTitleController, 'Job Title'),
              _buildTextField(_jobDetailsController, 'Job Details',
                  maxLines: 3),
              _buildDropdownField(
                value: _category,
                label: 'Category',
                items: ['Housekeeping', 'Gardening', 'Cooking'],
                onChanged: (value) => setState(() => _category = value!),
              ),
              _buildDropdownField(
                value: _subCategory,
                label: 'Subcategory',
                items: ['Cleaning', 'Carpet Cleaning', 'Window Cleaning'],
                onChanged: (value) => setState(() => _subCategory = value!),
              ),
              _buildTextField(_locationController, 'Location'),
              _buildTextField(_salaryRangeController, 'Salary Range'),
              _buildDropdownField(
                value: _contractType,
                label: 'Contract Type',
                items: ['Full-time', 'Part-time', 'Temporary'],
                onChanged: (value) => setState(() => _contractType = value!),
              ),
              _buildDatePickerField(
                label: 'Application Deadline',
                date: _applicationDeadline,
                onDateSelected: (selectedDate) {
                  setState(() => _applicationDeadline = selectedDate);
                },
              ),
              _buildTextField(_contactInfoController, 'Contact Info'),
              const SizedBox(height: 12),
              _buildImagePickerSection(),
              const SizedBox(height: 20),
              _buildSubmitButton(context),
              BlocListener<JobPostingBloc, JobPostingState>(
                listener: (context, state) {
                  if (state.isLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Posting job...')),
                    );
                  } else if (state.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Job posted successfully!')),
                    );
                    Navigator.pop(context);
                  } else if (state.errorMessage.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.errorMessage}')),
                    );
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Reusable TextField Widget**
  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        maxLines: maxLines,
        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
      ),
    );
  }

  /// **Reusable Dropdown Field Widget**
  Widget _buildDropdownField({
    required String value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  /// **Date Picker Field**
  Widget _buildDatePickerField(
      {required String label,
      required DateTime date,
      required Function(DateTime) onDateSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('$label: ${date.toLocal().toString().split(' ')[0]}'),
        trailing: const Icon(Icons.calendar_today),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        },
      ),
    );
  }

  /// **Image Picker Section**
  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reference Images",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _referenceImages
              .map((file) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(file,
                          width: 80, height: 80, fit: BoxFit.cover),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _referenceImages.remove(file);
                          });
                        },
                        child: const Icon(Icons.cancel,
                            color: Colors.red, size: 20),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }

  /// **Submit Button**
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            final posterId = await _getPosterId(); // Get the poster ID

            if (posterId != null) {
              final jobPosting = JobPosting(
                jobId: '',
                jobTitle: _jobTitleController.text,
                jobDetails: _jobDetailsController.text,
                datePosted: DateTime.now(),
                status: 'Open',
                category: _category,
                subCategory: _subCategory,
                location: _locationController.text,
                salaryRange: _salaryRangeController.text,
                contractType: _contractType,
                applicationDeadline: _applicationDeadline,
                contactInfo: _contactInfoController.text,
                posterId: posterId, // Pass the posterId here
              );

              BlocProvider.of<JobPostingBloc>(context)
                  .add(CreateJobPostingEvent(jobPosting));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: Unable to get user ID')),
              );
            }
          }
        },
        child: const Text('Post Job'),
      ),
    );
  }
}
