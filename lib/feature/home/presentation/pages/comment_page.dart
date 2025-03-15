import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/presentation/bloc/home_bloc.dart';
import 'package:application_one/feature/home/presentation/widgets/comment_card.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  void _fetchComments() {
    if (widget.post.id == null) {
      debugPrint("Error: post.id is null. Cannot fetch comments.");
      return;
    }
    debugPrint("Fetching comments for post ID: ${widget.post.id}");
    context.read<HomeBloc>().add(FetchCommentsEvent(postId: widget.post.id!));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void addReply() {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      debugPrint("Error: User is not logged in.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to comment.")),
      );
      return;
    }

    if (_commentController.text.isNotEmpty && widget.post.id != null && widget.post.userId != null) {
      debugPrint("Adding reply: ${_commentController.text}");
      context.read<HomeBloc>().add(
            AddReplyEvent(
              userId: user.id,
              postId: widget.post.id!,
              postUserId: widget.post.userId!,
              reply: _commentController.text,
            ),
          );
      _commentController.clear();
    } else {
      debugPrint("Error: Comment text is empty or post/user ID is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is ReplyAddSuccess) {
                debugPrint("Reply added successfully. Fetching comments...");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                _fetchComments(); // Fetch comments after reply is added
              } else if (state is HomeError) {
                debugPrint("Error from Bloc: ${state.message}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.red))),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) => current is! ReplyAddSuccess,
                builder: (context, state) {
                  if (state is CommentsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Error: ${state.message}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else if (state is CommentsLoaded) {
                    final comments = state.comments;

                    if (comments.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("No comments yet.", textAlign: TextAlign.center),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: CommentCard(comment: comments[index]),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Something went wrong."));
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      ),
    );
  }
}
