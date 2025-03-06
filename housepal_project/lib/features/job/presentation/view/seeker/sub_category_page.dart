import 'package:flutter/material.dart';
import 'package:housepal_project/features/job/presentation/view/seeker/sub_category_jobs_view.dart';

class SubcategoryView extends StatelessWidget {
  final String category;

  const SubcategoryView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom title without AppBar
          Container(
            padding: const EdgeInsets.all(35.0),
            alignment: Alignment.center,
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: _getSubcategories(category).length,
              itemBuilder: (context, index) {
                final subcategory = _getSubcategories(category)[index];
                final IconData icon = _getIconForSubcategory(subcategory);

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubcategoryJobsView(
                            category: category,
                            subcategory: subcategory,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 64,
                          color: const Color(0xFF459D7A),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          subcategory,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF459D7A),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getSubcategories(String category) {
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

  IconData _getIconForSubcategory(String subcategory) {
    switch (subcategory) {
      case 'General Cleaning':
        return Icons.cleaning_services;
      case 'Deep Cleaning':
        return Icons.auto_awesome_mosaic;
      case 'Carpet Cleaning':
        return Icons.local_laundry_service;
      case 'Window Cleaning':
        return Icons.window;
      case 'Kitchen Cleaning':
        return Icons.kitchen;

      case 'Daily Assistance':
        return Icons.accessibility_new;
      case 'Medical Accompaniment':
        return Icons.medical_services;
      case 'Meal Preparation':
        return Icons.food_bank;
      case 'Companionship':
        return Icons.people;
      case 'Mobility Assistance':
        return Icons.accessible;

      case 'Infant Care':
        return Icons.baby_changing_station;
      case 'Toddler Care':
        return Icons.child_care;
      case 'After-School Care':
        return Icons.school;
      case 'Overnight Care':
        return Icons.nightlight;
      case 'Special Needs Care':
        return Icons.accessibility;

      case 'Meal Prep':
        return Icons.lunch_dining;
      case 'Vegetarian Cooking':
        return Icons.local_dining;
      case 'Gluten-Free Cooking':
        return Icons.local_dining;
      case 'Party Catering':
        return Icons.party_mode;
      case 'Dietary Restrictions':
        return Icons.local_dining;

      case 'Lawn Care':
        return Icons.grass;
      case 'Planting':
        return Icons.local_florist;
      case 'Pruning':
        return Icons.cut;
      case 'Pest Control':
        return Icons.bug_report;
      case 'Landscape Design':
        return Icons.landscape;

      case 'Plumbing':
        return Icons.bathtub;
      case 'Electrical Work':
        return Icons.electric_bolt;
      case 'Painting':
        return Icons.palette;
      case 'Carpentry':
        return Icons.carpenter;
      case 'Appliance Repair':
        return Icons.build;

      default:
        return Icons.help_outline;
    }
  }
}
