import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_talk/models/chat.dart';
import 'package:self_talk/viewModel/chat_viewModel.dart';

void showModifyMessageDialog({
  required Message message,
  required ChatViewModel viewModel,
  required BuildContext context,
  Function(Message message)? clickEvent,
}) {
  Widget buildDialog(BuildContext context) {
    final firstMessageController = TextEditingController(text: message.message);
    final secondMessageController =
        TextEditingController(text: message.secondMessage);

    return AlertDialog(
      title: const Text("대화 수정"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: firstMessageController,
              decoration: const InputDecoration(labelText: "수정할 메시지"),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            if (message.secondMessage?.isNotEmpty != null)
              TextField(
                controller: secondMessageController,
                decoration: const InputDecoration(labelText: "수정할 두 번째 줄 메시지"),
                maxLines: null,
              )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (clickEvent != null) {
              message.message = firstMessageController.text;
              message.secondMessage = secondMessageController.text;
              clickEvent(message);
            }
            Navigator.pop(context);
          },
          child: const Text("확인"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        )
      ],
    );
  }

  // Android, iOS에 따라 다른 Dialog를 보여준다
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: buildDialog,
    );
  } else {
    showDialog(
      context: context,
      builder: buildDialog,
    );
  }
}
