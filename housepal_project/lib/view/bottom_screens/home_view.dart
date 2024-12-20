import 'package:flutter/material.dart';
import 'package:housepal_project/view/bottom_screens/add_task_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildHomeContent(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task page or show a dialog
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskView()),
          );
        },
        backgroundColor: const Color(0xFF459D7A),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/logo.png',
          height: 40,
          width: 40,
        ),
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/icons/messenger.png',
            height: 20,
            width: 20,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Image.asset(
            'assets/icons/notification.png',
            height: 25,
            width: 25,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        _buildHeaderSection(),
        const SizedBox(height: 20),
        _buildSearchBar(context),
        const SizedBox(height: 30),
        _buildSectionTitle("Popular Category"),
        const SizedBox(height: 10),
        _buildPopularCategories(context),
        const SizedBox(height: 40),
        _buildSectionTitle("Find a tasker at extremely preferential prices"),
        const SizedBox(height: 5),
        _buildTaskerPromo(),
        const SizedBox(height: 40),
        _buildSectionTitle("Top Rated Helpers"),
        const SizedBox(height: 0),
        _buildTopTaskers(),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(fontSize: 28, fontFamily: 'Poppins'),
              ),
              Text(
                "User",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF459D7A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "What do you need help with?",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPopularCategories(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth > 600 ? 180 : 120;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount:
            screenWidth > 600 ? 4 : 2, // 4 for larger screens, 2 for smaller
        childAspectRatio: screenWidth > 600 ? 1 : 1.2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildCategoryCard(
              "House Cleaning", 'assets/images/cleaning.jpg', imageSize),
          _buildCategoryCard(
              "Elderly Care", 'assets/images/elderly_care.jpg', imageSize),
          _buildCategoryCard(
              "Babysitting", 'assets/images/babysitting.png', imageSize),
          _buildCategoryCard("Cooking", 'assets/images/cooking.jpg', imageSize),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath, double imageSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            bottom: 15,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskerPromo() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/tasker.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF459D7A), width: 2),
              ),
              child: const Text(
                'Find Now',
                style: TextStyle(
                  color: Color(0xFF459D7A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopTaskers() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTaskerCard("John Hill", "House Maintenance",
              'assets/images/john_hill.png', 4.8, 252),
          _buildTaskerCard("Elizabeth Watson", "House Cleaning",
              'assets/images/elizabeth_watson.jpg', 4.9, 142),
          _buildTaskerCard("Michael Smith", "Cooking",
              'assets/images/michael_smith.jpeg', 4.7, 121),
          _buildTaskerCard("Sophia Lee", "Electrical Services",
              'assets/images/sophia_lee.png', 4.6, 110),
        ],
      ),
    );
  }

  Widget _buildTaskerCard(
      String name, String role, String image, double rating, int reviews) {
    return Container(
      width: 180,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 5),
              Text(
                "$rating ($reviews reviews)",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
