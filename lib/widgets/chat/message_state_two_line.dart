import 'package:flutter/material.dart';
import 'package:self_talk/models/setting_color.dart';

class MessageStateTwoLine extends StatelessWidget {
  final String firstLineText;
  final String? secondLineText;
  final SettingColor? settingColor;
  final bool isBackgroundDark;

  const MessageStateTwoLine({
    super.key,
    required this.firstLineText,
    required this.secondLineText,
    this.settingColor,
    required this.isBackgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: UnconstrainedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isBackgroundDark ? Colors.grey.withAlpha(85) : Colors.black.withAlpha(35),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Text(
                firstLineText,
                style: const TextStyle(fontSize: 12.0, color: Colors.white),
              ),
              const SizedBox(width: 4.0),
              Text(
                secondLineText ?? "",
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
