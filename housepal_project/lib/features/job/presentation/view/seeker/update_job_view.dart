import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateJobView extends StatefulWidget {
  final JobPosting job;

  const UpdateJobView({super.key, required this.job});

  @override
  _UpdateJobViewState createState() => _UpdateJobViewState();
}

class _UpdateJobViewState extends State<UpdateJobView> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryRangeController = TextEditingController();
  final _contactInfoController = TextEditingController();

  String _category = 'Cleaning';
  String _subCategory = 'General Cleaning';
  String _contractType = 'Full-time';
  DateTime _applicationDeadline = DateTime.now().add(const Duration(days: 7));

  String? _email;
  bool _isLoading = true;

  Future<void> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ??
          widget.job.posterEmail; // Fallback to job's email
      _isLoading = false;
    });
    if (_email == null || _email!.isEmpty) {
      print('Warning: No email found in SharedPreferences or JobPosting');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail();
    _jobTitleController.text = widget.job.jobTitle;
    _jobDescriptionController.text = widget.job.jobDescription;
    _locationController.text = widget.job.location;
    _salaryRangeController.text = widget.job.salaryRange;
    _contactInfoController.text = widget.job.contactInfo;
    _category = widget.job.category;
    _subCategory = widget.job.subCategory;
    _contractType = widget.job.contractType;
    _applicationDeadline = widget.job.applicationDeadline;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Job'),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Job',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                _email ?? 'N/A',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_jobTitleController, 'Job Title'),
              _buildTextField(_jobDescriptionController, 'Job Details',
                  maxLines: 3),
              _buildDropdownField(
                value: _category,
                label: 'Category',
                items: [
                  'Cleaning',
                  'Elderly Care',
                  'Babysitting',
                  'Cooking',
                  'Gardening Services',
                  'Home Maintenance'
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                    _subCategory = _getSubCategories(_category).first;
                  });
                },
              ),
              _buildDropdownField(
                value: _subCategory,
                label: 'Subcategory',
                items: _getSubCategories(_category),
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
              const SizedBox(height: 20),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getSubCategories(String category) {
    switch (category) {
      case 'Cleaning':
        return [
          'General Cleaning',
          'Deep Cleaning',
          'Carpet Cleaning',
          'Window Cleaning',
          'Kitchen Cleaning'
        ];
      case 'Elderly Care':
        return [
          'Daily Assistance',
          'Medical Accompaniment',
          'Meal Preparation',
          'Companionship',
          'Mobility Assistance'
        ];
      case 'Babysitting':
        return [
          'Infant Care',
          'Toddler Care',
          'After-School Care',
          'Overnight Care',
          'Special Needs Care'
        ];
      case 'Cooking':
        return [
          'Meal Prep',
          'Vegetarian Cooking',
          'Gluten-Free Cooking',
          'Party Catering',
          'Dietary Restrictions'
        ];
      case 'Gardening Services':
        return [
          'Lawn Care',
          'Planting',
          'Pruning',
          'Pest Control',
          'Landscape Design'
        ];
      case 'Home Maintenance':
        return [
          'Plumbing',
          'Electrical Work',
          'Painting',
          'Carpentry',
          'Appliance Repair'
        ];
      default:
        return [];
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        maxLines: maxLines,
        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
      ),
    );
  }

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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime date,
    required Function(DateTime) onDateSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('$label: ${date.toLocal().toString().split(' ')[0]}'),
        trailing: const Icon(Icons.calendar_today),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        tileColor: Colors.grey[100],
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) onDateSelected(pickedDate);
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  if (_email == null || _email!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email not available')),
                    );
                    return;
                  }
                  final updatedJob = JobPosting(
                    jobId: widget.job.jobId,
                    jobTitle: _jobTitleController.text,
                    jobDescription: _jobDescriptionController.text,
                    category: _category,
                    subCategory: _subCategory,
                    location: _locationController.text,
                    salaryRange: _salaryRangeController.text,
                    contractType: _contractType,
                    applicationDeadline: _applicationDeadline,
                    contactInfo: _contactInfoController.text,
                    datePosted: widget.job.datePosted,
                    status: widget.job.status,
                    posterFullName: '',
                    posterEmail: _email!,
                    posterImage: '',
                  );
                  context
                      .read<JobPostingBloc>()
                      .add(UpdateJobEvent(widget.job.jobId, updatedJob));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Updating job...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: const Text('Update Job'),
      ),
    );
  }
}
