import 'package:flutter/material.dart';
import 'package:self_talk/extensions/color_ext.dart';
import 'package:self_talk/models/setting_color.dart';
import 'package:self_talk/widgets/chat/message_call_from_me.dart';
import 'package:self_talk/widgets/chat/message_call_from_others.dart';
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
  SettingColor? settingColor,
}) {
  // TODO: 배경색이 다크인지 아닌지에 따라 배경색이나 글씨색을 조절할 수 있게 해야함 ㅠ
  final bool isBackgroundDark = settingColor?.backgroundColor.isDark() ?? true;

  switch (messageType) {
    case MessageType.date:
      return MessageDate(
        pickedDate: pickedDate ?? DateTime.now(),
        isBackgroundDark: isBackgroundDark,
      );

    case MessageType.state:
      if (message.secondMessage != null) {
        return MessageStateTwoLine(
          firstLineText: message.message,
          secondLineText: message.secondMessage,
          isBackgroundDark: isBackgroundDark,
        );
      } else {
        return MessageStateHtmlLine(
          firstLineHtmlText: message.message,
          isBackgroundDark: isBackgroundDark,
        );
      }

    case MessageType.calling:
      if (isMe) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 4, 0),
          child: MessageCallFromMe(
            message: message,
            isCalling: true,
            showDate: showDate,
            isBackgroundDark: isBackgroundDark,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 5, 4, 0),
          child: MessageCallFromOthers(
            message: message,
            profilePicturePath: profilePicturePath,
            friendName: friendName,
            shouldUseTailBubble: shouldUseTailBubble,
            isCalling: true,
            showDate: showDate,
            isBackgroundDark: isBackgroundDark,
          ),
        );
      }

    case MessageType.callCut:
      if (isMe) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 4, 0),
          child: MessageCallFromMe(
            message: message,
            isCalling: false,
            showDate: showDate,
            isBackgroundDark: isBackgroundDark,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 5, 4, 0),
          child: MessageCallFromOthers(
            message: message,
            profilePicturePath: profilePicturePath,
            friendName: friendName,
            shouldUseTailBubble: shouldUseTailBubble,
            isCalling: false,
            showDate: showDate,
            isBackgroundDark: isBackgroundDark,
          ),
        );
      }

    case MessageType.message || MessageType.deleted:
      if (isMe) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 4, 0),
          child: MessageFromMe(
            shouldUseTailBubble: shouldUseTailBubble,
            showDate: showDate,
            message: message,
            isDeleted: message.messageType == MessageType.deleted,
            bubbleColor: settingColor?.myMessageColor,
            isBackgroundDark: isBackgroundDark,
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
            isDeleted: message.messageType == MessageType.deleted,
            bubbleColor: settingColor?.othersMessageColor,
            isBackgroundDark: isBackgroundDark,
          ),
        );
      }
  }
}
