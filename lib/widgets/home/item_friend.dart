import 'package:flutter/material.dart';
import 'package:self_talk/models/friend.dart';
import '../common/profile_picture.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({
    super.key,
    required this.friend,
  });

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
    );
    }
}
