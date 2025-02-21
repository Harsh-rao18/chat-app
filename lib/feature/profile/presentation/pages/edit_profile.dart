import 'dart:io';
import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _imageUrl;
  String? _userId;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Fetch user metadata from Supabase and refresh session
  Future<void> _loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client.auth.refreshSession(); // ✅ Corrected method
      setState(() {
        _userId = user.id;
        _imageUrl = user.userMetadata?['image']; // Fetch profile image URL
        _descriptionController.text = user.userMetadata?['description'] ?? '';
      });
    }
  }

  /// Picks and compresses an image
  void _pickImage() {
    context.read<ProfileBloc>().add(PickAndCompressImageEvent());
  }

  /// Uploads profile changes
  void _uploadProfile() {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    final description = _descriptionController.text;
    context.read<ProfileBloc>().add(ProfileUploadEvent(
          userId: _userId!,
          description: description,
          file: _selectedImage,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _uploadProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 32, 31, 31),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileImagePicked) {
            Navigator.pop(context); // Close loading dialog
            setState(() {
              _selectedImage = state.file;
            });
          } else if (state is ProfileUploaded) {
            Navigator.pop(context); // Close loading dialog

            // ✅ Refresh Supabase session to get updated metadata
            await Supabase.instance.client.auth.refreshSession();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );

            // ✅ Navigate back and signal update
            Navigator.pop(context, true);
          } else if (state is ProfileError) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  /// Using `ImageCircle` widget to show the picked image or fallback to metadata/default avatar
                  ImageCircle(
                    radius: 80,
                    file: _selectedImage, // Show picked image if available
                    url: _imageUrl, // Show metadata image if available
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: _pickImage, // Opens the image picker
                      borderRadius: BorderRadius.circular(20),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color.fromARGB(255, 32, 31, 31),
                        child: Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 32, 31, 31),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Write something about yourself...',
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                maxLines: 2,
                maxLength: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}