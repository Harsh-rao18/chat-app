import 'dart:async';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/presentation/bloc/home_bloc.dart';
import 'package:application_one/feature/home/presentation/pages/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostCardBottomBar extends StatefulWidget {
  final Post post;

  const PostCardBottomBar({super.key, required this.post});

  @override
  State<PostCardBottomBar> createState() => _PostCardBottomBarState();
}

class _PostCardBottomBarState extends State<PostCardBottomBar> {
  String? currentUserId;
  bool isLiked = false;
  int likeCount = 0;
  late final SupabaseClient supabase;
  StreamSubscription<List<Map<String, dynamic>>>? likeSubscription;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    _getCurrentUser();
    _subscribeToLikeChanges();
  }

  void _getCurrentUser() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.id;
        isLiked = widget.post.likes?.any((like) => like.userId == user.id) ?? false;
        likeCount = widget.post.likeCount ?? 0;
      });
    }
  }

  /// ✅ Subscribe to real-time changes in the `likes` table for this post
  void _subscribeToLikeChanges() {
    if (widget.post.id == null) return;

    likeSubscription = supabase
        .from('likes')
        .stream(primaryKey: ['user_id', 'post_id']) 
        .eq('post_id', widget.post.id!)
        .listen((likesData) {
      if (mounted) {
        setState(() {
          likeCount = likesData.length; // ✅ Update like count in real-time
          isLiked = likesData.any((like) => like['user_id'] == currentUserId); // ✅ Check if current user liked it
        });
      }
    });
  }

  /// ✅ Toggle like with proper handling
  void _toggleLike() async {
  if (currentUserId == null) return;

  final previousLikeState = isLiked;
  final previousLikeCount = likeCount;

  // Optimistic UI Update
  setState(() {
    isLiked = !isLiked;
    likeCount += isLiked ? 1 : -1;
  });

  try {
    final result = await supabase.rpc<int>(
      'toggle_like',
      params: {
        'p_user_id': currentUserId,
        'p_post_id': widget.post.id is int ? widget.post.id : int.parse(widget.post.id.toString()),
      },
    );

    // Ensure state consistency with the database response
    if (mounted) {
      setState(() {
        isLiked = result > previousLikeCount; // Update like state based on result
        likeCount = result; // Ensure count is in sync with DB
      });
    }
  } catch (e) {
    debugPrint('❌ Error toggling like: $e');

    // Revert UI update on error
    if (mounted) {
      setState(() {
        isLiked = previousLikeState;
        likeCount = previousLikeCount;
      });
    }
  }
}


  @override
  void dispose() {
    likeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded) {
          final updatedPost = state.posts.firstWhere(
            (p) => p.id == widget.post.id,
            orElse: () => widget.post,
          );

          setState(() {
            isLiked = updatedPost.likes?.any((like) => like.userId == currentUserId) ?? false;
            likeCount = updatedPost.likeCount ?? 0;
          });
        } else if (state is LikeError) {
          setState(() {
            isLiked = !isLiked;
            likeCount = isLiked ? likeCount + 1 : likeCount - 1;
          });
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: currentUserId != null ? _toggleLike : null,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: isLiked ? Colors.red : null,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(post: widget.post),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "$likeCount likes",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "${widget.post.commentCount} comments",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
