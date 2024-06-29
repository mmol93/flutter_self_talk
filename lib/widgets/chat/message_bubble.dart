import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';

class ChatBubbleClipper12 extends CustomClipper<Path> {
  final double radius;
  final BubbleType? type;

  ChatBubbleClipper12({
    this.type,
    this.radius = 15,
  });

  @override
  Path getClip(Size size) {
    var path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
