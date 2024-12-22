import 'package:flutter/material.dart';
import 'package:housepal_project/view/seeker/bottom_screens/seeker_booking_view.dart';
import 'package:housepal_project/view/seeker/bottom_screens/seeker_category_view.dart';
import 'package:housepal_project/view/seeker/bottom_screens/seeker_home_view.dart';
import 'package:housepal_project/view/seeker/bottom_screens/seeker_profile_view.dart';

class SeekerDashboardVeiw extends StatefulWidget {
  const SeekerDashboardVeiw({super.key});

  @override
  State<SeekerDashboardVeiw> createState() => _SeekerDashboardVeiwState();
}

class _SeekerDashboardVeiwState extends State<SeekerDashboardVeiw> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SeekerHomeView(), // HomePage is part of the Dashboard
    const SeekerCategoryView(),
    const SeekerBookingView(),
    const SeekerProfileView(),
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
              height: 20,
              width: 20,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/category.png',
              height: 20,
              width: 20,
            ),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/booking.png',
              height: 20,
              width: 20,
            ),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/user.png',
              height: 20,
              width: 20,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
