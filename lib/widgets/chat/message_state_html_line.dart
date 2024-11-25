import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MessageStateHtmlLine extends StatelessWidget {
  final String firstLineHtmlText;
  final bool isBackgroundDark;

  const MessageStateHtmlLine({
    super.key,
    required this.firstLineHtmlText,
    required this.isBackgroundDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: isBackgroundDark ? Colors.grey.withAlpha(85) : Colors.black.withAlpha(35),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Html(data: firstLineHtmlText, style: {
              "body": Style(
                color: Colors.white,
                textAlign: TextAlign.center,
                display: Display.inlineBlock,
              ),
              "u": Style(
                // 밑줄 스타일 추가
                textDecoration: TextDecoration.underline,
                textDecorationColor: Colors.white,
              ),
            }),
          ),
        ],
      ),
    );
  }
}
