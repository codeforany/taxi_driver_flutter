import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';

class WeeklySummaryRow extends StatelessWidget {
  final Map sObj;
  const WeeklySummaryRow({super.key, required this.sObj});

  @override
  Widget build(BuildContext context) {
    var price = double.tryParse(sObj["amt"].toString()) ?? 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
         
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sObj["start_time"]
                      .toString()
                      .dataFormat()
                      .stringFormat(format: "dd, MMM yyyy"),
                  style: TextStyle(color: TColor.primaryText, fontSize: 16),
                ),
                Text(
                  sObj["start_time"]
                      .toString()
                      .dataFormat()
                      .stringFormat(format: "hh:mm aa"),
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: TextStyle(color: TColor.primaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
