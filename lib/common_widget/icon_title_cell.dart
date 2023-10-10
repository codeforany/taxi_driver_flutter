import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class IconTitleCell extends StatelessWidget {
  final String title;
  final String icon;
  final double width;
  final VoidCallback onPressed;

  const IconTitleCell({super.key, required this.title, required this.icon, required this.onPressed, this.width = 50});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
      
        children: [
          Image.asset(
            icon,
            width: width,
            height: width,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
              color: TColor.primaryTextW,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}