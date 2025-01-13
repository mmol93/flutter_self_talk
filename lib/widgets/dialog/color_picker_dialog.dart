import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:self_talk/colors/default_color.dart';
import 'package:self_talk/utils/Constants.dart';
import 'package:self_talk/utils/MyLogger.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Color?> showColorPicker({
  required BuildContext context,
  required Color initColor,
  String? type,
}) async {
  Color currentColor = initColor;

  final Uri url = Uri.parse('https://android-developer.tistory.com/89');

  void _launchUrl() async {
    if (!await launchUrl(url)) {
      MyLogger.error("카카오 색상코드가 있는 웹페이지 열기 불가능");
    }
  }

  Widget buildDialog(BuildContext ctx) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("색상 선택"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                child: ColorPicker(
                  pickerAreaHeightPercent: 0.2,
                  pickerColor: currentColor,
                  onColorChanged: (color) {
                    currentColor = color;
                  },
                  displayThumbColor: true,
                  labelTypes: const [
                    ColorLabelType.hex,
                  ],
                  hexInputBar: true,
                  enableAlpha: true,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    _launchUrl();
                  },
                  child: const Text(
                "색상코드 확인은 여기를 클릭하세요.",
                style: TextStyle(fontSize: 12),
              ))
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('초기화'),
              onPressed: () {
                if (type == backgroundColorKey) {
                  currentColor = defaultBackgroundColor;
                } else if (type == myMessageColorKey) {
                  currentColor = defaultMyMessageColor;
                } else if (type == othersMessageColorKey) {
                  currentColor = defaultOthersMessageColor;
                }
                Navigator.of(context).pop(currentColor);
              },
            ),
            ElevatedButton(
              child: const Text('선택'),
              onPressed: () {
                Navigator.of(context).pop(currentColor);
              },
            ),
          ],
        );
      },
    );
  }

  final Color? selectedColor = await showDialog<Color>(
    context: context,
    builder: buildDialog,
  );

  return selectedColor;
}
