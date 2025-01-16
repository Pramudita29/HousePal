import 'package:flutter/material.dart';

class HelperProfileView extends StatelessWidget {
  const HelperProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          textAlign: TextAlign.left,
        ),
        centerTitle: false, // Align the title to the left
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          // Settings Button on the top right
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onSelected: (value) {
              // Handle menu item selection
              switch (value) {
                case 'Edit Profile':
                  // Handle Edit Profile action
                  break;
                case 'App Theme':
                  // Handle App Theme action
                  break;
                case 'Earnings List':
                  // Handle Earnings List action
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Edit Profile',
                  child: Text('Edit Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'App Theme',
                  child: Text('App Theme'),
                ),
                const PopupMenuItem<String>(
                  value: 'Earnings List',
                  child: Text('Earnings List'),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture, Name, and Qualifications Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture (from assets)
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/profile.png'), // your image path here
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Name
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    const Text(
                      'johndoe@gmail.com',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),
                // Bio Section
                const Text(
                  'A dedicated and experienced house helper specializing in cleaning and household management.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Experience Section
                const Text(
                  'Experience:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  '5+ years of experience in household services.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Skills Section with Chip background color and white text
                const Text(
                  'Skills:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Wrap(
                  spacing: 10,
                  children: [
                    Chip(
                      label: Text(
                        'Cleaning',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                    Chip(
                      label: Text(
                        'Babysitting',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                    Chip(
                      label: Text(
                        'Cooking',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                    Chip(
                      label: Text(
                        'Gardening',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                    Chip(
                      label: Text(
                        'Laundry',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                  ],
                ),
                const SizedBox(height: 740),
                // Logout Button
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}