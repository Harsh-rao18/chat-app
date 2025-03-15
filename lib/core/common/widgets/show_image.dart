import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/utils/confirm_dialog';
import 'package:application_one/feature/addpost/presentaion/bloc/post_bloc.dart';
import 'package:application_one/feature/home/presentation/pages/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;
  final int likesCount;
  final int commentsCount;
  final Post post;

  const ImagePreviewScreen({
    super.key,
    required this.imageUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.post,
  });

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select<AuthBloc, User?>(
      (authBloc) => (authBloc.state is AuthSuccess) ? (authBloc.state as AuthSuccess).user : null,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (currentUser != null && currentUser.id == widget.post.userId)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      title: "Delete Post",
                      text: "Are you sure you want to delete this post?",
                      callback: () {
                        context.read<PostBloc>().add(PostDeleteEvent(postId: widget.post.id!));
                        Navigator.of(context).pop();
                        Navigator.pop(context, true);
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete, color: Colors.redAccent),
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image in a card with elevation
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.imageUrl,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Post description inside a semi-transparent container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isExpanded ? widget.post.content! : _getShortDescription(),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  if (widget.post.content!.length > 100)
                    GestureDetector(
                      onTap: _toggleExpand,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _isExpanded ? "Read less" : "Read more",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Like & Comment Section (Aligned next to each other)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Like Icon & Count
                GestureDetector(
                  onTap: () {
                    // Handle like functionality here
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 26),
                      const SizedBox(width: 5),
                      Text(
                        widget.likesCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20), // Spacing between icons

                // Comment Icon & Count
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(post: widget.post),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.comment, color: Colors.white, size: 26),
                      const SizedBox(width: 5),
                      Text(
                        widget.commentsCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getShortDescription() {
    String content = widget.post.content ?? "";
    return content.length > 100 ? "${content.substring(0, 100)}..." : content;
  }
}
