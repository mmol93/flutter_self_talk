import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';

class MessageCallFromMe extends StatelessWidget {
  final Message message;
  final bool showDate;
  final bool isCalling;

  const MessageCallFromMe({
    super.key,
    required this.message,
    required this.isCalling,
    required this.showDate,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    String callText = "";
    if (message.message.isNotEmpty) {
      callText = message.message;
    } else if (isCalling) {
      callText = "그룹콜 해요";
    } else {
      callText = "취소";
    }

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
                          Visibility(
                            visible: message.notSeenMemberNumber > 0 || showDate,
                            child: Opacity(
                              opacity: showDate ? 1.0 : 0.0,
                              child: Text(
                                DateFormat('HH:mm').format(message.messageTime),
                                style: const TextStyle(fontSize: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              ChatBubble(
                clipper: ChatBubbleClipper12(type: BubbleType.sendBubble),
                margin: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: message.messageType == MessageType.callCut ||
                            message.messageType == MessageType.calling
                        ? screenWidth * 0.29
                        : screenWidth * 0.60,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        size: 20,
                        Icons.call,
                        color: isCalling ? Colors.green : Colors.black,
                      ),
                      const SizedBox(width: 24),
                      Text(callText),
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
