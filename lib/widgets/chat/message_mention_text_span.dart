import 'package:flutter/material.dart';

/// @가 있을 경우 친구 태그 기능을 넣어주는 TextSpan
List<TextSpan> friendMentionColoredTextSpans(
  String textMessage,
  bool isDeleted,
) {
  List<TextSpan> spans = [];
  List<String> lines = textMessage.split('\n');

  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    List<String> parts = line.split(' ');

    for (int j = 0; j < parts.length; j++) {
      String part = parts[j];
      if (part.isNotEmpty) {
        // 빈 문자열 건너뛰기
        if (part.startsWith('@')) {
          spans.add(
            TextSpan(
              text: '$part${j < parts.length - 1 ? ' ' : ''}',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: '$part${j < parts.length - 1 ? ' ' : ''}',
              style: TextStyle(
                  color: isDeleted ? Colors.grey : Colors.black, fontWeight: FontWeight.w300),
            ),
          );
        }
      }
    }

    // 마지막 줄이 아니면 줄바꿈 추가
    if (i < lines.length - 1) {
      spans.add(
        TextSpan(
          text: '\n',
          style:
              TextStyle(color: isDeleted ? Colors.grey : Colors.black, fontWeight: FontWeight.w300),
        ),
      );
    }
  }

  return spans;
}
