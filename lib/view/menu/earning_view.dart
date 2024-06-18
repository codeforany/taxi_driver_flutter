import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/price_list_view.dart';
import 'package:fl_chart/fl_chart.dart';

class EarningView extends StatefulWidget {
  const EarningView({super.key});

  @override
  State<EarningView> createState() => _EarningViewState();
}

class _EarningViewState extends State<EarningView>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int touchedIndex = -1;

  Map todayObj = {
    "trips": "15",
    "hrs": "8:30",
    "cash_trip": "\$22.48",
    "trip_frars": "\$40.25",
    "fee": "\$20.00",
    "tax": "\$400.50",
    "tolls": "\$400.50",
    "surge": "\$40.25",
    "discount": "\$20.00",
    "total": "\$460.75"
  };

  Map weekObj = {
    "trips": "45",
    "hrs": "38:30",
    "cash_trip": "\$99.48",
    "trip_frars": "\$40.25",
    "fee": "\$20.00",
    "tax": "\$400.50",
    "tolls": "\$400.50",
    "surge": "\$40.25",
    "discount": "\$20.00",
    "total": "\$460.75"
  };

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

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
          "Earning",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          TabBar(
            controller: controller,
            indicatorColor: TColor.primary,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            labelColor: TColor.primary,
            unselectedLabelColor: TColor.placeholder,
            labelStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            unselectedLabelStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            tabs: [
              Tab(
                text: "TODAY",
              ),
              Tab(
                text: "WEEKLY",
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 0.5,
            color: TColor.lightGray,
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                Container(
                  color: TColor.lightWhite,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Mon, 28 Sep'23",
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "\$",
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "157.75",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          PriceListView(dObj: todayObj),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: TColor.lightWhite,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Mon, 28 Sep'23",
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "\$",
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "157.75",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: context.width * 0.5,
                            child: BarChart(
                              BarChartData(
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    // tooltipBgColor: Colors.grey,
                                    getTooltipColor:
                                        (BarChartGroupData group) =>
                                            Colors.grey,
                                    tooltipHorizontalAlignment:
                                        FLHorizontalAlignment.right,
                                    tooltipMargin: 10,
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      String weekDay;

                                      switch (group.x) {
                                        case 0:
                                          weekDay = "Sunday";

                                          break;
                                        case 1:
                                          weekDay = "Monday";

                                          break;
                                        case 2:
                                          weekDay = "Tuesday";

                                          break;
                                        case 3:
                                          weekDay = "Wednesday";

                                          break;
                                        case 4:
                                          weekDay = "Thursday";

                                          break;
                                        case 5:
                                          weekDay = "Friday";

                                          break;
                                        case 6:
                                          weekDay = "Saturday";

                                          break;
                                        default:
                                          throw Error();
                                      }

                                      return BarTooltipItem(
                                        '$weekDay\n',
                                        const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      );
                                    },
                                  ),
                                  touchCallback: (event, barTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          barTouchResponse == null ||
                                          barTouchResponse.spot == null) {
                                        touchedIndex = -1;
                                        return;
                                      }

                                      touchedIndex = barTouchResponse
                                          .spot!.touchedBarGroupIndex;
                                    });
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: getTitles,
                                        reservedSize: 38),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingGroups(),
                                gridData: const FlGridData(show: false),
                              ),
                            ),
                          ),
                          PriceListView(dObj: weekObj),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(color: TColor.secondaryText, fontSize: 12);

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          'S',
          style: style,
        );
        break;
      case 1:
        text = Text(
          'M',
          style: style,
        );
        break;
      case 2:
        text = Text(
          'T',
          style: style,
        );
        break;
      case 3:
        text = Text(
          'W',
          style: style,
        );
        break;
      case 4:
        text = Text(
          'T',
          style: style,
        );
        break;
      case 5:
        text = Text(
          'F',
          style: style,
        );
        break;
      case 6:
        text = Text(
          'S',
          style: style,
        );
        break;
      default:
        text = Text(
          '',
          style: style,
        );
        break;
    }

    return SideTitleWidget(child: text, space: 16, axisSide: meta.axisSide);
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, TColor.primary,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 10.5, TColor.primary,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, TColor.primary,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, TColor.primary,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 15, TColor.primary,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 5.5, TColor.primary,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 8.5, TColor.primary,
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartGroupData makeGroupData(int x, double y, Color barColor,
      {bool isTouched = false,
      double width = 40,
      List<int> showTooltips = const []}) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: barColor,
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.green, width: 0),
          backDrawRodData: BackgroundBarChartRodData(show: false))
    ]);
  }
}
