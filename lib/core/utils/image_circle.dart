import 'dart:io';
import 'package:flutter/material.dart';

class ImageCircle extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;

  const ImageCircle({
    super.key,
    required this.radius,
    this.url,
    this.file,
  });

  ImageProvider _getImageProvider() {
    if (file != null) {
      return FileImage(file!);
    } else if (url != null && url!.isNotEmpty) {
      return NetworkImage(url!);
    } else {
      return const AssetImage('assets/images/avatar.png'); // Default avatar
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300, // Placeholder color
      child: ClipOval(
        child: FadeInImage(
          placeholder: const AssetImage('assets/images/avatar.png'),
          image: _getImageProvider(),
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/avatar.png', fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}
