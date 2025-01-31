import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SeekerProfileView extends StatefulWidget {
  const SeekerProfileView({super.key});

  @override
  _SeekerProfileViewState createState() => _SeekerProfileViewState();
}

class _SeekerProfileViewState extends State<SeekerProfileView> {
  XFile? _image; // To store the picked image

  // Function to handle image picking
  Future<void> _pickImage() async {
    final pickedImage = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(
                      context,
                      await ImagePicker()
                          .pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(
                      context,
                      await ImagePicker()
                          .pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });

      // Fetch the email from your user model or other state management system
      String userEmail =
          'p12@mail.com'; // Replace this with actual logic to get email

      // After image is picked, dispatch the event to upload it with the email
      BlocProvider.of<RegisterBloc>(context).add(
        UploadProfileImageEvent(
          image: File(pickedImage.path),
          role: 'Seeker',
          email: userEmail, // Pass the email here
          context: context, // Pass the context for snackbar display
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          textAlign: TextAlign.left,
        ),
        centerTitle: false, // Align the title to the left
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Center-aligned Profile Picture, Name, and Email
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _image != null
                                  ? FileImage(File(_image!.path))
                                  : const AssetImage(
                                          'assets/images/profile.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Name (Static for now)
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),
                const Text(
                  'A passionate and dedicated Seeker looking for opportunities to help others.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Experience: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  '3+ years of experience in providing assistance to others.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Skills:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Wrap(
                  spacing: 10,
                  children: [
                    Chip(
                      label: Text(
                        'Assistance',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                    Chip(
                      label: Text(
                        'Communication',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      backgroundColor:
                          Color(0xFF459D7A), // Chip background color
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Logout Button
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle logout
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
