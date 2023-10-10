import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class TagButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const TagButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: TColor.primary, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(color: TColor.primary, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
