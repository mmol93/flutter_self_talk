import 'dart:ui';

class Setting {
  final String mainTitle;
  final String? subTitle;
  final Function()? clickEvent;
  final Function()? longClickEvent;
  final String? statusText;
  final bool? isCheckbox;
  final Color? color;

  Setting({
    this.subTitle,
    this.statusText,
    this.isCheckbox,
    this.clickEvent,
    this.color,
    this.longClickEvent,
    required this.mainTitle,
  });
}
