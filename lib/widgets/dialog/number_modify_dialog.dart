import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 숫자 데이터 1개를 입력 받고 입력 받은 숫자를 반환하는 Dialog
Future<int?> showNumericInputDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('숫자 입력'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(hintText: '숫자를 입력하세요'),
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
              int? number = int.tryParse(controller.text);
              Navigator.of(context).pop(number);
            },
          ),
        ],
      );
    },
  );
}