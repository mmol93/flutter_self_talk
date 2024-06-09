import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_talk/models/list_item_model.dart';

void showListDialog({
  String? title,
  required BuildContext context,
  required List<ListItemModel> listItemModel,
}) {
  // Android, iOS에 따라 다른 Dialog를 보여준다
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? ""),
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
              return Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  listItemModel[index].itemTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              );
            },
            itemCount: listItemModel.length,
          ),
        ),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? ""),
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
              return Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  listItemModel[index].itemTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              );
            },
            itemCount: listItemModel.length,
          ),
        ),
      ),
    );
  }
}
