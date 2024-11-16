import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';

class ChatBubbleClipper11 extends CustomClipper<Path> {
  final BubbleType? type;
  final double radius;
  final double nipSize;
  final double sizeRatio;

  /// 꼬리가 있는 메시비 버블
  ChatBubbleClipper11({
    this.type,
    this.radius = 15,
    this.nipSize = 3,
    this.sizeRatio = 2.5,
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    if (type == BubbleType.sendBubble) {
      path.moveTo(radius, size.height);
      path.lineTo(size.width - radius - nipSize, size.height);
      path.arcToPoint(Offset(size.width - nipSize, size.height - radius),
          radius: Radius.circular(radius), clockwise: false);

      path.lineTo(size.width - nipSize, nipSize);

      path.arcToPoint(Offset(size.width, 0),
          radius: Radius.circular(nipSize), clockwise: true);

      path.arcToPoint(Offset(size.width - 2 * nipSize, nipSize),
          radius: Radius.circular(2 * nipSize), clockwise: false);

      path.arcToPoint(Offset(size.width - 4 * nipSize, 0),
          radius: Radius.circular(2 * nipSize), clockwise: false);

      path.lineTo(radius, 0);
      path.arcToPoint(Offset(0, radius),
          radius: Radius.circular(radius), clockwise: false);
      path.lineTo(0, size.height - radius);
      path.arcToPoint(Offset(radius, size.height), radius: Radius.circular(radius), clockwise: false);
    } else {
      path.moveTo(radius, size.height);
      path.lineTo(size.width - radius, size.height);
      path.arcToPoint(Offset(size.width, size.height - radius),
          radius: Radius.circular(radius), clockwise: false);

      path.lineTo(size.width, radius);

      path.arcToPoint(Offset(size.width - radius, 0),
          radius: Radius.circular(radius), clockwise: false);

      path.lineTo(4 * nipSize, 0);
      path.arcToPoint(Offset(2 * nipSize, nipSize),
          radius: Radius.circular(2 * nipSize), clockwise: false);

      path.arcToPoint(Offset(0, 0),
          radius: Radius.circular(2 * nipSize), clockwise: false);

      path.arcToPoint(Offset(nipSize, nipSize),
          radius: Radius.circular(nipSize), clockwise: true);

      path.lineTo(nipSize, size.height - radius);
      path.arcToPoint(Offset(radius + nipSize, size.height),
          radius: Radius.circular(radius), clockwise: false);
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}