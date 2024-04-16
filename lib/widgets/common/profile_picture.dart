import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.picturePath = "assets/images/profile_pic.png"});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 40,
            height: 40,
            child: Image(image: AssetImage(picturePath)))
      ],
    );
  }
}
