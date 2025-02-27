import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/presentation/widgets/post_card_bottom_bar.dart';
import 'package:application_one/feature/home/presentation/widgets/post_card_image.dart';
import 'package:application_one/feature/home/presentation/widgets/post_card_top_bar.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for User Info & Timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCircle(
                radius: 22,
                url: post.user?.metadata.image,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostCardTopBar(post: post),
                    const SizedBox(height: 5),
                    Text(
                      post.content ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    if (post.image != null)
                      PostCardImage(post: post,),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Action Buttons (Like, Comment, Share)
          PostCardBottomBar(post: post),

          const SizedBox(height: 10),
          const Divider(color: Color(0xff242424)),
        ],
      ),
    );
  }
}
