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
              fit: BoxFit.cover,
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
  final double firstLine = 17;
  final double secondLine = 26;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, 21)
      ..arcTo(
          Rect.fromCenter(
              center: Offset(firstLine, firstLine),
              width: firstLine * 2,
              height: firstLine * 2),
          1 * pi,
          0.5 * pi,
          false)
      ..lineTo(size.width * 0.67, 0)
      ..arcTo(
        Rect.fromCenter(
            center: Offset(secondLine, firstLine+1.4),
            width: firstLine * 2 + 3,
            height: firstLine * 2 + 3),
        1.5 * pi,
        0.5 * pi,
        false,
      )
      ..lineTo(size.width, size.width * 0.67)
      ..arcTo(
          // 14.7, 14.7, 44, 44
          Rect.fromLTRB(size.width / 3, size.width / 3, size.width, size.width),
          2 * pi,
          0.5 * pi,
          false)
      ..lineTo(size.width * 0.67, size.width)
      ..arcTo(
        Rect.fromLTRB(0, size.width / 3-1, size.width-15, size.width),
        0.5 * pi,
        0.5 * pi,
        false,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
