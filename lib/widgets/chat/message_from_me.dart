import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';
import 'package:self_talk/widgets/chat/message_bubble_tail.dart';

class MessageFromMe extends StatelessWidget {
  final bool showDate;
  final bool shouldUseTailBubble;
  final Message message;
  final bool isDeleted;
  final Color? bubbleColor;
  final bool isBackgroundDark;

  const MessageFromMe({
    super.key,
    this.isDeleted = false,
    this.showDate = true,
    required this.shouldUseTailBubble,
    required this.message,
    this.bubbleColor,
    required this.isBackgroundDark,
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
                          Visibility(
                            visible: message.notSeenMemberNumber > 0 || showDate,
                            child: Opacity(
                              opacity: showDate ? 1.0 : 0.0,
                              child: Text(
                                DateFormat('HH:mm').format(message.messageTime),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: isBackgroundDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              message.imagePath == null
                  ? ChatBubble(
                      backGroundColor: bubbleColor,
                      clipper: shouldUseTailBubble
                          ? ChatBubbleClipper11(type: BubbleType.sendBubble)
                          : ChatBubbleClipper12(type: BubbleType.sendBubble),
                      margin: shouldUseTailBubble
                          ? const EdgeInsets.fromLTRB(0, 2, 0, 0)
                          : const EdgeInsets.fromLTRB(0, 2, 4, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isDeleted
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.grey.withOpacity(0.7),
                                  ))
                              : const SizedBox(),
                          ConstrainedBox(
                            // TODO: 작은 단말기에서 어떻게 나오는지 확인 필요
                            constraints: BoxConstraints(maxWidth: screenWidth * 0.59),
                            child: Text(
                              message.message,
                              style: TextStyle(color: isDeleted ? Colors.grey : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      // TODO: 작은 단말기에서 어떻게 나오는지 확인 필요
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(message.imagePath!),
                          // TODO: 사진이 그대로 잘 입력되는지 확인하기
                          fit: BoxFit.fill,
                          // 실패 시 그냥 무시되는 빈 위젯 제출
                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
