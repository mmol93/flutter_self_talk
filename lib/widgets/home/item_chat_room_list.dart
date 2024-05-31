import 'package:flutter/material.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';
import 'package:self_talk/widgets/home/item_chat_room_picture.dart';

class ChatRoomListItem extends StatelessWidget {
  const ChatRoomListItem({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final chatMembers = chat.chatMember;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          // 단톡방 사진 셋팅
          if (chatMembers.length >= 5)
            MultiChatRoomPicture(chat: chat)
          else if (chatMembers.length == 4)
            FourChatRoomPicture(chat: chat)
          else if (chatMembers.length == 3)
            ThreeChatRoomPicture(chat: chat)
          else
            ProfilePicture(picturePath: chat.getaFriendProfilePath()),
          // 단톡방 정보
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        chat.title!, // 단톡방 제목
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        chatMembers.length.toString(), // 단톡방 사람 수
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      if (chat.alarmOnOff == 0)
                        const Icon(
                          size: 14,
                          Icons.notifications_off,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                  Text(
                    chat.lastMessage ?? "", // 최근 메시지
                    style: const TextStyle(color: Colors.grey),
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
              chat.getModifiedDateToString(),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
