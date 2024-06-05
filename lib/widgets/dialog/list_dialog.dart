import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showListDialog({
  String? title,
  required List<String> contents,
  required BuildContext context,
  Function? onPressed,
}) {
  // Android, iOS에 따라 다른 Dialog를 보여준다
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey.withOpacity(0.5),
            thickness: 0.5,
          ),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                contents[index],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            );
          },
          itemCount: contents.length,
        ),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? ""),
        content: SizedBox(
          height: 50 * contents.length.toDouble(),
          width: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 0.5,
            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  contents[index],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              );
            },
            itemCount: contents.length,
          ),
        ),
      ),
    );
  }
}
