import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String _userRole = 'househelper'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.navigate_before, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back on button press
                    },
                  ),
                  const SizedBox(
                      width: 10), // Space between back arrow and "Welcome"
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Using custom Poppins font
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account to get started',
                style: TextStyle(
                  fontFamily: 'Poppins', // Using custom Poppins font
                  fontSize: 16,
                  fontWeight: FontWeight.w300, // Light font weight
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              // Full Name
              _buildTextField('Full Name', _fullNameController, Icons.person),
              const SizedBox(height: 12),
              // Email
              _buildTextField('Email', _emailController, Icons.email),
              const SizedBox(height: 12),
              // Address
              _buildTextField('Address', _addressController, Icons.home),
              const SizedBox(height: 12),
              // Contact Number
              _buildTextField(
                  'Contact Number', _contactController, Icons.phone),
              const SizedBox(height: 12),
              // Password
              _buildTextField('Password', _passwordController, Icons.lock,
                  isPassword: true),
              const SizedBox(height: 12),
              // Confirm Password
              _buildTextField('Confirm Password', _confirmPasswordController,
                  Icons.lock_outline,
                  isPassword: true),
              const SizedBox(height: 20),
              // Role Selector (without "Select Role" text)
              Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: 'househelper',
                      groupValue: _userRole,
                      onChanged: (value) {
                        setState(() {
                          _userRole = value!;
                        });
                      },
                    ),
                    title: const Text(
                      "I'm a househelper",
                      style: TextStyle(
                        fontFamily: 'Poppins', // Using custom Poppins font
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // Regular font weight
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: 'looking',
                      groupValue: _userRole,
                      onChanged: (value) {
                        setState(() {
                          _userRole = value!;
                        });
                      },
                    ),
                    title: const Text(
                      "I'm looking for a househelper",
                      style: TextStyle(
                        fontFamily: 'Poppins', // Using custom Poppins font
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // Regular font weight
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF459D7A),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 100), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Using custom Poppins font
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable TextField without Boxes
  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins', // Using custom Poppins font
          fontSize: 14, // Smaller font size
          color: Colors.black54,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4CAF50)),
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 15), // Reduced padding
      ),
    );
  }
}
