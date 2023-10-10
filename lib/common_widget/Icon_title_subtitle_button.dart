import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class IconTitleSubtitleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onPressed;

  const IconTitleSubtitleButton(
      {super.key,
      required this.title,
      required this.subtitle,
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
            width: 20,
            height: 20,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w800),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
