import 'package:flutter/material.dart';

class HelperJobsView extends StatefulWidget {
  const HelperJobsView({super.key});

  @override
  State<HelperJobsView> createState() => _HelperJobsViewState();
}

class _HelperJobsViewState extends State<HelperJobsView> {
  String selectedLocation = 'Kathmandu, Nepal'; // Default location
  final List<String> locations = [
    'Kathmandu, Nepal',
    'Lalitpur, Nepal',
    'Bhaktapur, Nepal',
    'Pokhara, Nepal',
    'Chitwan, Nepal',
  ];

  List<Job> jobs = [
    Job('House Cleaning', 'Kathmandu', '15', 'hourly',
        ['Full Time', 'Daily', 'Up to 1 month']),
    Job('Cooking Assistance', 'Lalitpur', '₹12,000', 'monthly',
        ['Part Time', 'Hourly', 'Flexible']),
    Job('Baby Sitting', 'Pokhara', '₹10,000', 'weekly',
        ['Full Time', 'Daily', 'Up to 1 month']),
    Job('House Painting', 'Chitwan', '₹18,000', 'monthly',
        ['Part Time', 'Hourly', 'Flexible']),
    Job('Cleaning Services', 'Bhaktapur', '₹8,000', 'weekly',
        ['Full Time', 'Daily', 'Up to 1 month']),
    Job('Cooking for Events', 'Lalitpur', '₹15,000', 'monthly',
        ['Part Time', 'Hourly', 'Flexible']),
  ];

  List<Job> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    filteredJobs = jobs; // Initialize with all jobs
  }

  void filterJobs(List<String> selectedEmploymentTypes,
      List<String> selectedCategories, List<String> selectedSalaryRanges) {
    setState(() {
      filteredJobs = jobs.where((job) {
        bool matchesEmploymentType = selectedEmploymentTypes.isEmpty ||
            job.tags.any((tag) => selectedEmploymentTypes.contains(tag));
        bool matchesCategory = selectedCategories.isEmpty ||
            job.tags.any((tag) => selectedCategories.contains(tag));
        bool matchesSalaryRange = selectedSalaryRanges.isEmpty ||
            selectedSalaryRanges.contains(job.salaryRange);

        return matchesEmploymentType && matchesCategory && matchesSalaryRange;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jobs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Search jobs that suit you',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Job title or keyword',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                    });
                  },
                  items: locations
                      .map((location) => DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          ))
                      .toList(),
                  underline: const SizedBox(),
                  isExpanded: true,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Apply filters here when the button is clicked
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Search my job',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: FiltersOverlay(
                        onClose: () => Navigator.pop(context),
                        onApplyFilters: filterJobs,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.tune),
                label: const Text('More Filters'),
              ),
              const SizedBox(height: 16),
              const Text(
                'All Jobs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Display filtered jobs
              ...filteredJobs.map((job) => JobCard(job: job)),
            ],
          ),
        ),
      ),
    );
  }
}

class FiltersOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final Function(List<String>, List<String>, List<String>) onApplyFilters;

  const FiltersOverlay({
    super.key,
    required this.onClose,
    required this.onApplyFilters,
  });

  @override
  State<FiltersOverlay> createState() => _FiltersOverlayState();
}

class _FiltersOverlayState extends State<FiltersOverlay> {
  final List<String> selectedEmploymentTypes = [];
  final List<String> selectedCategories = [];
  final List<String> selectedSalaryRanges = [];

  final Map<String, int> employmentTypes = {
    'Full-Time': 5,
    'Part-Time': 8,
  };

  final Map<String, int> categories = {
    'Cooking': 24,
    'Cleaning': 3,
    'Babysitting': 2,
    'Elderly Care': 1,
    'House Maintenance': 6,
    'Gardening and Lawn Care': 4,
  };

  final Map<String, int> salaryRanges = {
    'Rs 700 - 1000': 4,
    'Rs 100 - 1500': 6,
    'Rs 1500 - 2000': 10,
    'Rs 3000 or above': 4,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'More Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection(
                        'Type of Employment',
                        employmentTypes,
                        selectedEmploymentTypes,
                      ),
                      const SizedBox(height: 24),
                      _buildFilterSection(
                        'Categories',
                        categories,
                        selectedCategories,
                      ),
                      const SizedBox(height: 24),
                      _buildFilterSection(
                        'Salary Range',
                        salaryRanges,
                        selectedSalaryRanges,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(selectedEmploymentTypes,
                      selectedCategories, selectedSalaryRanges);
                  widget.onClose();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    Map<String, int> options,
    List<String> selectedOptions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...options.entries.map((entry) {
          final isSelected = selectedOptions.contains(entry.key);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isSelected,
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedOptions.add(entry.key);
                        } else {
                          selectedOptions.remove(entry.key);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  '(${entry.value})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class Job {
  final String title;
  final String location;
  final String salary;
  final String salaryType;
  final List<String> tags;
  late String salaryRange;

  Job(this.title, this.location, this.salary, this.salaryType, this.tags) {
    // Map salary to range for easy filtering
    if (salaryType == 'hourly') {
      salaryRange = 'Rs 700 - 1000'; // Example for hourly
    } else if (salaryType == 'weekly') {
      salaryRange = 'Rs 1000 - 1500'; // Example for weekly
    } else {
      salaryRange = 'Rs 1500 - 2000'; // Example for monthly
    }
  }
}

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    String formattedSalary = '';
    if (job.salaryType == 'hourly') {
      formattedSalary = '${job.salary} per hour';
    } else if (job.salaryType == 'weekly') {
      formattedSalary = '${job.salary} per week';
    } else if (job.salaryType == 'monthly') {
      formattedSalary = '${job.salary} per month';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            job.location,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedSalary,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: job.tags.map((tag) {
              if (tag == 'Full Time' || tag == 'Part Time') {
                return Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                );
              }
              return Chip(
                label: Text(
                  tag,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                backgroundColor: Colors.grey.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
