import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/feature/home/presentation/widgets/comment_card_top_bar.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCircle(
              radius: 20, 
              url: comment.user?.metadata.image ?? 'https://via.placeholder.com/40', // Fallback image
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentCardTopbar(comment: comment),
                  const SizedBox(height: 4),
                  Text(
                    comment.reply,
                    softWrap: true,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: Color(0xff242424)),
      ],
    );
  }
}
