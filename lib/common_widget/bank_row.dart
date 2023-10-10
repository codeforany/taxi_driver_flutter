import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class BankRow extends StatelessWidget {
  final Map bObj;
  const BankRow({super.key, required this.bObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            bObj["icon"],
            width: 50,
            height: 50,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bObj["name"],
                  style: TextStyle(color: TColor.primaryText, fontSize: 16),
                ),
                Text(
                  bObj["number"],
                  style: TextStyle(color: TColor.secondaryText, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
