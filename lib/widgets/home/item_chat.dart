import 'package:flutter/material.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/home/item_chat_room_picture.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("adfasd"),
        TrioChatItem()
      ],
    );
  }
}
