import 'package:flutter/material.dart';

class FiltersOverlay extends StatefulWidget {
  final Function(List<String> contractTypes, List<String> categories,
      List<String> locations, List<String> salaryRanges) onApplyFilters;

  const FiltersOverlay({super.key, required this.onApplyFilters});

  @override
  _FiltersOverlayState createState() => _FiltersOverlayState();
}

class _FiltersOverlayState extends State<FiltersOverlay> {
  List<String> availableContractTypes = ['Full-time', 'Part-time', 'Temporary'];
  List<String> availableCategories = [
    'Cleaning',
    'Cooking',
    'Babysitting',
    'Elderly Care',
    'Gardening Services',
    'Home Maintenance'
  ];
  List<String> availableLocations = [
    'Kathmandu',
    'Pokhara',
    'Biratnagar',
    'Lalitpur'
  ];
  List<String> availableSalaryRanges = [
    '10000-20000',
    '20000-30000',
    '30000-40000',
    '40000-50000'
  ];

  List<String> selectedContractTypes = [];
  List<String> selectedCategories = [];
  List<String> selectedLocations = [];
  List<String> selectedSalaryRanges = [];

  @override
  Widget build(BuildContext context) => Material(
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
                    const Text('Apply Filters',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop()),
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
                        _buildFilterSection('Contract Type',
                            availableContractTypes, selectedContractTypes),
                        const SizedBox(height: 24),
                        _buildFilterSection('Categories', availableCategories,
                            selectedCategories),
                        const SizedBox(height: 24),
                        _buildFilterSection(
                            'Locations', availableLocations, selectedLocations),
                        const SizedBox(height: 24),
                        _buildFilterSection('Salary Range',
                            availableSalaryRanges, selectedSalaryRanges),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(
                        selectedContractTypes,
                        selectedCategories,
                        selectedLocations,
                        selectedSalaryRanges);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Apply',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildFilterSection(
          String title, List<String> options, List<String> selectedOptions) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...options.map((option) {
            bool isSelected = selectedOptions.contains(option);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onChanged: (bool? value) => setState(() => value == true
                        ? selectedOptions.add(option)
                        : selectedOptions.remove(option)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child:
                          Text(option, style: const TextStyle(fontSize: 14))),
                ],
              ),
            );
          }),
        ],
      );
}
