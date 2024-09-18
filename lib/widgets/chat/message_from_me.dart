import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';
import 'package:self_talk/widgets/chat/message_bubble_tail.dart';

class MessageFromMe extends StatelessWidget {
  final bool showDate;
  final bool shouldUseTailBubble;
  final DateTime date;
  final String message;

  const MessageFromMe(
      {super.key,
      this.showDate = true,
      required this.date,
      required this.message,
      required this.shouldUseTailBubble});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 2),
        Flexible(
          flex: 8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 보여줄 필요는 없지만 자리는 차지해야 일정한 크기로 유지된다.
              Opacity(
                opacity: showDate ? 1.0 : 0.0,
                child: Text(
                  DateFormat('HH:mm').format(date),
                  style: const TextStyle(fontSize: 8),
                ),
              ),
              ChatBubble(
                clipper: shouldUseTailBubble
                    ? ChatBubbleClipper11(type: BubbleType.sendBubble)
                    : ChatBubbleClipper12(type: BubbleType.sendBubble),
                margin: shouldUseTailBubble
                    ? const EdgeInsets.fromLTRB(0, 2, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 2, 4, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(message),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
