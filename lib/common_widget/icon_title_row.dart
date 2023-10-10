import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class IconTitleRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPressed;

  const IconTitleRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 40,
              height: 40,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: TextStyle(color: TColor.primaryText, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
