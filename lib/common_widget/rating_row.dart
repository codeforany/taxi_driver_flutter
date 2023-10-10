import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxi_driver/common/color_extension.dart';

class RatingRow extends StatelessWidget {
  final Map rObj;

  const RatingRow({super.key, required this.rObj});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          RatingBar.builder(
            initialRating: rObj["rate"] as double? ?? 5.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: TColor.primary,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),

           const SizedBox(
            height: 8,
          ),

          if( (rObj["message"] as String? ?? "") != "" )
          Text(
            rObj["message"] as String? ?? "",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
            ),
          ),
         
        ],
      ),
    );
  }
}