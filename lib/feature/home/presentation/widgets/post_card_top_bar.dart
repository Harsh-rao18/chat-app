import 'package:application_one/core/common/entities/post.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class PostCardTopBar extends StatelessWidget {
  final Post post;
  const PostCardTopBar({super.key, required this.post});

  String formatDateFromNow(DateTime? dateTime) {
    // ✅ Accept DateTime? instead of String?
    if (dateTime == null) {
      return "Unknown time";
    }

    try {
      DateTime istDateTime =
          dateTime.add(const Duration(hours: 5, minutes: 30));
      return Jiffy.parseFromDateTime(istDateTime).fromNow();
    } catch (e) {
      return "Invalid date";
    }
  }

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
            Text(
              formatDateFromNow(post.createdAt), // Parse string to DateTime
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
