import 'package:application_one/feature/followers/presentation/views/follower_scrren.dart';
import 'package:application_one/feature/followers/presentation/views/following_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_one/feature/followers/presentation/bloc/follower_bloc.dart';

class ProfileCard extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String description;
  final String userId;

  const ProfileCard({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.description,
    required this.userId,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isExpanded = false;
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<FollowerBloc>().add(FetchFollowersCount(widget.userId));
    context.read<FollowerBloc>().add(FetchFollowingCount(widget.userId));
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.profileImageUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleExpand,
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocListener<FollowerBloc, FollowerState>(
                listener: (context, state) {
                  if (state is FollowersCountLoaded) {
                    setState(() {
                      followersCount = state.count;
                    });
                  } else if (state is FollowingCountLoaded) {
                    setState(() {
                      followingCount = state.count;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCountContainer("Followers", followersCount, FollowersScreen(userId: widget.userId)),
                    _buildCountContainer("Following", followingCount, FollowingScreen(userId: widget.userId)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountContainer(String label, int count, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
