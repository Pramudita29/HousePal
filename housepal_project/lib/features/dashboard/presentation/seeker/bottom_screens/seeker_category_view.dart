import 'package:flutter/material.dart';

class SeekerCategoryView extends StatelessWidget {
  const SeekerCategoryView({super.key});

  final List<Map<String, String>> categories = const [
    {
      'title': 'Cleaning',
      'image': 'assets/images/cleaning.jpg',
    },
    {
      'title': 'Elderly Care',
      'image': 'assets/images/elderly_care.jpg',
    },
    {
      'title': 'Babysitting',
      'image': 'assets/images/babysitting.png',
    },
    {
      'title': 'Cooking',
      'image': 'assets/images/cooking.jpg',
    },
    {
      'title': 'Gardening Services',
      'image': 'assets/images/gardening.png',
    },
    {
      'title': 'Home Maintenance',
      'image': 'assets/images/maintenance.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount =
        screenWidth > 600 ? 3 : 2; // More columns for tablet-sized screens

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8), // Reduced space to move text up
                const Text(
                  'What tasks you want to assign?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 30),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: screenWidth > 600
                        ? 0.7
                        : 0.75, // Adjust child aspect ratio based on screen size
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(
                      context,
                      categories[index]['title']!,
                      categories[index]['image']!,
                    );
                  },
                ),
                const SizedBox(height: 20), // Added gap before the bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF459D7A).withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          print('Tapped on $title');
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns text to the left
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16, // Font size of the category title
                  fontWeight: FontWeight.bold, // Make the title bold
                  fontFamily: 'Poppins', // Use Poppins font
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                  height: 8), // Adds slight spacing between text and image
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    height: 250, // Adjusted image height
                    width: double.infinity, // Full-width image
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}