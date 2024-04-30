import 'package:flutter/material.dart';

Future<bool?> showFriendDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("친구 이름"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextButton(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {},
                child: const Text(
                  "'나'로 변경하기",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              TextButton(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {},
                child:
                const Text(
                  "1:1 채팅하기",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              TextButton(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {},
                child: const Text(
                  "단체 채팅하기",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              TextButton(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {},
                child: const Text(
                  "프로필 수정하기",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              TextButton(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {},
                child: const Text(
                  "삭제하기",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
