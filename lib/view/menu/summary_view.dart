import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/title_subtitle_cell.dart';
import 'package:taxi_driver/common_widget/today_summary_row.dart';
import 'package:taxi_driver/common_widget/weekly_summary_row.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int touchedIndex = -1;

  Map todayObj = {};
  Map weekObj = {};

  List todayTripsArr = [];

  List weeklyTripsArr = [];
  List weeklyChartArr = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    apiList();
  }

  @override
  Widget build(BuildContext context) {
    var todayTotal = double.tryParse(todayObj["total_amt"].toString()) ?? 0.0;
    var todayCashTotal =
        double.tryParse(todayObj["cash_amt"].toString()) ?? 0.0;
    var todayOnlineTotal =
        double.tryParse(todayObj["online_amt"].toString()) ?? 0.0;

    var weekTotal = double.tryParse(weekObj["total_amt"].toString()) ?? 0.0;
    var weekCashTotal = double.tryParse(weekObj["cash_amt"].toString()) ?? 0.0;
    var weekOnlineTotal =
        double.tryParse(weekObj["online_amt"].toString()) ?? 0.0;

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
          "Summary",
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
            tabs: const [
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
                          Container(
                            width: double.maxFinite,
                            height: 12,
                            color: TColor.lightWhite,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            DateTime.now()
                                .stringFormat(format: "EEE, dd MMM yy"),
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
                                todayTotal.toStringAsFixed(2),
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 30,
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
                                      title:
                                          (todayObj["tips_count"] as int? ?? 0)
                                              .toString(),
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
                                      title:
                                          "\$${todayOnlineTotal.toStringAsFixed(2)}",
                                      subtitle: "Online Trip",
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 0.5,
                                    color: TColor.lightGray,
                                  ),
                                  Expanded(
                                    child: TitleSubtitleCell(
                                      title:
                                          "\$${todayCashTotal.toStringAsFixed(2)}",
                                      subtitle: "Cash Trip",
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 60,
                                color: TColor.lightWhite,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "TRIPS",
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                itemBuilder: (context, index) {
                                  var sObj = todayTripsArr[index] as Map? ?? {};

                                  return TodaySummaryRow(
                                    sObj: sObj,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  indent: 40,
                                ),
                                itemCount: todayTripsArr.length,
                              ),
                            ],
                          )
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
                          Container(
                            width: double.maxFinite,
                            height: 12,
                            color: TColor.lightWhite,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            DateTime.now()
                                .stringFormat(format: "EEE, dd MMM yy"),
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
                                weekTotal.toStringAsFixed(2),
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: context.width * 0.5,
                            child: BarChart(
                              BarChartData(
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.grey,
                                    tooltipHorizontalAlignment:
                                        FLHorizontalAlignment.right,
                                    tooltipMargin: 10,
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      var obj =
                                          weeklyChartArr[group.x] as Map? ?? {};

                                      var weekDay = obj["date"]
                                          .toString()
                                          .stringFormatToOtherFormat(
                                              newFormat: "EEEE");

                                      return BarTooltipItem(
                                        '$weekDay\n\$${ ( double.tryParse( obj["total_amt"].toString()) ?? 0.0 ).toStringAsFixed(2) }',
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
                          Column(
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
                                      title:
                                          (weekObj["tips_count"] as int? ?? 0)
                                              .toString(),
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
                                      title:
                                          "\$${weekOnlineTotal.toStringAsFixed(2)}",
                                      subtitle: "Online Trip",
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 0.5,
                                    color: TColor.lightGray,
                                  ),
                                  Expanded(
                                    child: TitleSubtitleCell(
                                      title:
                                          "\$${weekCashTotal.toStringAsFixed(2)}",
                                      subtitle: "Cash Trip",
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 60,
                                color: TColor.lightWhite,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "TRIPS",
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  itemBuilder: (context, index) {
                                    var sObj =
                                        weeklyChartArr[index] as Map? ?? {};

                                    return WeeklySummaryRow(
                                      sObj: sObj,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                        indent: 40,
                                      ),
                                  itemCount: weeklyChartArr.length)
                            ],
                          )
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

    var obj = weeklyChartArr[value.toInt()] as Map? ?? {};

    return SideTitleWidget(
        space: 16,
        axisSide: meta.axisSide,
        child: Text(
          obj["date"].toString().stringFormatToOtherFormat(newFormat: "EEE"),
          style: style,
        ));
  }

  List<BarChartGroupData> showingGroups() => weeklyChartArr.map((e) {
        var i = weeklyChartArr.indexOf(e);
        return makeGroupData(i,
            double.tryParse(e["total_amt"].toString()) ?? 0.0, TColor.primary,
            isTouched: i == touchedIndex);
      }).toList();

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

  //TODO: ApiCalling
  void apiList() {
    Globs.showHUD();
    ServiceCall.post(
      {},
      SVKey.svDriverSummary,
      isTokenApi: true,
      withSuccess: (responseObj) async {
        Globs.hideHUD();

        if (responseObj[KKey.status] == "1") {
          var payloadObj = responseObj[KKey.payload] as Map? ?? {};
          todayObj = payloadObj["today"] as Map? ?? {};
          weekObj = payloadObj["week"] as Map? ?? {};

          todayTripsArr = todayObj["list"] as List? ?? [];
          weeklyTripsArr = weekObj["list"] as List? ?? [];
          weeklyChartArr = (weekObj["chart"] as List? ?? []).reversed.toList();

          if (mounted) {
            setState(() {});
          }
        } else {
          mdShowAlert(
              "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
        }
      },
      failure: (err) async {
        Globs.hideHUD();
        debugPrint(err.toString());
      },
    );
  }
}
