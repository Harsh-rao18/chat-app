import 'package:application_one/feature/home/domain/entities/post.dart';
import 'package:application_one/feature/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentPage extends StatefulWidget {
  final Post post;
  const CommentPage({super.key, required this.post});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _commentController = TextEditingController();

void addReply() {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You must be logged in to comment.")),
    );
    return;
  }

  if (_commentController.text.isNotEmpty) {
    context.read<HomeBloc>().add(
          AddReplyEvent(
            userId: user.id,
            postId: widget.post.id!,
            postUserId: widget.post.userId!,
            reply: _commentController.text,
          ),
        );
    _commentController.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Comment $index"),
                  subtitle: Text("User $index"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      filled: true,
                      fillColor: const Color(0xff242424),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: addReply,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
