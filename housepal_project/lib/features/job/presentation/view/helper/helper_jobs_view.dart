import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/job/domain/entity/job_posting.dart';
import 'package:housepal_project/features/job/presentation/view/helper/filters_overlay.dart';
import 'package:housepal_project/features/job/presentation/view_model/job_bloc.dart';
import 'package:housepal_project/features/job_application/presentation/view/helper/job_details_view.dart';

class HelperJobsView extends StatefulWidget {
  const HelperJobsView({super.key});

  @override
  State<HelperJobsView> createState() => _HelperJobsViewState();
}

class _HelperJobsViewState extends State<HelperJobsView> {
  String searchQuery = '';
  List<String> selectedContractTypes = [];
  List<String> selectedCategories = [];
  List<String> selectedLocations = [];
  List<String> selectedSalaryRanges = [];
  List<JobPosting> allJobs = [];
  List<JobPosting> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    context.read<JobPostingBloc>().add(const GetAllJobsEvent());
  }

  void _updateFilteredJobs() {
    setState(() {
      filteredJobs = allJobs.where((job) {
        // Search filter
        final query = searchQuery.toLowerCase().trim();
        final matchesSearch = query.isEmpty ||
            (job.jobTitle.toLowerCase().contains(query) ?? false) ||
            (job.location.toLowerCase().contains(query) ?? false) ||
            (job.category.toLowerCase().contains(query) ?? false);

        // Contract type filter
        final matchesContractType = selectedContractTypes.isEmpty ||
            selectedContractTypes.contains(job.contractType);

        // Category filter
        final matchesCategory = selectedCategories.isEmpty ||
            selectedCategories.contains(job.category);

        // Location filter
        final matchesLocation = selectedLocations.isEmpty ||
            selectedLocations.contains(job.location);

        // Salary range filter
        final matchesSalaryRange = selectedSalaryRanges.isEmpty ||
            selectedSalaryRanges.contains(job.salaryRange);

        // Debug print for each job
        print(
            'Job: ${job.jobTitle}, Category: ${job.category}, Location: ${job.location}, '
            'Contract: ${job.contractType}, Salary: ${job.salaryRange}, '
            'Query: $query, Matches Search: $matchesSearch, '
            'Matches Contract: $matchesContractType, Matches Category: $matchesCategory, '
            'Matches Location: $matchesLocation, Matches Salary: $matchesSalaryRange');

        return matchesSearch &&
            matchesContractType &&
            matchesCategory &&
            matchesLocation &&
            matchesSalaryRange;
      }).toList();

      print('Filtered Jobs Count: ${filteredJobs.length}');
      print('Selected Filters - Contract: $selectedContractTypes, '
          'Categories: $selectedCategories, Locations: $selectedLocations, '
          'Salary: $selectedSalaryRanges');
    });
  }

  void _applyFilters(List<String> contractTypes, List<String> categories,
      List<String> locations, List<String> salaryRanges) {
    setState(() {
      selectedContractTypes = contractTypes;
      selectedCategories = categories;
      selectedLocations = locations;
      selectedSalaryRanges = salaryRanges;
      _updateFilteredJobs();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<JobPostingBloc, JobPostingState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
            if (state.jobPostings != null) {
              setState(() {
                allJobs = state.jobPostings!;
                filteredJobs = List.from(allJobs);
                _updateFilteredJobs();
              });
              print('All Jobs Loaded: ${allJobs.length}');
              // Print sample job data
              if (allJobs.isNotEmpty) {
                print('Sample Job: ${allJobs.first.jobTitle}, '
                    'Category: ${allJobs.first.category}, '
                    'Location: ${allJobs.first.location}, '
                    'Contract: ${allJobs.first.contractType}, '
                    'Salary: ${allJobs.first.salaryRange}');
              }
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.jobPostings == null || state.jobPostings!.isEmpty) {
              return const Center(child: Text("No jobs available"));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Jobs',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Search jobs that suit you',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                          _updateFilteredJobs();
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Job title or keyword',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        selectedContractTypes = [];
                        selectedCategories = [];
                        selectedLocations = [];
                        selectedSalaryRanges = [];
                        filteredJobs = List.from(allJobs);
                      });
                      context
                          .read<JobPostingBloc>()
                          .add(const GetAllJobsEvent());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Search my job',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: FiltersOverlay(onApplyFilters: _applyFilters),
                      ),
                    ),
                    icon: const Icon(Icons.tune),
                    label: const Text('More Filters'),
                  ),
                  const SizedBox(height: 16),
                  const Text('All Jobs',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (filteredJobs.isEmpty)
                    const Center(child: Text("No jobs match your criteria"))
                  else
                    ...filteredJobs.map((job) => JobCard(job: job)),
                ],
              ),
            );
          },
        ),
      );
}

class JobCard extends StatelessWidget {
  final JobPosting job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailsView(job: job)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.jobTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job.location, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(job.salaryRange,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(job.category,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: Colors.green,
                ),
                if (job.contractType.isNotEmpty)
                  Chip(
                    label: Text(job.contractType,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                    backgroundColor: Colors.green.shade700,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
