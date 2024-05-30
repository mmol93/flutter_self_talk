import 'package:flutter/material.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';

class ThreeChatRoomPicture extends StatelessWidget {
  /// 단톡방에 3명(자신 포함)일 때 사용
  const ThreeChatRoomPicture({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    // 내가 아닌 '다른' 단톡방 멤버들 = 2명
    final chatMembersButMe = chat.chatMember.where((friend) => friend.me == 0);

    return chat.modifiedChatRoomImg == null ?
      SizedOverflowBox(
      size: const Size(profileImgWidth, profileImgHeight),
      child: Transform.scale(
        scale: 0.6682,
        child: Stack(
          children: [
            // 배경
            Container(
              alignment: Alignment.topCenter,
              width: profileImgWidth + profileImgWidth / 2,
              height: profileImgHeight + profileImgHeight / 2,
              child: ProfilePicture(
                  picturePath: chatMembersButMe.first.profileImgPath),
            ),
            // 겹친 항목
            Positioned(
              top: profileImgHeight - profileImgHeight / 2,
              left: profileImgWidth - profileImgWidth / 2,
              child: ProfilePicture(picturePath: chatMembersButMe.last.profileImgPath),
            ),
          ],
        ),
      ),
    ) : ProfilePicture(picturePath: chat.modifiedChatRoomImg!);
  }
}

class FourChatRoomPicture extends StatelessWidget {
  /// 단톡방에 4명(자신 포함)일 때 사용
  const FourChatRoomPicture({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    // 내가 아닌 '다른' 단톡방 멤버들 = 3명
    final chatMembersButMe = chat.chatMember.where((friend) => friend.me == 0);

    return chat.modifiedChatRoomImg == null ?
      SizedOverflowBox(
      size: const Size(profileImgWidth, profileImgHeight),
      child: Transform.scale(
        scale: 0.5,
        child: Container(
          width: profileImgWidth * 2,
          height: profileImgHeight * 2,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              ProfilePicture(picturePath: chatMembersButMe.elementAt(0).profileImgPath),
              ProfilePicture(picturePath: chatMembersButMe.elementAt(1).profileImgPath),
              ProfilePicture(picturePath: chatMembersButMe.elementAt(2).profileImgPath),
              Container()
            ],
          ),
        ),
      ),
    ) : ProfilePicture(picturePath: chat.modifiedChatRoomImg!);
  }
}

class MultiChatRoomPicture extends StatelessWidget {
  /// 단톡방에 5명(자신 포함)이상 일 때 사용
  const MultiChatRoomPicture({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    // 내가 아닌 '다른' 단톡방 멤버들 = 4명 이상
    final chatMembersButMe = chat.chatMember.where((friend) => friend.me == 0);

    return chat.modifiedChatRoomImg == null ?
      SizedOverflowBox(
      size: const Size(profileImgWidth, profileImgHeight),
      child: Transform.scale(
        scale: 0.5,
        child: Container(
          width: profileImgWidth * 2,
          height: profileImgHeight * 2,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              ProfilePicture(picturePath: chatMembersButMe.elementAt(0).profileImgPath),
              ProfilePicture(picturePath: chatMembersButMe.elementAt(1).profileImgPath),
              ProfilePicture(picturePath: chatMembersButMe.elementAt(2).profileImgPath),
              ProfilePicture(picturePath: chatMembersButMe.elementAt(3).profileImgPath),
            ],
          ),
        ),
      ),
    ) : ProfilePicture(picturePath: chat.modifiedChatRoomImg!);
  }
}
