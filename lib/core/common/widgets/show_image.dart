import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/presentation/pages/comment_page.dart';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final int likesCount;
  final int commentsCount;
  final Post post;

  const ImagePreviewScreen({
    super.key,
    required this.imageUrl,
    required this.likesCount,
    required this.commentsCount, required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image in a card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 10), // Space between image and icons

          // Like & Comment counts at the bottom left
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                // Like Icon with Count
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 24),
                    const SizedBox(width: 5),
                    Text(
                      likesCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Comment Icon with Count
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentPage(post: post)));
                      },
                      child: const Icon(Icons.comment,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      commentsCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
