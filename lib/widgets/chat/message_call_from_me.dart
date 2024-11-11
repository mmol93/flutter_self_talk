import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';

class MessageCallFromMe extends StatelessWidget {
  final Message message;
  final bool isCalling;

  const MessageCallFromMe({
    super.key,
    required this.message,
    required this.isCalling,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                child: message.isFailed
                    ? SvgPicture.asset(
                        'assets/images/retry.svg',
                        height: 24,
                        width: 48,
                        fit: BoxFit.fill,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Opacity(
                            opacity: message.notSeenMemberNumber > 0 ? 1.0 : 0.0,
                            child: Text(
                              message.notSeenMemberNumber.toString(),
                              style: const TextStyle(fontSize: 7, color: Colors.yellow),
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(message.messageTime),
                            style: const TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
              ),
              ChatBubble(
                clipper: ChatBubbleClipper12(type: BubbleType.sendBubble),
                margin: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.65),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(size: 20, Icons.call, color: isCalling ? Colors.green : Colors.black,),
                      const SizedBox(width: 24),
                      Text(message.message.isEmpty ? "그룹콜 해요" : message.message),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
