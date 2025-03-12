import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/chat/presenataion/bloc/chat_bloc.dart';
import 'package:application_one/feature/followers/presentation/bloc/follower_bloc.dart';
import 'package:application_one/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:application_one/core/common/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _name;
  String? _description;
  String? _imageUrl;
  bool isFollowing = false;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final authClient = Supabase.instance.client.auth;
    var user = authClient.currentUser;

    if (user == null) {
      debugPrint('🔄 Refreshing session...');
      await authClient.refreshSession();
      user = authClient.currentUser;
    }

    if (user != null) {
      debugPrint('✅ User authenticated: ${user.id}');
      setState(() => currentUserId = user?.id);
      _fetchUserProfile();
      context.read<ProfileBloc>().add(FetchProfilePostsEvent(widget.userId));
      _checkIfFollowing();
    } else {
      debugPrint('❌ User is not logged in.');
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      debugPrint('📡 Fetching profile for user ID: ${widget.userId}');
      final response = await Supabase.instance.client
          .from('users')
          .select('metadata')
          .eq('id', widget.userId)
          .maybeSingle();

      if (response == null) {
        debugPrint('⚠️ No user found.');
        return;
      }

      final metadata = response['metadata'];
      setState(() {
        _name = metadata?['name'] ?? 'User';
        _description = metadata?['description'] ?? 'No description available';
        _imageUrl = metadata?['image'];
      });

      debugPrint('✅ Profile loaded: $_name');
    } catch (e) {
      debugPrint('❌ Error fetching user profile: $e');
    }
  }

  Future<void> _checkIfFollowing() async {
    if (currentUserId == null) {
      debugPrint('⚠️ Cannot check follow status. User ID is null.');
      return;
    }

    try {
      debugPrint(
          '🔍 Checking if user $currentUserId follows ${widget.userId}...');
      final response = await Supabase.instance.client
          .from('followers')
          .select()
          .eq('follower_id', currentUserId!)
          .eq('following_id', widget.userId)
          .maybeSingle();

      debugPrint(response != null
          ? '✅ User is following.'
          : '❌ User is NOT following.');

      setState(() => isFollowing = response != null);
    } catch (e) {
      debugPrint('❌ Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    if (currentUserId == null) return;

    try {
      if (isFollowing) {
        debugPrint('🚫 Unfollowing user...');
        context
            .read<FollowerBloc>()
            .add(UnfollowUserEvent(currentUserId!, widget.userId));
      } else {
        debugPrint('✅ Following user...');
        context
            .read<FollowerBloc>()
            .add(FollowUserEvent(currentUserId!, widget.userId));
      }

      setState(() => isFollowing = !isFollowing);
    } catch (e) {
      debugPrint('❌ Follow/unfollow error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 220,
                collapsedHeight: 220,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ImageCircle(radius: 40, url: _imageUrl),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _name ?? 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Text(
                                    _description ?? 'Loading...',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.read<ChatBloc>().add(
                                        GetOrCreateChatRoom(
                                          currentUserId!,
                                          widget.userId,
                                        ),
                                      );
                                },
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: const Text('Message'),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _toggleFollow,
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child:
                                    Text(isFollowing ? 'Unfollow' : 'Follow'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: SliverAppBarDelegate(
                  const TabBar(indicatorSize: TabBarIndicatorSize.tab, tabs: [
                    Tab(text: 'Posts'),
                  ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FetchPostLoaded) {
                    final posts = state.posts;
                    if (posts.isEmpty) {
                      return const Center(child: Text('No posts available.'));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagePreviewScreen(
                                  imageUrl: post.image!,
                                  likesCount: post.likeCount ?? 0,
                                  commentsCount: post.commentCount ?? 0,
                                  post: post,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: post.image!,
                            child:
                                Image.network(post.image!, fit: BoxFit.cover),
                          ),
                        );
                      },
                    );
                  } else if (state is ProfileError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Something went wrong!'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SliverPersistentHeader
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  SliverAppBarDelegate(this._tabBar);

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
