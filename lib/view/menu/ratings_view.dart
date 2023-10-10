import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/rating_row.dart';

class RatingsView extends StatefulWidget {
  const RatingsView({super.key});

  @override
  State<RatingsView> createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  int touchedIndex = -1;

  List listArr = [
    {
      "rate": 4.5,
      "message":
          "Your service is very good. the experience that I had was incredible.",
    },
    {
      "rate": 5.0,
      "message":
          "Your service is very good. the experience that I had was incredible.",
    },
    {
      "rate": 3.0,
      "message": "",
    },
    {
      "rate": 4.0,
      "message": "",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Ratings",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              height: 8,
              color: TColor.lightWhite,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "4.5",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/img/sm_profile.png",
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              "1415 users",
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 4,
                            centerSpaceRadius: 60,
                            startDegreeOffset: 270,
                            sections: showingSections(),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "2547",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "Total Trips",
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 8),
              color: TColor.lightWhite,
              child: Text(
                "OCT'23",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
            ),
            ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RatingRow(
                    rObj: listArr[index] as Map? ?? {},
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: listArr.length)
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;

      final radius = isTouched ? 30.0 : 20.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: TColor.primary,
            value: 40,
            title: '',
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: TColor.lightGray,
            value: 60,
            title: '',
            radius: radius,
          );

        default:
          throw Error();
      }
    });
  }
}
