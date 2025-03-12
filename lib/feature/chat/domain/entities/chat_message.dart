enum MessageType { text, video, image }

enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String chatRoomId;
  final String content;
  final String senderId;
  final String receiverId;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.timestamp,
  });
}
