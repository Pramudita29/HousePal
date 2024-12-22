import 'package:flutter/material.dart';

class HelperHomepageView extends StatelessWidget {
  const HelperHomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background to white
        elevation: 0, // Remove shadow
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/images/logo.png', // Your custom logo
            height: 40,
            width: 40,
          ),
        ),
        actions: [
          const SizedBox(width: 10),
          IconButton(
            icon: Image.asset(
              'assets/icons/messenger.png', // Custom message icon
              height: 20,
              width: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/notification.png', // Custom notification icon
              height: 24,
              width: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Good Morning!" and "Hari" Section
              const Text(
                'Good Morning!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hari', // You can replace this dynamically
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Bold text color
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        'assets/images/profile.png'), // Placeholder profile image
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Earnings and Services Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _statCard(
                        '₹1259', 'Total Earning', Icons.monetization_on, true),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                        _statCard('1589', 'Total Service', Icons.people, true),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _statCard(
                        '15', 'Upcoming Services', Icons.calendar_today, true),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                        '05', 'Today\'s Service', Icons.access_time, true),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Reduced gap here

              // Reviews Section with "View All" button
              const SizedBox(height: 10), // Adjusted from 30 to 10
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Action when View All is pressed
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue, // Adjust color as needed
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _reviewCard('Dora', '02 Dec', '4.5', 'assets/images/profile.png'),
              _reviewCard('Ram', '25 Jan', '4.5', 'assets/images/profile.png'),
              _reviewCard('Sita', '30 Jan', '4.5', 'assets/images/profile.png'),
              _reviewCard(
                  'Laxmi', '25 Feb', '4.5', 'assets/images/profile.png'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for the stats cards (with border option)
  Widget _statCard(
      String value, String label, IconData iconData, bool withBorder) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, // Light background color
        borderRadius: BorderRadius.circular(5), // Rounded corners
        border: withBorder
            ? Border.all(color: Colors.grey[300]!) // Border for stat cards
            : Border.all(width: 0), // No border for review cards
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon in circular background
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF6F7F9), // Light background color
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 25,
              color: const Color(0xFF459D7A), // Icon color
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF459D7A), // Bold text color
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Helper method for the reviews (no border)
  Widget _reviewCard(
      String name, String date, String rating, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9), // Light background color
        borderRadius: BorderRadius.circular(5), // Rounded corners
        // No border for review cards
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath), // Profile picture
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Rating (stars)
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.yellow[700], // Star color
                    ),
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.yellow[700], // Star color
                    ),
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.yellow[700], // Star color
                    ),
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.yellow[700], // Star color
                    ),
                    Icon(
                      Icons.star_half,
                      size: 18,
                      color: Colors.yellow[700], // Star color
                    ),
                    const SizedBox(width: 5),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Full review text
                const Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
