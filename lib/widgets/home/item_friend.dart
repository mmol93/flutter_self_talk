import 'package:flutter/material.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/models/friend_control.dart';
import 'package:self_talk/utils/MyLogger.dart';
import '../common/profile_picture.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({
    super.key,
    required this.friend,
  });

  final Friend friend;

  Future<FriendControlResult?> _showFriendDialog(BuildContext context, Friend friend) async {
    return showDialog<FriendControlResult>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(friend.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControlResult(friendControl: FriendControl.setAsMe));
                  },
                  child: const Text(
                    "'나'로 변경하기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControlResult(friendControl: FriendControl.chat1on1));
                  },
                  child:
                  const Text(
                    "1:1 채팅하기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControlResult(friendControl: FriendControl.chatMulti));
                  },
                  child: const Text(
                    "단체 채팅하기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControlResult(friendControl: FriendControl.modifyProfile));
                  },
                  child: const Text(
                    "프로필 수정하기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControlResult(friendControl: FriendControl.deleteItself));
                  },
                  child: const Text(
                    "삭제하기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          FriendControlResult? friendControlResult = await _showFriendDialog(context, friend);
          switch (friendControlResult?.friendControl) {
            case FriendControl.setAsMe :
              MyLogger.log("setAsMe: $friend}");
            case FriendControl.chat1on1:
              MyLogger.log("chat1on1: $friend");
            case FriendControl.modifyProfile:
              MyLogger.log("modifyProfile: $friend");
            case FriendControl.deleteItself:
              MyLogger.log("deleteItself: $friend");
            default:
              MyLogger.log("chatMulti: $friend");
          }
        },
        child: Row(
          children: [
            ProfilePicture(picturePath: friend.profileImgPath),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    friend.message,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
