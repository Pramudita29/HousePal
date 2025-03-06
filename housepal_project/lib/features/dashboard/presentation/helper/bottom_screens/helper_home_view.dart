import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/app/di/di.dart';
import 'package:housepal_project/core/common/snackbar/my_snackbar.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:housepal_project/features/notification/presentation/view/notification_view.dart';
import 'package:housepal_project/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:housepal_project/features/review/presentation/view_model/review_bloc.dart';

class HelperHomepageView extends StatefulWidget {
  const HelperHomepageView({super.key});

  @override
  State<HelperHomepageView> createState() => _HelperHomepageViewState();
}

class _HelperHomepageViewState extends State<HelperHomepageView> {
  @override
  void initState() {
    super.initState();
    print('Initializing HelperHomepageView...');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => getIt<UserBloc>()..add(const FetchUserEvent('')),
        ),
        BlocProvider<ReviewBloc>(
          create: (context) => getIt<ReviewBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) =>
              getIt<NotificationBloc>()..add(const FetchNotificationsEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
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
                          height: 24, width: 24),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationView()),
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
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state.isSuccess && state.user != null) {
                    print('User loaded: ${state.user!.email}');
                    context
                        .read<ReviewBloc>()
                        .add(FetchHelperReviewsEvent(state.user!.email));
                  }
                  if (state.errorMessage.isNotEmpty) {
                    print('UserBloc error: ${state.errorMessage}');
                    showMySnackBar(
                      context: context,
                      message: state.errorMessage,
                      color: Colors.red,
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage.isNotEmpty) {
                    return Center(child: Text(state.errorMessage));
                  }
                  if (state.user != null) {
                    String fullName = state.user?.fullName ?? 'Guest';
                    String firstName = fullName.isNotEmpty
                        ? fullName.split(' ').first
                        : 'Guest';
                    String fullNameInitials = fullName
                        .split(' ')
                        .map((name) => name.isNotEmpty ? name[0] : '')
                        .join()
                        .toUpperCase();
                    String imageUrl = state.user?.image ?? '';
                    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                      imageUrl = ApiEndpoints.imageUrl(imageUrl);
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$firstName!',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
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
                    );
                  }
                  return const Center(
                      child: Text('Please log in or register.'));
                },
              ),
              const SizedBox(height: 20),
              _buildMotivationCard(),
              const SizedBox(height: 20),
              const Text(
                'Quick Tips for Helpers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildQuickTips(),
              const SizedBox(height: 20),
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
                      final userEmail =
                          context.read<UserBloc>().state.user?.email;
                      if (userEmail != null) {
                        print('Refreshing reviews for: $userEmail');
                        context
                            .read<ReviewBloc>()
                            .add(FetchHelperReviewsEvent(userEmail));
                      } else {
                        showMySnackBar(
                          context: context,
                          message: 'User not loaded yet.',
                          color: Colors.orange,
                        );
                      }
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  print('ReviewBloc Builder: isLoading=${state.isLoading}, '
                      'reviews=${state.reviews.length}, '
                      'errorMessage=${state.errorMessage}');
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(child: Text('Error: ${state.errorMessage}'));
                  }
                  if (state.reviews.isEmpty) {
                    print('No reviews in state, forcing check...');
                    return const Center(child: Text('No reviews yet.'));
                  }
                  print('Rendering ${state.reviews.length} reviews');
                  return Column(
                    children: state.reviews.map((review) {
                      final fullImageUrl = review.seekerImage != null &&
                              review.seekerImage!.isNotEmpty
                          ? (review.seekerImage!.startsWith('http')
                              ? review.seekerImage!
                              : ApiEndpoints.imageUrl(review.seekerImage!))
                          : '';
                      return _reviewCard(
                        seekerEmail: review.seekerEmail,
                        fullName: review.seekerFullName,
                        imageUrl: fullImageUrl,
                        date: review.createdAt != null
                            ? _formatDate(review.createdAt)
                            : 'N/A',
                        rating: review.rating.toString(),
                        comments: review.comment ?? 'No comment',
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF459D7A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keep Shining!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Your hard work lights up lives every day."',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    const tips = [
      {
        'title': 'Be Punctual',
        'description': 'Arrive on time to build trust.',
        'icon': Icons.access_time,
      },
      {
        'title': 'Stay Organized',
        'description': 'Plan your tasks efficiently.',
        'icon': Icons.checklist,
      },
      {
        'title': 'Smile Often',
        'description': 'A friendly attitude goes a long way.',
        'icon': Icons.sentiment_satisfied,
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF459D7A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tip['icon'] as IconData,
                    color: const Color(0xFF459D7A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tip['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tip['description'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _reviewCard({
    required String seekerEmail,
    required String fullName,
    required String imageUrl,
    required String date,
    required String rating,
    required String comments,
  }) {
    double ratingValue = double.tryParse(rating) ?? 0.0;
    bool isValidImageUrl = imageUrl.isNotEmpty && imageUrl.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: isValidImageUrl
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !isValidImageUrl
                ? Center(
                    child: Text(
                      fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isNotEmpty ? fullName : 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          seekerEmail.isNotEmpty ? seekerEmail : 'No Email',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      date.isNotEmpty ? date : 'N/A',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 15,
                      color: index < ratingValue ? Colors.amber : Colors.grey,
                    );
                  }),
                ),
                const SizedBox(height: 5),
                Text(
                  comments.isNotEmpty ? comments : 'No comment available',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                if (!isValidImageUrl && imageUrl.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Image unavailable',
                      style: TextStyle(fontSize: 10, color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
