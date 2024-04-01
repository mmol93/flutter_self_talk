import 'package:flutter/material.dart';
import 'package:self_talk/colors/default.dart';

class BarIndicator extends StatelessWidget {
  final int pageCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double barHeight;

  const BarIndicator({
    Key? key,
    required this.pageCount,
    required this.currentIndex,
    this.activeColor = Colors.black,
    this.inactiveColor = defaultGrayBackground,
    this.barHeight = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 너비를 얻음
    double screenWidth = MediaQuery.of(context).size.width;
    // 인디케이터가 들어갈 너비
    double totalWidth = screenWidth;
    // 각 인디케이터의 너비를 계산
    double barWidth = totalWidth / pageCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          // 마진 조정
          width: barWidth,
          height: barHeight,
          decoration: BoxDecoration(
            color: index == currentIndex ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }
}
