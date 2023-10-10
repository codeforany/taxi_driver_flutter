import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xff3DB24B);
  static Color get secondary => const Color(0xff3369FF);

  static Color get primaryText => const Color(0xff282F39);
  static Color get primaryTextW => const Color(0xffFFFFFF);
  static Color get secondaryText => const Color(0xff7F7F7F);
  static Color get placeholder => const Color(0xffBBBBBB);
  static Color get lightGray => const Color(0xffDADEE3);
  static Color get lightWhite => const Color(0xffF2F5F7);

  static Color get red => const Color(0xffF4586C);

  static Color get bg => Colors.white;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  Future push(Widget widget) async {
    return Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  void pop() async {
    return Navigator.pop(this);
  }
}
