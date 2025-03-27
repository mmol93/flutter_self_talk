import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';

class MessageCallFromOthers extends StatelessWidget {
  final Message message;
  final String profilePicturePath;
  final bool showDate;
  final bool shouldUseTailBubble;
  final String friendName;
  final bool isCalling;
  final bool isBackgroundDark;

  const MessageCallFromOthers({
    super.key,
    required this.message,
    required this.profilePicturePath,
    required this.friendName,
    required this.isCalling,
    required this.showDate,
    required this.shouldUseTailBubble,
    required this.isBackgroundDark,
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

    return Padding(
      padding: shouldUseTailBubble
          ? const EdgeInsets.fromLTRB(0, 2, 0, 0)
          : const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Flexible(
            flex: 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: shouldUseTailBubble ? 1.0 : 0.0,
                  child: ProfilePicture(picturePath: profilePicturePath),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (shouldUseTailBubble)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                        child: Text(
                          friendName,
                          style: TextStyle(
                            fontSize: 13,
                            color: isBackgroundDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          message.imagePath == null
                              ? ChatBubble(
                                  backGroundColor: Colors.white,
                                  clipper: ChatBubbleClipper12(type: BubbleType.receiverBubble),
                                  margin: const EdgeInsets.fromLTRB(4, 2, 0, 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: message.messageType == MessageType.callCut ||
                                              message.messageType == MessageType.calling
                                          ? screenWidth * 0.31
                                          : screenWidth * 0.55,
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
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                  // TODO: 여러 단말기에서 어떻게 나오는지 확인 필요
                                  constraints: const BoxConstraints(maxWidth: 240),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(message.imagePath!),
                                      // TODO: 사진이 그대로 잘 입력되는지 확인하기
                                      fit: BoxFit.fill,
                                      // 실패 시 그냥 무시되는 빈 위젯 제출
                                      errorBuilder: (context, error, stackTrace) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: message.isFailed
                                ? SvgPicture.asset(
                                    'assets/images/retry.svg',
                                    height: 24,
                                    width: 48,
                                    fit: BoxFit.fill,
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
