import 'package:flutter/material.dart';

class AddPostAppBar extends StatelessWidget {
  const AddPostAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color(0xff242424),
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Add New Post',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          TextButton(
              onPressed: () {},
              child: const Text(
                'post',
                style: TextStyle(fontSize: 15),
              ))
        ],
      ),
    );
  }
}
