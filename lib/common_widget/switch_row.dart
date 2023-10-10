import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class SwitchRow extends StatelessWidget {
  final Map sObj;
  final Function(bool) didChange;

  const SwitchRow({super.key, required this.sObj, required this.didChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sObj["name"] as String? ?? "",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  sObj["detail"] as String? ?? "",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          CupertinoSwitch(value: sObj["value"] as bool? ?? false   , onChanged: didChange)
        ],
      ),
    );
  }
}
