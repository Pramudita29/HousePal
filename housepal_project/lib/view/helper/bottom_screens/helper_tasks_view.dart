import 'package:flutter/material.dart';

class HelperTasksView extends StatefulWidget {
  const HelperTasksView({super.key});

  @override
  State<HelperTasksView> createState() => _HelperTasksViewState();
}

class _HelperTasksViewState extends State<HelperTasksView> {
  String selectedStatus = 'All';

  final List<Map<String, dynamic>> tasks = [
    {
      'status': 'Pending',
      'image': 'assets/images/pending.jpeg',
      'title': 'Deep Cleaning',
      'taskId': '#123',
      'price': 1200,
      'location': 'Kathmandu, Nepal',
      'dateTime': '02 February, 2022 At 8:30 AM',
      'assignedTo': 'Lorem Ipsum',
    },
    {
      'status': 'Completed',
      'image': 'assets/images/completed.jpg',
      'title': 'Babysitting',
      'taskId': '#124',
      'price': 1500,
      'location': 'Lalitpur, Nepal',
      'dateTime': '03 February, 2022 At 10:00 AM',
      'assignedTo': 'John Doe',
    },
    {
      'status': 'Ongoing',
      'image': 'assets/images/ongoing.jpeg',
      'title': 'Cooking Assistance',
      'taskId': '#125',
      'price': 800,
      'location': 'Bhaktapur, Nepal',
      'dateTime': '04 February, 2022 At 9:00 AM',
      'assignedTo': 'Jane Smith',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown button for task status
              DropdownButtonFormField<String>(
                value: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All')),
                  DropdownMenuItem(
                      value: 'Completed', child: Text('Completed')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Ongoing', child: Text('Ongoing')),
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEBEEF2), // Light grey background
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    borderSide: BorderSide.none, // No border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                dropdownColor:
                    const Color(0xFFF6F7F9), // Dropdown items background
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              // Job Cards
              Expanded(
                child: ListView(
                  children: tasks
                      .where((task) =>
                          selectedStatus == 'All' ||
                          task['status'] == selectedStatus)
                      .map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: JobCard(
                              status: task['status'],
                              image: task['image'],
                              title: task['title'],
                              taskId: task['taskId'],
                              price: task['price'],
                              location: task['location'],
                              dateTime: task['dateTime'],
                              assignedTo: task['assignedTo'],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String status;
  final String image;
  final String title;
  final String taskId;
  final int price;
  final String location;
  final String dateTime;
  final String assignedTo;

  const JobCard({
    super.key,
    required this.status,
    required this.image,
    required this.title,
    required this.taskId,
    required this.price,
    required this.location,
    required this.dateTime,
    required this.assignedTo,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Completed':
        statusColor = Colors.green;
        break;
      case 'Ongoing':
        statusColor = Colors.orange;
        break;
      case 'Pending':
      default:
        statusColor = const Color(0xFFFF4C4C);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Task ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        taskId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Price and Discount
                Row(
                  children: [
                    Text(
                      'Rs $price',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFF459D7A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date Time
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateTime,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Assigned To
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      assignedTo,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
