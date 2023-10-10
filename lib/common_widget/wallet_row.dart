import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class WalletRow extends StatelessWidget {
  final Map wObj;
  const WalletRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset( wObj["icon"] , width: 35, height: 35, ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wObj["name"],
                  style: TextStyle(color: TColor.primaryText, fontSize: 16),
                ),
                Text(
                  wObj["time"],
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            wObj["price"],
            style: TextStyle(color: TColor.primaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
