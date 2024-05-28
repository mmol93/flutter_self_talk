import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/home/item_chat_room_picture.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          // 단톡방 사진
          MultiGroupPeople(),
          // 단톡방 정보
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "sdafsadf",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "34",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        size: 14,
                        Icons.notifications_off,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Text(
                    "asdfasf",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          // 날짜
          Container(
            alignment: Alignment.topRight,
            width: 90,
            height: 44,
            child: Text(
              "2023-04-32",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
