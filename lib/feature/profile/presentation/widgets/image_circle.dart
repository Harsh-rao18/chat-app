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

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: file != null
          ? FileImage(file!) as ImageProvider
          : url != null
              ? NetworkImage(url!)
              : const AssetImage('assets/images/avatar.png'),
    );
  }
}
