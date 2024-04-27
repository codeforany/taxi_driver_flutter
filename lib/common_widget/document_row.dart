import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class DocumentRow extends StatelessWidget {
  final Map dObj;
  final VoidCallback onPressed;
  final VoidCallback onInfo;
  final VoidCallback onUpload;
  final VoidCallback onAction;

  const DocumentRow(
      {super.key,
      required this.dObj,
      required this.onPressed,
      required this.onInfo,
      required this.onUpload,
      required this.onAction});

  @override
  Widget build(BuildContext context) {
    var status = dObj["status"] as int? ?? -1;

    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            dObj["name"] as String? ?? "",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: onInfo,
                            child: Image.asset(
                              "assets/img/info.png",
                              width: 15,
                              height: 15,
                            ),
                          )
                        ],
                      ),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      // Text(
                      //   dObj["detail"] as String? ?? "",
                      //   style: TextStyle(
                      //     color: TColor.secondaryText,
                      //     fontSize: 15,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                if (status == 2)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/img/check_tick.png",
                        width: 20,
                        height: 20,
                      ),
                      InkWell(
                        onTap: onAction,
                        child: Image.asset(
                          "assets/img/more.png",
                          width: 20,
                          height: 20,
                        ),
                      )
                    ],
                  )
                else if (status == -1)
                  TextButton(
                    onPressed: onUpload,
                    child: Text(
                      "UPLOAD",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                else if (status == 0)
                  const Text(
                    "Pending",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                else
                  Text(
                    status == 3
                        ? "Unapproved"
                        : status == 4
                            ? "Expiry in 15 days"
                            : "Expired",
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
