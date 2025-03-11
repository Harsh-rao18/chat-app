import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/presentation/bloc/follower_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FollowingScreen extends StatefulWidget {
  final String userId;

  const FollowingScreen({super.key, required this.userId});

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FollowerBloc>().add(GetFollowingEvent(widget.userId)); // Fetch following list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Following")),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FollowerBloc>().add(GetFollowingEvent(widget.userId)); // Refresh following list
        },
        child: BlocBuilder<FollowerBloc, FollowerState>(
          builder: (context, state) {
            if (state is FollowerLoading) {
              return _buildLoadingShimmer();
            } else if (state is FollowerError) {
              return _buildErrorState(state.message);
            } else if (state is FollowerFollowingLoaded) { // Ensure you have a separate state for following
              return _buildFollowingList(state.following);
            }
            return const Center(child: Text("Not following anyone yet"));
          },
        ),
      ),
    );
  }

  /// 🎨 Shimmer effect for loading state
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, radius: 25),
              title: SizedBox(height: 15, width: 100, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white))),
              subtitle: SizedBox(height: 12, width: 50, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white))),
              trailing: Icon(Icons.person_remove, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  /// 🚨 Error UI with retry button
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
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: () {
                context.read<FollowerBloc>().add(GetFollowingEvent(widget.userId));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 📃 Following list UI
  Widget _buildFollowingList(List<Followers> following) {
    if (following.isEmpty) {
      return const Center(
        child: Text("Not following anyone yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: following.length,
      itemBuilder: (context, index) {
        final user = following[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: _buildUserAvatar(user),
            title: Text(
              user.name.isNotEmpty ? user.name : "Unknown",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.person_remove, color: Colors.red),
              onPressed: () {
                // TODO: Implement unfollow functionality
              },
            ),
          ),
        );
      },
    );
  }

  /// 🖼️ Avatar fallback (profile image or initials)
  Widget _buildUserAvatar(Followers user) {
    if (user.image.isNotEmpty) {
      return CircleAvatar(radius: 25, backgroundImage: NetworkImage(user.image));
    } else {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blueGrey,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }
  }
}
