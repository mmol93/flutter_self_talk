import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:self_talk/assets/strings.dart';
import 'package:self_talk/widgets/chat/message_bubble.dart';
import 'package:self_talk/widgets/chat/message_bubble_tail.dart';
import 'package:self_talk/widgets/common/profile_picture.dart';

class MessageFromOthers extends StatelessWidget {
  final bool showDate;
  final bool shouldUseTailBubble;
  final String friendName;
  final DateTime date;
  final String profilePicturePath;
  final String message;

  const MessageFromOthers({
    super.key,
    this.showDate = true,
    required this.date,
    this.profilePicturePath = Strings.defaultProfileImgPath,
    required this.message,
    required this.shouldUseTailBubble,
    required this.friendName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: shouldUseTailBubble ? const EdgeInsets.fromLTRB(0, 2, 0, 0): const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        child: Text(friendName, style: const TextStyle(fontSize: 13)),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ChatBubble(
                            clipper: shouldUseTailBubble
                                ? ChatBubbleClipper11(
                                    type: BubbleType.receiverBubble)
                                : ChatBubbleClipper12(
                                    type: BubbleType.receiverBubble),
                            margin: shouldUseTailBubble
                                ? const EdgeInsets.fromLTRB(0, 2, 0, 0)
                                : const EdgeInsets.fromLTRB(4, 2, 0, 0),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Text(message),
                          ),
                          Opacity(
                            opacity: showDate ? 1.0 : 0.0,
                            child: Text(
                              DateFormat('HH:mm').format(date),
                              style: const TextStyle(fontSize: 8),
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
