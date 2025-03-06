import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:housepal_project/features/job/presentation/view/seeker/add_task_view.dart';
import 'package:housepal_project/features/notification/presentation/view/notification_view.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';

class SeekerHomeView extends StatelessWidget {
  const SeekerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>()..add(const FetchUserEvent('')),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) =>
              getIt<NotificationBloc>()..add(const FetchNotificationsEvent()),
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage.isNotEmpty) {
              return Center(child: Text(state.errorMessage));
            }
            final user = state.user;
            final fullName = user?.fullName ?? 'Guest';
            final firstName = fullName.split(' ').first;
            final fullNameInitials = fullName
                .split(' ')
                .map((name) => name.isNotEmpty ? name[0] : '')
                .join()
                .toUpperCase();
            String imageUrl = user?.image ?? '';
            if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
              imageUrl = '${ApiEndpoints.baseUrl}$imageUrl';
            }
            return Column(
              children: [
                Expanded(
                    child: _buildHomeContent(
                        context, firstName, imageUrl, fullNameInitials)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskView()),
          ),
          backgroundColor: const Color(0xFF459D7A),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/logo.png', height: 40, width: 40),
      ),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final hasUnread = state.notifications
                    ?.any((notification) => !notification.isRead) ??
                false;
            return Stack(
              children: [
                IconButton(
                  icon: Image.asset('assets/icons/notification.png',
                      height: 25, width: 25),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationView()),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHomeContent(BuildContext context, String firstName,
      String imageUrl, String fullNameInitials) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        _buildHeaderSection(firstName, imageUrl, fullNameInitials),
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
      ],
    );
  }

  Widget _buildHeaderSection(
      String firstName, String imageUrl, String fullNameInitials) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome!",
                style: TextStyle(fontSize: 28, fontFamily: 'Poppins'),
              ),
              Text(
                firstName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? Center(
                    child: Text(
                      fullNameInitials,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
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
        crossAxisCount: screenWidth > 600 ? 4 : 2,
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
}
