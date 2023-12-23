import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class LineDropDownButton extends StatelessWidget {
  final String title;
  final String hintText;
  final Map? selectVal;
  final String displayKey;
  final List itemsArr;
  final Function(dynamic) didChanged;

  const LineDropDownButton({
    super.key,
    required this.title,
    required this.hintText,
    required this.itemsArr,
    required this.didChanged,
    this.selectVal,
    required this.displayKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: TColor.placeholder, fontSize: 14),
        ),
      DropdownButtonHideUnderline(
        
        child: DropdownButton(
            isExpanded: true,
              hint: Text(
                hintText,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 16,
                ),
              ),
              value:  selectVal,
              items: itemsArr.map((itemObj) {
                return DropdownMenuItem(
                  value: itemObj,
                  child: Text(itemObj[displayKey] as String? ?? ""),
                );
              }).toList(),
              onChanged: didChanged),
      ),
        Container(
          color: TColor.lightGray,
          height: 0.5,
          width: double.maxFinite,
        ),
      ],
    );
  }
}
