import 'dart:io';

import 'package:flutter/material.dart';
import 'package:self_talk/assets/strings.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
      {super.key, this.picturePath = Strings.defaultProfileImgPath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    const imgHeight = 44.0;
    const imgWidth = 44.0;

    return Row(
      children: [
        Container(
          height: imgHeight,
          width: imgWidth,
          // TODO: 나중에 폰 해상도별로 아이콘 크기 맞는지 확인해야됨
          child: Image.file(
            File(picturePath),
            height: imgHeight,
            width: imgWidth,
            errorBuilder: (context, exception, stackTrace) {
              return Image.asset(Strings.defaultProfileImgPath);
            },
          ),
        )
      ],
    );
  }
}
