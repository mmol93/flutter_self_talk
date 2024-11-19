import 'dart:ui';

extension ColorExtension on String {
  /// String 헥스 컬러를 Color로 변환하는 확장 함수
  Color? toColor() {
    if (isEmpty) return null;

    // #으로 시작하면 제거
    var hexColor = replaceAll("#", "");

    // 6자리가 아니면 null 반환
    if (hexColor.length != 6) return null;

    // 0xFF + 헥스코드로 변환
    try {
      return Color(int.parse("0xFF$hexColor"));
    } catch (e) {
      return null;
    }
  }
}
