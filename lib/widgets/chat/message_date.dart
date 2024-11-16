import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageDate extends StatelessWidget {
  final DateTime pickedDate;

  const MessageDate({super.key, required this.pickedDate});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(pickedDate);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: UnconstrainedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(35),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4.0),
              Text(
                "$formattedDate >",
                style: const TextStyle(fontSize: 12.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
