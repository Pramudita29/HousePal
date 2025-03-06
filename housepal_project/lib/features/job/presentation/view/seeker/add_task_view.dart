import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HousePal Project',
      theme: ThemeData(
        primaryColor: Colors.blue, // Set the primary color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // Set the AppBar background color
          foregroundColor: Colors.white, // Set the AppBar text/icon color
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.blue), // Set the label color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // Set the ElevatedButton text color
          ),
        ),
      ),
      home: AddTaskView(),
    );
  }
}

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

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

  String _category = 'Cleaning';
  String _subCategory = 'General Cleaning';
  String _contractType = 'Full-time';
  DateTime _applicationDeadline = DateTime.now().add(const Duration(days: 7));

  String? _fullName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Unknown User';
      _email = prefs.getString('email') ?? 'unknown@example.com';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  items: [
                    'Cleaning',
                    'Elderly Care',
                    'Babysitting',
                    'Cooking',
                    'Gardening Services',
                    'Home Maintenance'
                  ],
                  onChanged: (value) => setState(() {
                    _category = value!;
                    _subCategory = _getSubCategories(_category).first;
                  }),
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
                  onDateSelected: (selectedDate) =>
                      setState(() => _applicationDeadline = selectedDate),
                ),
                _buildTextField(_contactInfoController, 'Contact Info'),
                const SizedBox(height: 12),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      );

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
          {int maxLines = 1}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration:
              InputDecoration(labelText: label, border: OutlineInputBorder()),
          maxLines: maxLines,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      );

  Widget _buildDropdownField(
          {required String value,
          required String label,
          required List<String> items,
          required Function(String?) onChanged}) =>
      Padding(
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

  Widget _buildDatePickerField(
          {required String label,
          required DateTime date,
          required Function(DateTime) onDateSelected}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text('$label: ${date.toLocal().toString().split(' ')[0]}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100));
            if (pickedDate != null) onDateSelected(pickedDate);
          },
        ),
      );

  Widget _buildSubmitButton(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final jobPosting = JobPosting(
                jobId: const Uuid().v4(),
                jobTitle: _jobTitleController.text,
                jobDescription: _jobDetailsController.text,
                category: _category,
                subCategory: _subCategory,
                location: _locationController.text,
                salaryRange: _salaryRangeController.text,
                contractType: _contractType,
                applicationDeadline: _applicationDeadline,
                contactInfo: _contactInfoController.text,
                datePosted: DateTime.now(),
                status: "Open",
                posterFullName: _fullName ?? '',
                posterEmail: _email ?? '',
                posterImage: '',
              );
              context
                  .read<JobPostingBloc>()
                  .add(CreateJobPostingEvent(jobPosting));
              Navigator.pop(context);
            }
          },
          child: const Text('Post Job'),
        ),
      );
}
