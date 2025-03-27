import 'package:flutter/material.dart';
import 'package:self_talk/extensions/color_ext.dart';

class ItemSetting extends StatefulWidget {
  final String mainTitle;
  final String? subTitle;
  final Function()? clickEvent;
  final Function()? longClickEvent;
  final String? statusText;
  final bool? isCheckbox;
  final Function(bool?)? onCheckboxChanged; // 체크박스 콜백
  final Color? color;

  const ItemSetting({
    super.key,
    this.subTitle,
    this.statusText,
    this.isCheckbox,
    this.color,
    this.clickEvent,
    this.longClickEvent,
    this.onCheckboxChanged,
    required this.mainTitle,
  });

  @override
  State<ItemSetting> createState() => _ItemSettingState();
}

class _ItemSettingState extends State<ItemSetting> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.clickEvent,
      onLongPress: widget.longClickEvent,
      child: Container(
        height: 60,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      widget.mainTitle,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (widget.subTitle != null)
                    Text(
                      widget.subTitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                    )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.statusText != null)
                  Text(widget.statusText!)
                else if (widget.isCheckbox != null)
                  Checkbox(
                    value: widget.isCheckbox ?? false,
                    onChanged: widget.onCheckboxChanged,
                  )
                else if (widget.color != null)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: widget.color,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                if (widget.color != null)
                  Text(
                    widget.color!.toHexText(),
                    style: const TextStyle(fontFamily: 'RobotoMono'),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
