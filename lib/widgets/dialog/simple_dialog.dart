import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showTextDialog({
  required String title,
  required String okText,
  required String content,
  required BuildContext context,
  Function? onPressed,
}) {
  Widget buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
            Navigator.pop(context);
          },
          child: Text(okText),
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
