import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class LocationSelectButton extends StatelessWidget {
  final String title;
  final String placeholder;
  final Color color;
  final String value;
  final bool isSelect;
  final VoidCallback onPressed;

  const LocationSelectButton(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.color,
      required this.value,
      this.isSelect = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: isSelect ? Border.all(color: color, width: 2) : null,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: isSelect ? color.withOpacity(0.2) : Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 2)
                ]),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text(
                    value == "" ? placeholder : value,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      color:
                          value == "" ? TColor.placeholder : TColor.primaryText,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: TColor.secondaryText,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
