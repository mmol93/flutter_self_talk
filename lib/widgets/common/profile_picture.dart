import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.picturePath = "assets/images/profile_pic.png"});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // TODO: 나중에 폰 해상도별로 아이콘 크기 맞는지 확인해야됨
            width: 40,
            height: 40,
            child: Image(image: AssetImage(picturePath)))
      ],
    );
  }
}
