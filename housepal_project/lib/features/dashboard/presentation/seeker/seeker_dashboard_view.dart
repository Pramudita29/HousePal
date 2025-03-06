import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/dashboard/presentation/cubit/seeker_dashboard_cubit.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/bottom_screens/seeker_category_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/bottom_screens/seeker_home_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/bottom_screens/seeker_profile_view.dart';
import 'package:housepal_project/features/job_application/presentation/view/seeker/seeker_job_application_view.dart';

class SeekerDashboardView extends StatelessWidget {
  const SeekerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SeekerDashboardCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<SeekerDashboardCubit, int>(
          builder: (context, currentIndex) {
            final pages = [
              const SeekerHomeView(),
              const SeekerCategoryView(),
              const SeekerJobApplicationsView(),
              const SeekerProfileView(),
            ];
            return pages[currentIndex];
          },
        ),
        bottomNavigationBar: BlocBuilder<SeekerDashboardCubit, int>(
          builder: (context, currentIndex) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: const Color(0xFF459D7A),
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                context.read<SeekerDashboardCubit>().selectTab(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home), // Replace with Image.asset for icons
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: "Categories",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: "Bookings",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
