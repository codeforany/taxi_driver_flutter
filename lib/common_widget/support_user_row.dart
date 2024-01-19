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
    var baseCount = int.tryParse("${uObj["base_count"]  ?? ""}") ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
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
                        (uObj["created_date"] as String? ?? "").timeAgo(),
                        style: TextStyle(color: TColor.secondaryText, fontSize: 13),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          uObj["message"] as String? ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: TColor.secondaryText, fontSize: 14),
                        ),
                      ),
                      if (baseCount > 0)
                        Container(
                          padding: const EdgeInsets.all(2),
                          constraints:
                              const BoxConstraints(minWidth: 20, minHeight: 10),
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                             baseCount.toString() ,
                             textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.primaryTextW,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
