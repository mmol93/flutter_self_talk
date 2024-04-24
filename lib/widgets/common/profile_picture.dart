import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:self_talk/assets/strings.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
      {super.key, this.picturePath = Strings.defaultProfileImgPath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    const double imgHeight = 44.0;
    const double imgWidth = 44.0;

    return Row(
      children: [
        Container(
          height: imgHeight,
          width: imgWidth,
          // TODO: 나중에 폰 해상도별로 아이콘 크기 맞는지 확인해야됨
          child: ClipPath(
            clipper: MyClipper(),
            child: Image.file(
              File(picturePath),
              height: imgHeight,
              width: imgWidth,
              errorBuilder: (context, exception, stackTrace) {
                return Image.asset(Strings.defaultProfileImgPath);
              },
            ),
          ),
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, 21)
      ..arcTo(
          Rect.fromCenter(
              center: Offset(20.5, 20.5),
              width: size.width,
              height: size.height),
          1 * pi,
          0.5 * pi,
          false)
      ..lineTo(size.width, 0)
      ..arcTo(Rect.fromCircle(center: Offset(23.5, 20.5), radius: 21.5),
          1.5 * pi, 0.5 * pi, false)
      ..lineTo(size.width, size.width / 2)
      ..arcTo(
          Rect.fromLTRB(size.width / 3, size.width / 3, size.width, size.width),
          2 * pi,
          0.5 * pi,
          false)
      ..lineTo(size.width / 2, size.width)
      ..arcTo(Rect.fromLTWH(0, size.width / 2, size.width / 2, size.width / 2),
          0.5 * pi, 0.5 * pi, false)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
