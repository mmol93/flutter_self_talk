import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';
import 'package:self_talk/widgets/chat/message_bubble_tail.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';

import 'message_mention_text_span.dart';

class MessageFromOthers extends StatelessWidget {
  final bool showDate;
  final bool shouldUseTailBubble;
  final String friendName;
  final String profilePicturePath;
  final Message message;
  final bool isDeleted;
  final Color? bubbleColor;
  final bool isBackgroundDark;

  const MessageFromOthers({
    super.key,
    this.showDate = true,
    this.isDeleted = false,
    this.profilePicturePath = Strings.defaultProfileImgPath,
    required this.shouldUseTailBubble,
    required this.friendName,
    required this.message,
    this.bubbleColor,
    required this.isBackgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
                // Opacity는 invisible 같은 역할
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
                        child: Text(friendName,
                            style: TextStyle(
                              fontSize: 13,
                              color: isBackgroundDark ? Colors.white : Colors.black,
                            )),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          message.imagePath == null
                              ? ChatBubble(
                                  backGroundColor: bubbleColor,
                                  clipper: shouldUseTailBubble
                                      ? ChatBubbleClipper11(type: BubbleType.receiverBubble)
                                      : ChatBubbleClipper12(type: BubbleType.receiverBubble),
                                  margin: shouldUseTailBubble
                                      ? const EdgeInsets.fromLTRB(0, 2, 0, 0)
                                      : const EdgeInsets.fromLTRB(4, 2, 0, 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isDeleted
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Icon(Icons.warning,
                                                  color: Colors.grey.withOpacity(0.7)),
                                            )
                                          : const SizedBox(),
                                      ConstrainedBox(
                                        // others는 프로필 사진 부분까지 출력해야하기 때문에 좀 더 줄어든다.
                                        constraints: BoxConstraints(maxWidth: screenWidth * 0.53),
                                        child: RichText(
                                          text: TextSpan(
                                            children: friendMentionColoredTextSpans(message.message, isDeleted),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                  constraints: const BoxConstraints(maxWidth: 230),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(message.imagePath!),
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
