import 'package:flutter/material.dart';
import 'package:self_talk/models/friend.dart';
import 'package:self_talk/models/friend_control.dart';
import '../common/profile_picture.dart';

class FriendItem extends StatelessWidget {
  const FriendItem(
      {super.key, required this.friend, required this.clickedFriendControl});

  final Friend friend;
  final void Function(FriendControl) clickedFriendControl;

  Future<FriendControl?> _showFriendDialog(
      BuildContext context, Friend friend) async {
    return showDialog<FriendControl>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(friend.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (friend.me == 0)
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      Navigator.of(context).pop(FriendControl.setAsMe);
                    },
                    child: const Text(
                      "'나'로 변경하기",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                if (friend.me == 0)
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      Navigator.of(context).pop(FriendControl.chat1on1);
                    },
                    child: const Text(
                      "1:1 채팅하기",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                if (friend.me == 0)
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      Navigator.of(context).pop(FriendControl.chatMulti);
                    },
                    child: const Text(
                      "단체 채팅하기",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControl.modifyProfile);
                  },
                  child: const Text(
                    "프로필 수정하기",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.of(context).pop(FriendControl.deleteItself);
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
          FriendControl? friendControlResult =
              await _showFriendDialog(context, friend);
          switch (friendControlResult) {
            case FriendControl.setAsMe:
              clickedFriendControl(FriendControl.setAsMe);
            case FriendControl.chat1on1:
              clickedFriendControl(FriendControl.chat1on1);
            case FriendControl.modifyProfile:
              clickedFriendControl(FriendControl.modifyProfile);
            case FriendControl.deleteItself:
              clickedFriendControl(FriendControl.deleteItself);
            case FriendControl.chatMulti:
              clickedFriendControl(FriendControl.chatMulti);
            case null:
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
