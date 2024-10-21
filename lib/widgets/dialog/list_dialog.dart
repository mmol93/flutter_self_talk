import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_talk/models/list_item_model.dart';

/// 1개의 텍스트 위젯으로 이루어진 리스트 Dialog
void showListDialog({
  String? title,
  required BuildContext context,
  required List<ListItemModel> listItemModel,
}) {
  Widget buildDialog(BuildContext ctx) {
    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: SizedBox(
        height: 50 * listItemModel.length.toDouble(),
        width: 200,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey.withOpacity(0.5),
            thickness: 0.5,
          ),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(ctx).pop();
                listItemModel[index].clickEvent!();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  listItemModel[index].itemTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            );
          },
          itemCount: listItemModel.length,
        ),
      ),
    );
  }

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
