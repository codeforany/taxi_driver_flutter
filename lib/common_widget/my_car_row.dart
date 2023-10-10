import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class MyCarRow extends StatelessWidget {
  final Map cObj;
  final VoidCallback onPressed;

  const MyCarRow({super.key, required this.cObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cObj["name"] as String? ?? "",
                    style: TextStyle(color: TColor.primaryText, fontSize: 16),
                  ),
                  Text(
                    cObj["no_plat"] as String? ?? "",
                    style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Image.asset(
              cObj["image"] as String? ?? "",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
