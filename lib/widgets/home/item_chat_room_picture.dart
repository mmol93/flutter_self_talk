import 'package:flutter/material.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';

class TrioChatItem extends StatelessWidget {
  const TrioChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경
        Container(
          alignment: Alignment.topCenter,
          width: profileImgWidth + profileImgWidth/2,
          height: profileImgHeight + profileImgHeight/2,
          child: ProfilePicture(),
        ),
        // 겹친 항목
        const Positioned(
          top: profileImgHeight - profileImgHeight/2,
          left: profileImgWidth - profileImgWidth/2,
          child: ProfilePicture(),
        ),
      ],
    );
  }
}