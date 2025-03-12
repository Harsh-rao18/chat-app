import 'package:application_one/feature/chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.chatRoomId,
    required super.content,
    required super.senderId,
    required super.receiverId,
    required super.type,
    required super.status,
    required super.timestamp,
  });

      factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'],
      chatRoomId: map['chat_room_id'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      content: map['content'],
      type: MessageType.values.byName(map['type']),
      status: MessageStatus.values.byName(map['status']),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }


    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

