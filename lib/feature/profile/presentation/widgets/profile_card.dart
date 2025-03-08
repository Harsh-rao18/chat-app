import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String description;
  final int followers;
  final int following;

  const ProfileCard({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.description,
    required this.followers,
    required this.following,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black, // Dark mode background
      body: Center(
        child: GestureDetector(
          onTap: _toggleExpand, // Expand on tap
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isExpanded ? 0.5 : 0.2),
                  blurRadius: _isExpanded ? 16 : 6,
                  spreadRadius: _isExpanded ? 4 : 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  transform: _isExpanded
                      ? (Matrix4.identity()..scale(1.1)) // Fixed ternary condition
                      : Matrix4.identity(),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.profileImageUrl),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _isExpanded ? 1.0 : 0.5,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                        maxLines: _isExpanded ? null : 2, // Show limited lines if not expanded
                        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.followers.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text("Followers", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          widget.following.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text("Following", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
