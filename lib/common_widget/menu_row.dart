import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class MenuRow extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const MenuRow(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             const SizedBox(
              width: 12.5,
            ),
            Image.asset(
              icon,
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 12.5,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
