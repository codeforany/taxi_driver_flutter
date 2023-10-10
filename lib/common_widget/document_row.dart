import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

enum DocumentStatus { upload, uploading, uploaded }

class DocumentRow extends StatelessWidget {
  final Map dObj;
  final VoidCallback onPressed;
  final VoidCallback onInfo;
  final VoidCallback onUpload;
  final VoidCallback onAction;
  final DocumentStatus status;

  const DocumentRow(
      {super.key,
      required this.dObj,
      required this.onPressed,
      required this.onInfo,
      required this.onUpload,
      required this.onAction,
      required this.status});

  @override
  Widget build(BuildContext context) {
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
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        dObj["detail"] as String? ?? "",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (status == DocumentStatus.uploaded)
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
                else if (status == DocumentStatus.uploading)
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      value: 0.3,
                      color: TColor.primary,
                      backgroundColor: TColor.lightGray,
                    ),
                  )
                else
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
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
