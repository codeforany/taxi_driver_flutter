import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class TitleSubtitleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? color;
  final FontWeight? weight;
  const TitleSubtitleRow(
      {super.key, required this.title, required this.subtitle, this.color, this.weight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color ?? TColor.primaryText,
                fontSize: 15,
                fontWeight: weight ?? FontWeight.w400
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: color ?? TColor.primaryText,
              fontSize: 15,
              fontWeight: weight ?? FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
