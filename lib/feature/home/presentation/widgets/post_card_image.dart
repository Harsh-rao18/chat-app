import 'package:application_one/core/common/entities/post.dart';
import 'package:flutter/material.dart';

class PostCardImage extends StatelessWidget {
  final Post post;
  const PostCardImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        post.image!,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      ),
    );
  }
}
