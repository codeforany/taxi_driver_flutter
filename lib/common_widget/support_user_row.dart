import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';

class SupportUserRow extends StatelessWidget {
  final Map uObj;
  final VoidCallback onPressed;
  const SupportUserRow(
      {super.key, required this.uObj, required this.onPressed});

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
                      uObj["name"] as String? ?? "",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    (uObj["created_date"] as String? ?? "" ).timeAgo(),
                    style: TextStyle(color: TColor.secondaryText, fontSize: 13),
                  )
                ],
              ),
              Text(
                uObj["message"] as String? ?? "",
                style: TextStyle(color: TColor.secondaryText, fontSize: 14),
              )
            ],
          ))
        ],
      ),
    );
  }
}
