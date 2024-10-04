import 'package:flutter/material.dart';
import 'package:self_talk/widgets/chat/message_date.dart';
import 'package:self_talk/widgets/chat/message_from_me.dart';
import 'package:self_talk/widgets/chat/message_from_others.dart';

import '../../models/chat.dart';

Widget getMergedMessage(
  bool showDate,
  bool isMe,
  bool shouldUseTailBubble,
  Message message,
  String friendName,
  String profilePicturePath, {
  MessageType messageType = MessageType.message,
  DateTime? pickedDate,
}) {
  switch (messageType) {
    case MessageType.date || MessageType.state:
      return MessageDate(pickedDate: pickedDate ?? DateTime.now());

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
