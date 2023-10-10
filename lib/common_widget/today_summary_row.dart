import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class TodaySummaryRow extends StatelessWidget {
  final Map sObj;
  const TodaySummaryRow({super.key, required this.sObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                sObj["time"],
                style: TextStyle(color: TColor.primaryText, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: TColor.lightWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sObj["am_pm"],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
           const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sObj["name"],
                  style: TextStyle(color: TColor.primaryText, fontSize: 16),
                ),
                Text(
                  sObj["detail"],
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            sObj["price"],
            style: TextStyle(color: TColor.primaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
