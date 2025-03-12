import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:application_one/feature/chat/presenataion/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends StatefulWidget {
  final String chatRoomId;
  final String senderId;
  final String receiverId;

  const MessageScreen({
    super.key,
    required this.chatRoomId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(LoadMessagesEvent(widget.chatRoomId)); // Load past messages
    chatBloc.add(
        StartListeningEvent(widget.chatRoomId)); // Listen for real-time updates
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = ChatMessage(
        id: const Uuid().v4(),
        chatRoomId: widget.chatRoomId,
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        content: _messageController.text,
        type: MessageType.text,
        status: MessageStatus.sent,
        timestamp: DateTime.now(),
      );

      BlocProvider.of<ChatBloc>(context).add(SendMessageEvent(message));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              print("🔄 UI Rebuilding: $state");

              if (state is ChatLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChatLoaded) {
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    print("📩 Displaying message: ${message.content}");
                    bool isMe = message.senderId == widget.senderId;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message.content),
                      ),
                    );
                  },
                );
              } else if (state is ChatError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return const SizedBox();
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
