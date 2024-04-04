import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCommonDialog({
  required String title,
  required String okText,
  required String content,
  required BuildContext context,
  Function? onPressed,
}) {
  // Android, iOS에 따라 다른 Dialog를 보여준다
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }
              Navigator.pop(ctx);
            },
            child: Text(okText),
          )
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }
              Navigator.pop(ctx);
            },
            child: Text(okText),
          )
        ],
      ),
    );
  }
}
