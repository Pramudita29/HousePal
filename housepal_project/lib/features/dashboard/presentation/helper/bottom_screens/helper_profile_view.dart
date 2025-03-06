import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housepal_project/app/constants/api_enpoints.dart';
import 'package:housepal_project/features/auth/domain/entity/auth_entity.dart';
import 'package:housepal_project/features/dashboard/presentation/view_model/user_bloc.dart';
import 'package:image_picker/image_picker.dart';

class HelperProfileView extends StatefulWidget {
  const HelperProfileView({super.key});

  @override
  State<HelperProfileView> createState() => _HelperProfileViewState();
}

class _HelperProfileViewState extends State<HelperProfileView> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const FetchUserEvent(''));
  }

  Future<void> _pickImage(String email, String role) async {
    final pickedFile = await showDialog<XFile>(
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
                    await ImagePicker().pickImage(source: ImageSource.camera),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await ImagePicker().pickImage(source: ImageSource.gallery),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      context.read<UserBloc>().add(UploadProfileImageEvent(
            image: _imageFile!,
            email: email,
            role: role.isNotEmpty ? role : 'Helper',
          ));
    }
  }

  Future<void> _showEditProfileDialog(
      BuildContext context, AuthEntity user) async {
    final TextEditingController fullNameController =
        TextEditingController(text: user.fullName);
    final TextEditingController contactNoController =
        TextEditingController(text: user.contactNo ?? '');
    final TextEditingController skillsController =
        TextEditingController(text: user.skills?.join(', ') ?? '');
    final TextEditingController experienceController =
        TextEditingController(text: user.experience ?? '');

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Contact No',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: skillsController,
                  decoration: const InputDecoration(
                    labelText: 'Skills (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedUser = AuthEntity(
                  userId: user.userId,
                  fullName: fullNameController.text,
                  email: user.email,
                  contactNo: contactNoController.text,
                  password: user.password,
                  role: user.role,
                  skills: skillsController.text
                      .split(',')
                      .map((s) => s.trim())
                      .toList(),
                  experience: experienceController.text,
                  image: user.image,
                  confirmPassword: '',
                );
                context.read<UserBloc>().add(UpdateUserEvent(updatedUser));
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          setState(() => _imageFile = null);
        } else if (state.isSuccess) {
          if (state.user == null) {
            // Logout success

            Navigator.pushReplacementNamed(context, '/LoginView');
          } else {
            // Profile update success

            setState(() => _imageFile = null);
          }
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.user == null && !state.isSuccess) {
          return const Center(child: Text('No user data available'));
        }

        final user = state.user;
        if (user == null) {
          return const SizedBox(); // Avoid showing profile if logged out
        }

        final fullNameInitials = user.fullName
            .split(' ')
            .map((name) => name.isNotEmpty ? name[0] : '')
            .join()
            .toUpperCase();
        final imageUrl = user.image != null && user.image!.isNotEmpty
            ? '${ApiEndpoints.baseUrl}${user.image}'
            : null;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF459D7A), Color(0xFF2E6B54)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              image: _imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : (imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _imageFile == null && imageUrl == null
                                ? Center(
                                    child: Text(
                                      fullNameInitials,
                                      style: const TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () =>
                                  _pickImage(user.email, user.role ?? 'Helper'),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF459D7A), width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFF459D7A),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  title: Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: const Color(0xFF459D7A),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildProfileTile(
                                icon: Icons.email,
                                title: 'Email',
                                value: user.email,
                              ),
                              const Divider(),
                              _buildProfileTile(
                                icon: Icons.phone,
                                title: 'Contact Number',
                                value: user.contactNo ?? 'Not provided',
                              ),
                              const Divider(),
                              _buildProfileTile(
                                icon: Icons.build,
                                title: 'Skills',
                                value:
                                    user.skills?.join(', ') ?? 'Not provided',
                              ),
                              const Divider(),
                              _buildProfileTile(
                                icon: Icons.work_history,
                                title: 'Experience',
                                value: user.experience ?? 'Not provided',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.edit,
                            label: 'Edit Profile',
                            color: const Color(0xFF459D7A),
                            onPressed: () =>
                                _showEditProfileDialog(context, user),
                          ),
                          _buildActionButton(
                            icon: Icons.logout,
                            label: 'Logout',
                            color: Colors.red,
                            onPressed: () => context
                                .read<UserBloc>()
                                .add(LogoutEvent(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF459D7A)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
