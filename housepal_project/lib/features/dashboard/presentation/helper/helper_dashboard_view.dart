import 'package:flutter/material.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/bottom_screens/helper_home_view.dart';
import 'package:housepal_project/features/job/presentation/view/helper/helper_jobs_view.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/bottom_screens/helper_profile_view.dart';
import 'package:housepal_project/features/task/presentation/view/helper_tasks_view.dart';

class HelperDashboardView extends StatefulWidget {
  const HelperDashboardView({super.key});

  @override
  State<HelperDashboardView> createState() => _HelperDashboardViewState();
}

class _HelperDashboardViewState extends State<HelperDashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HelperHomepageView(), // HomePage is part of the Dashboard
    const HelperJobsView(),
    const HelperTasksView(),
    const HelperProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex], // Switch between pages based on selected tab
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF459D7A),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              height: 24,
              width: 24,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/suitcase.png',
              height: 24,
              width: 24,
            ),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/checklist.png',
              height: 24,
              width: 24,
            ),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/user.png',
              height: 24,
              width: 24,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
