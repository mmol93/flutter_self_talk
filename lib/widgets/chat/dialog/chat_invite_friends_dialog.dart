import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_talk/models/friend.dart';

/// 체크 리스트 + 확인 버튼 Dialog
/// notInvitedFriendList: 이 체크리스트 Dialog에서 표시할 친구 리스트
/// clickEvent: 해당 친구를 클릭했을 때 이벤트 = 체크 on/off 처리하며 on 된 친구들을 나중에 List로 반환함
void showInviteFriendsDialog({
  required List<Friend> notInvitedFriendList,
  required BuildContext context,
  required Function(List<Friend> invitedFriendList) clickEvent,
}) {
  Widget buildDialog(BuildContext ctx) {
    List<Friend> selectedFriend = [];
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("취소")),
          ElevatedButton(onPressed: () {
            clickEvent(selectedFriend);
            Navigator.of(ctx).pop();
          }, child: const Text("확인")),
        ],
        title: const Text("초대할 친구 선택"),
        content: SizedBox(
          height: 52 * (notInvitedFriendList.length.toDouble() + 1),
          width: 200,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final Friend friend = notInvitedFriendList[index];
              return CheckboxListTile(
                title: Text(
                  notInvitedFriendList[index].name,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                value: selectedFriend.contains(friend),
                onChanged: (bool? value) {
                  setState((){
                    if (value == true) {
                      selectedFriend.add(friend);
                    } else {
                      selectedFriend.remove(friend);
                    }
                  });
                },
              );
            },
            itemCount: notInvitedFriendList.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 0.5,
            ),
            shrinkWrap: true,
          ),
        ),
      );
    });
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
