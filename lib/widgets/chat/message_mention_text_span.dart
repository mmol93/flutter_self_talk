import 'package:flutter/material.dart';

List<TextSpan> friendMentionColoredTextSpans(
    String textMessage,
    bool isDeleted,
    ) {
  List<TextSpan> spans = [];
  List<String> parts = textMessage.split(' ');

  for (String part in parts) {
    if (part.contains('@')) {
      // @가 포함된 부분은 파란색으로
      spans.add(TextSpan(
          text: '$part ',
          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)));
    } else {
      // 나머지 부분은 기본 검은색
      spans.add(
        TextSpan(
          text: '$part ',
          style: TextStyle(color: isDeleted ? Colors.grey : Colors.black),
        ),
      );
    }
  }

  return spans;
}