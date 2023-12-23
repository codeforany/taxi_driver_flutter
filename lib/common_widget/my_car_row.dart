import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class MyCarRow extends StatelessWidget {
  final Map cObj;
  final VoidCallback onPressed;

  const MyCarRow({super.key, required this.cObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var imageUrl = cObj["car_image"] as String? ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${cObj["brand_name"] ?? ""} - ${cObj["model_name"] ?? ""} - ${cObj["series_name"] ?? ""}",
                    style: TextStyle(color: TColor.primaryText, fontSize: 16),
                  ),
                  Text(
                    "${cObj["car_number"] ?? ""}",
                    style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),

            if( "${cObj["is_set_running"]}"  == "1" )
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.pin_drop_outlined,
                color: TColor.primary,
                size: 25,
              ),
            ),

            if (imageUrl != "")
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),

            // Image.asset(
            //   cObj["image"] as String? ?? "",
            //   width: 50,
            //   height: 50,
            //   fit: BoxFit.cover,
            // )
          ],
        ),
      ),
    );
  }
}
