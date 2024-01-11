import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class SupportUserRow extends StatelessWidget {
  final VoidCallback onPressed;
  const SupportUserRow({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              "assets/img/u1.png",
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "User1",
                      style: TextStyle(
                          color: TColor.primaryText, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    "1 min ago",
                    style: TextStyle(color: TColor.secondaryText, fontSize: 13),
                  )
                ],
              ),
              Text(
                "Hi, Hello Welcome",
                style: TextStyle(color: TColor.secondaryText, fontSize: 14),
              )
            ],
          ))
        ],
      ),
    );
  }
}
