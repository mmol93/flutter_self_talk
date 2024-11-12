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
  final String friendName;
  final bool isCalling;

  const MessageCallFromOthers({
    super.key,
    required this.message,
    required this.profilePicturePath,
    required this.friendName,
    required this.isCalling,
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Flexible(
            flex: 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicture(picturePath: profilePicturePath),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                      child: Text(friendName, style: const TextStyle(fontSize: 13)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          message.imagePath == null
                              ? ChatBubble(
                                  clipper: ChatBubbleClipper12(type: BubbleType.receiverBubble),
                                  margin: const EdgeInsets.fromLTRB(4, 2, 0, 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: screenWidth * 0.65),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(size: 20, Icons.call, color: isCalling ? Colors.green : Colors.black,),
                                        const SizedBox(width: 24),
                                        Text(callText),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                  // TODO: 작은 단말기에서 어떻게 나오는지 확인 필요?
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
                                      Text(
                                        DateFormat('HH:mm').format(message.messageTime),
                                        style: const TextStyle(fontSize: 8),
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
