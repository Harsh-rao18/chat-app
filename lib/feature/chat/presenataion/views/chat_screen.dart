import 'package:application_one/core/utils/image_circle.dart';
import 'package:application_one/feature/chat/presenataion/views/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Supabase.instance.client.auth.currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 1,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchChatRooms(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No chats yet.",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)));
          }

          final chatRooms = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final String otherUserId = (chatRoom['user1'] == currentUserId)
                  ? chatRoom['user2']
                  : chatRoom['user1'];

              return _buildUserTile(context, chatRoom['id'], otherUserId);
            },
          );
        },
      ),
    );
  }

  /// Fetch all chat rooms where the current user is a participant
  Future<List<Map<String, dynamic>>> _fetchChatRooms(String userId) async {
    final response = await Supabase.instance.client
        .from('chat_rooms')
        .select('*')
        .or('user1.eq.$userId,user2.eq.$userId')
        .order('created_at', ascending: false);

    return response;
  }

  /// Build a user tile with profile info
  Widget _buildUserTile(
      BuildContext context, String chatRoomId, String userId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchUserData(userId), // Fetch other user's profile data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircleAvatar(child: CircularProgressIndicator()),
            title: Text("Loading..."),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const ListTile(
            leading: CircleAvatar(child: Icon(Icons.error)),
            title: Text("User not found"),
          );
        }

        final userData = snapshot.data!;
        final profilePic = userData['image'] as String?;
        final name = userData['name'] as String? ?? "Unknown User";
        final bool isOnline = userData['isOnline'] ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                final String currentUserId =
                    Supabase.instance.client.auth.currentUser?.id ?? '';

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(
                      chatRoomId: chatRoomId,
                      senderId:
                          currentUserId, // Corrected: Current user is always the sender
                      receiverId:
                          userId, // The other user is always the receiver
                    ),
                  ),
                );
              },
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: Stack(
                  children: [
                    ImageCircle(radius: 22, url: profilePic), // Reduced size
                    if (isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Fetch user profile data from Supabase users table
  Future<Map<String, dynamic>?> _fetchUserData(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .select('metadata')
        .eq('id', userId)
        .single();

    return response['metadata'] as Map<String, dynamic>?;
  }
}
