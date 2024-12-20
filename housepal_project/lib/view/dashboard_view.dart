import 'package:flutter/material.dart';
import 'package:housepal_project/view/bottom_screens/booking_view.dart';
import 'package:housepal_project/view/bottom_screens/category_view.dart';
import 'package:housepal_project/view/bottom_screens/home_view.dart';
import 'package:housepal_project/view/bottom_screens/profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // HomePage is part of the Dashboard
    const CategoryPage(),
    const BookingsPage(),
    const ProfilePage(),
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
