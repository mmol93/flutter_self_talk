import 'dart:ffi';

class Chat {
  final String title;
  final List<Message> messageList;
  Noti? notification;

  Chat({required this.title, required this.messageList});
}

class Noti {
  final String id;
  final String message;

  Noti({required this.id, required this.message});
}

class Message {
  final String id;
  final DateTime messageTime;
  final String message;
  final MessageType messageType;
  final Bool isMe;

  Message({
    required this.id,
    required this.messageTime,
    required this.message,
    required this.messageType,
    required this.isMe,
  });
}

enum MessageType { message, date, state }
