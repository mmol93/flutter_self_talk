import 'package:flutter/material.dart';
import 'package:self_talk/widgets/chat/message_date.dart';
import 'package:self_talk/widgets/chat/message_from_me.dart';
import 'package:self_talk/widgets/chat/message_from_others.dart';
import 'package:self_talk/widgets/chat/message_state_html_line.dart';
import 'package:self_talk/widgets/chat/message_state_two_line.dart';

import '../../models/chat.dart';

Widget getMergedMessage({
  required bool showDate,
  required bool isMe,
  required bool shouldUseTailBubble,
  required Message message,
  required String friendName,
  required String profilePicturePath,
  MessageType messageType = MessageType.message,
  DateTime? pickedDate,
}) {
  switch (messageType) {
    case MessageType.date:
      return MessageDate(pickedDate: pickedDate ?? DateTime.now());

    case MessageType.state:
      if (message.secondMessage != null) {
        return MessageStateTwoLine(firstLineText: message.message, secondLineText: message.secondMessage);
      } else {
        return MessageStateHtmlLine(firstLineHtmlText: message.message);
      }

    case MessageType.call:
    // TODO: Handle this case.

    case MessageType.message:
      if (isMe) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 4, 0),
          child: MessageFromMe(
            shouldUseTailBubble: shouldUseTailBubble,
            showDate: showDate,
            message: message,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 5, 0, 0),
          child: MessageFromOthers(
            shouldUseTailBubble: shouldUseTailBubble,
            showDate: showDate,
            friendName: friendName,
            profilePicturePath: profilePicturePath,
            message: message,
          ),
        );
      }
  }
}
