import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

enum RoundButtonType { primary, secondary, red, boarded }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;

  const RoundButton(
      {super.key,
      required this.title,
      this.type = RoundButtonType.primary,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.maxFinite,
      elevation: 0,
      color: type == RoundButtonType.primary
          ? TColor.primary
          : type == RoundButtonType.secondary
              ? TColor.secondary
              : type == RoundButtonType.red
                  ? TColor.red
                  : Colors.transparent,
      height: 45,
      shape: RoundedRectangleBorder(
          side: type == RoundButtonType.boarded
              ? BorderSide(color: TColor.secondaryText)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(25)),
      child: Text(
        title,
        style: TextStyle(
          color: type == RoundButtonType.boarded
              ? TColor.secondaryText
              : TColor.primaryTextW,
          fontSize: 16,
        ),
      ),
    );
  }
}
