import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/post/presentaion/bloc/post_bloc.dart';
import 'package:application_one/feature/post/presentaion/widgets/add_post_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String? _imageUrl;
  String? _name;
  File? _selectedImage; // Store image locally in widget state

  @override
  void initState() {
    super.initState();
    _fetchUserMetadata();
  }

  Future<void> _fetchUserMetadata() async {
     final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final metadata = user.userMetadata; // Fetch user metadata

    setState(() {
      _name = metadata?['name'] ?? 'User';
      _imageUrl = metadata?['image']; // May be null
    });
  }

  void _pickImage() {
    context.read<PostBloc>().add(PickAndCompressImageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AddPostAppBar(),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageCircle(
                    radius: 25,
                    url: _imageUrl,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name ?? 'Loading ..',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            autofocus: true,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            maxLines: 10,
                            minLines: 1,
                            maxLength: 1000,
                            decoration: InputDecoration(
                              hintText: "Type a caption...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // BlocListener to update the local variable when image is picked
                        BlocListener<PostBloc, PostState>(
                          listener: (context, state) {
                            if (state is PostImagePicked) {
                              setState(() {
                                _selectedImage = state.imagefile;
                              });
                            }
                          },
                          child: _selectedImage != null
                              ? Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 250,
                                      ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.black54,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedImage = null; // Remove image
                                            });
                                          },
                                          icon: const Icon(Icons.close,
                                              size: 18, color: Colors.white),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.attach_file,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
