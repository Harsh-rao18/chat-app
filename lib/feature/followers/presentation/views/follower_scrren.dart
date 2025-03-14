import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/presentation/bloc/follower_bloc.dart';
import 'package:application_one/feature/showprofile/presentation/views/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FollowersScreen extends StatefulWidget {
  final String userId;

  const FollowersScreen({super.key, required this.userId});

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FollowerBloc>().add(GetFollowersEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Followers")),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FollowerBloc>().add(GetFollowersEvent(widget.userId));
        },
        child: BlocBuilder<FollowerBloc, FollowerState>(
          builder: (context, state) {
            if (state is FollowerLoading) {
              return _buildLoadingShimmer();
            } else if (state is FollowerError) {
              return _buildErrorState(state.message);
            } else if (state is FollowerLoaded) {
              return _buildFollowersList(state.followers);
            }
            return const Center(child: Text("No followers yet"));
          },
        ),
      ),
    );
  }

  /// 🎨 Loading shimmer effect
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, radius: 25),
              title: SizedBox(
                  height: 15,
                  width: 100,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white))),
              subtitle: SizedBox(
                  height: 12,
                  width: 50,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white))),
              trailing: Icon(Icons.person_remove, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  /// 🚨 Error state UI with retry button
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            Text(
              "Error: $message",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: () {
                context
                    .read<FollowerBloc>()
                    .add(GetFollowersEvent(widget.userId));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 📃 Followers list UI
  Widget _buildFollowersList(List<Followers> followers) {
    if (followers.isEmpty) {
      return const Center(
        child: Text("No followers yet",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: followers.length,
      itemBuilder: (context, index) {
        final follower = followers[index];

        return GestureDetector(
          onTap: () {
            // Navigate to follower profile
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return UserProfileScreen(userId: follower.id);
              },
            ));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: _buildFollowerAvatar(follower),
                title: Text(
                  follower.name.isNotEmpty ? follower.name : "Unknown",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                )),
          ),
        );
      },
    );
  }

  /// 🖼️ Handles avatar fallback (profile image or initials)
  Widget _buildFollowerAvatar(Followers follower) {
    if (follower.image.isNotEmpty) {
      return CircleAvatar(
          radius: 25, backgroundImage: NetworkImage(follower.image));
    } else {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blueGrey,
        child: Text(
          follower.name.isNotEmpty ? follower.name[0].toUpperCase() : '?',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }
  }
}
