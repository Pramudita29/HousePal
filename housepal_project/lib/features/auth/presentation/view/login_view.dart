import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/auth/presentation/view/registration_view.dart';
import 'package:housepal_project/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:housepal_project/features/dashboard/presentation/helper/helper_dashboard_view.dart';
import 'package:housepal_project/features/dashboard/presentation/seeker/seeker_dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your details to login.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Email', _emailController, Icons.email),
                  const SizedBox(height: 12),
                  _buildTextField('Password', _passwordController, Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 20),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state.isLoading) {
                        // Show loading state if needed
                        print('Loading...');
                      } else if (state.isSuccess && state.role != null) {
                        // Debugging: Print the role
                        print('Login successful: role = ${state.role}');

                        // Navigate to dashboard based on role after login success
                        if (state.role == "Seeker") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SeekerDashboardView()),
                          );
                        } else if (state.role == "Helper") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HelperDashboardView()),
                          );
                        } else {
                          print('Unknown role: ${state.role}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Unknown role'),
                            ),
                          );
                        }
                      } else if (!state.isSuccess && !state.isLoading) {
                        // Handle failed login attempt
                        print(
                            'Login failed: Invalid credentials or unknown error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid email or password'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  final email = _emailController.text.trim();
                                  final password =
                                      _passwordController.text.trim();

                                  if (email.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please enter both email and password')),
                                    );
                                    return;
                                  }

                                  // Trigger login process
                                  context.read<LoginBloc>().add(
                                        LoginUserEvent(
                                          email: email,
                                          password: password,
                                          context: context,
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF459D7A),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
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
          Positioned(
            top: 35,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.navigate_before, color: Colors.black),
              iconSize: 30,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

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
}
