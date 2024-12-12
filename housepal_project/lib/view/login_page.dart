import 'package:flutter/material.dart';
import 'package:housepal_project/view/registration_page.dart'; // RegisterPage import if needed for navigation

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Add login functionality here (authentication logic)
    if (email.isNotEmpty && password.isNotEmpty) {
      // Navigate to the home page or dashboard
      // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      // Show error if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
    }
  }

  // Reusable TextField without Boxes (same style as RegisterPage)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100), // Move logo a bit down
              Image.asset(
                'assets/images/logo.png', // Replace with your actual logo file path
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 30), // Space between logo and welcome text

              const Text(
                'Welcome!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Hi, Enter your details to get sign in to your account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w300, // Light weight for description
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Email Field without Box (Line style) using _buildTextField
              _buildTextField('Email', _emailController, Icons.email),
              const SizedBox(height: 12),

              // Password Field without Box (Line style) using _buildTextField
              _buildTextField('Password', _passwordController, Icons.lock,
                  isPassword: true),
              const SizedBox(height: 20),

              // Remember Me Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                    activeColor: const Color(0xFF459D7A),
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Login Button (Styled same as Register Button)
              Center(
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF459D7A),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Forgot Password Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle forgot password action here
                    // You can navigate to a Forgot Password page if needed
                  },
                  child: const Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF459D7A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Link to Register Page (Centered)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF459D7A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Terms and Conditions
              const Center(
                child: Text(
                  'By logging in, you agree to our Terms & Conditions',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Colors.black54,
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
