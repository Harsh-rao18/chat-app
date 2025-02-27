import 'dart:io';
import 'package:application_one/feature/Addpost/presentaion/bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_one/core/utils/image_circle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _contentController = TextEditingController();
  String? _imageUrl;
  String? _name;
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserMetadata();
  }

  Future<void> _fetchUserMetadata() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final metadata = user.userMetadata;

    setState(() {
      _name = metadata?['name'] ?? 'User';
      _imageUrl = metadata?['image'];
    });
  }

  void _pickImage() {
    context.read<PostBloc>().add(PickAndCompressImageEvent());
  }

  void _uploadPost() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      _isUploading = true; // Start loader only when uploading
    });

    context.read<PostBloc>().add(PostUploadEvent(
          userId: user.id,
          content: _contentController.text,
          file: _selectedImage,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _isUploading ? null : _uploadPost, // Disable button while uploading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 32, 31, 31),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostInitial) {
            setState(() => _isUploading = true);
          } else if (state is PostUploaded) {
            setState(() {
              _isUploading = false;
              _contentController.clear();
              _selectedImage = null; // Clear image after success
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Post uploaded successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PostError) {
            setState(() => _isUploading = false);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PostImagePicked) {
            setState(() {
              _selectedImage = state.imagefile;
              _isUploading = false; // Ensure button resets when picking image
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            child: TextField(
                              autofocus: true,
                              controller: _contentController,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                              maxLines: 10,
                              minLines: 1,
                              maxLength: 1000,
                              decoration: const InputDecoration(
                                hintText: "Type a caption...",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          _selectedImage != null
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
                                              _selectedImage = null;
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

                          const SizedBox(height: 10),

                          TextButton.icon(
                            onPressed: _pickImage,
                            icon:
                                const Icon(Icons.image, color: Colors.blueAccent),
                            label: const Text("Attach Image",
                                style: TextStyle(color: Colors.blueAccent)),
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
      ),
    );
  }
}
