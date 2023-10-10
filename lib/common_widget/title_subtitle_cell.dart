import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class TitleSubtitleCell extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleSubtitleCell({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [

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
                fontSize: 16),
          ),

        ],
      ),
    );
  }
}