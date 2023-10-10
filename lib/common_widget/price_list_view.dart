import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/title_subtitle_cell.dart';
import 'package:taxi_driver/common_widget/title_subtitle_row.dart';

class PriceListView extends StatelessWidget {
  final Map dObj;
  const PriceListView({super.key, required this.dObj});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: TColor.lightGray,
        ),
        Row(
          children: [
            Expanded(
              child: TitleSubtitleCell(
                title: dObj["trips"],
                subtitle: "Trips",
              ),
            ),
            Container(
              height: 80,
              width: 0.5,
              color: TColor.lightGray,
            ),
            Expanded(
              child: TitleSubtitleCell(
                title: dObj["hrs"],
                subtitle: "Online hrs",
              ),
            ),
            Container(
              height: 80,
              width: 0.5,
              color: TColor.lightGray,
            ),
            Expanded(
              child: TitleSubtitleCell(
                title: dObj["cash_trip"],
                subtitle: "Cash Trip",
              ),
            )
          ],
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: TColor.lightGray,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            children: [
              TitleSubtitleRow(
                title: "Trip fares",
                subtitle: dObj["trips"],
                color: TColor.secondaryText,
              ),
              TitleSubtitleRow(
                title: "Fee",
                subtitle: dObj["fee"],
                color: TColor.secondaryText,
              ),
              TitleSubtitleRow(
                title: "+Tax",
                subtitle: dObj["tax"],
                color: TColor.secondaryText,
              ),
              TitleSubtitleRow(
                title: "+Tolls",
                subtitle: dObj["tolls"],
                color: TColor.secondaryText,
              ),
              TitleSubtitleRow(
                title: "Surge",
                subtitle: dObj["surge"],
                color: TColor.secondaryText,
              ),
              TitleSubtitleRow(
                title: "Discount(-)",
                subtitle: dObj["discount"],
                color: TColor.secondaryText,
              ),
              const Divider(),
              TitleSubtitleRow(
                title: "Total Earnings",
                subtitle: dObj["total"],
                color: TColor.primary,
                weight: FontWeight.w800,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
