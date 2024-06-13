import 'package:flutter/material.dart';

Future<DateTime?> showMyTimePickerDialog(
  BuildContext context, {
  TimeOfDay? initTime,
}) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initTime ?? TimeOfDay.now(),
    confirmText: "확인",
    cancelText: "취소",
    errorInvalidText: "잘못된 값입니다.",
    hourLabelText: "시간",
    minuteLabelText: "분",
    helpText: "시간을 입력하세요",
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        // timePicker의 시간을 24시간 표시로 하기
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (pickedTime != null) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
  }

  return null; // 사용자가 시간 선택을 취소한 경우
}
