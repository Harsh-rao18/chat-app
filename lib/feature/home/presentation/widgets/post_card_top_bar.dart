import 'package:application_one/feature/home/domain/entities/post.dart';
import 'package:flutter/material.dart';

class PostCardTopBar extends StatelessWidget {
  final Post post;
  const PostCardTopBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            post.user?.metadata.name ?? "Unknown",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Text('9 hours ago', style: TextStyle(color: Colors.grey[600],fontSize: 12),),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {}, // Add menu actions
            ),
          ],
        ),
      ],
    );
  }
}
