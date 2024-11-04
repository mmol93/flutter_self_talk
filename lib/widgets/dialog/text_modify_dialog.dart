import 'package:flutter/material.dart';

/// 문자 데이터 1개를 입력 받고 입력 문자를 반환하는 Dialog
Future<String?> showTextInputDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('텍스트 입력'),
        content: TextField(
          controller: controller,
          maxLines: 1,
          decoration: const InputDecoration(hintText: '텍스트를 입력하세요'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              String? enteredText = controller.text;
              Navigator.of(context).pop(enteredText);
            },
          ),
        ],
      );
    },
  );
}