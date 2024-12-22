import 'package:flutter/material.dart';
import 'package:housepal_project/view/login_page.dart'; // Import LoginPage

class HelperDetailsPage extends StatefulWidget {
  final String fullName;
  final String email;

  const HelperDetailsPage({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  State<HelperDetailsPage> createState() => _HelperDetailsPageState();
}

class _HelperDetailsPageState extends State<HelperDetailsPage> {
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  @override
  void dispose() {
    _skillsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _submitDetails() {
    String skills = _skillsController.text;
    String experience = _experienceController.text;

    if (skills.isEmpty || experience.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    if (int.tryParse(experience) == null || int.parse(experience) < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Experience must be a valid number and non-negative!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details Submitted Successfully!')),
    );

    // After submission, navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(), // Navigate to the LoginPage
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isMultiline = false}) {
    return TextField(
      controller: controller,
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      maxLines: isMultiline ? 3 : 1,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.black54,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4CAF50)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Helper Details',
          style: TextStyle(
            color: Colors.white, // Set the title text color to white
          ),
        ),
        backgroundColor: const Color(0xFF459D7A), // AppBar background color
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, color: Colors.white), // Custom back icon
          onPressed: () {
            Navigator.pop(context); // Navigate back on icon press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Text(
                'Hello, ${widget.fullName}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${widget.email}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please provide additional details to complete your Helper profile.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Skills Field
              _buildTextField('Skills (comma-separated)', _skillsController, Icons.work,
                  isMultiline: true),
              const SizedBox(height: 12),

              // Experience Field
              _buildTextField('Experience (in years)', _experienceController,
                  Icons.calendar_today),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _submitDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF459D7A),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
