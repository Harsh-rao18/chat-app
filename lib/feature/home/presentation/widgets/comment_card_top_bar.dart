import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CommentCardTopbar extends StatelessWidget {
  final Comment comment;
  final bool isAuthCard;

  const CommentCardTopbar({
    required this.comment,
    this.isAuthCard = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formatDateFromNow(DateTime dateTime) {
      DateTime istDateTime = dateTime.add(const Duration(hours: 5, minutes: 30));
      return Jiffy.parseFromDateTime(istDateTime).fromNow();
    }

    // Extract username safely from metadata
    final String username = comment.user?.metadata.name ?? "Unknown user";


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          username, 
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(formatDateFromNow(comment.createdAt)),
            const SizedBox(width: 10),
            isAuthCard
                ? GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.delete, color: Colors.red),
                  )
                : const Icon(Icons.more_horiz),
          ],
        ),
      ],
    );
  }
}
