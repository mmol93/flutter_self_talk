import 'dart:ui';

extension ColorToHex on Color {
  /// Converts a Color object to a hex color string
  ///
  /// Returns the color in the format '#RRGGBB' or '#AARRGGBB' if alpha is not fully opaque
  String toHexText() {
    // If the color is fully opaque, use the shorter '#RRGGBB' format
    if (alpha == 255) {
      return '#${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}';
    }

    // If the color has transparency, include the alpha channel
    return '#${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}