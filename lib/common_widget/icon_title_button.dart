import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class IconTitleButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const IconTitleButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 35,
            height: 35,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(color: TColor.primaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
