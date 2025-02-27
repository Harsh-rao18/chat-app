import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/presentation/pages/comment_page.dart';
import 'package:flutter/material.dart';

class PostCardBottomBar extends StatelessWidget {
  final Post post;
  const PostCardBottomBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  CommentPage(post:post),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send_outlined)),
          ],
        ),

        // Like & Comment Count
        Row(
          children: [
            Text(
              "${post.likeCount} likes",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${post.commentCount} comments",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
