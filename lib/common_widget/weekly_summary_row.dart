import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class WeeklySummaryRow extends StatelessWidget {
  final Map sObj;
  const WeeklySummaryRow({super.key, required this.sObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
         
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sObj["time"],
                  style: TextStyle(color: TColor.primaryText, fontSize: 16),
                ),
                Text(
                  "${sObj["trips"]} Trips",
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
