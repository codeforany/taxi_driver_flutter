import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class CarServiceSelectView extends StatefulWidget {
  final List serviceArr;
  final Function(dynamic) didSelect;

  const CarServiceSelectView(
      {super.key, required this.serviceArr, required this.didSelect});

  @override
  State<CarServiceSelectView> createState() => _CarServiceSelectViewState();
}

class _CarServiceSelectViewState extends State<CarServiceSelectView> {
  // List listArr = [
  //   {
  //     "icon": "assets/img/car_1.png",
  //     "name": "Economy",
  //     "price": "\$10-\$20",
  //   },
  //   {
  //     "icon": "assets/img/car_1.png",
  //     "name": "Luxury",
  //     "price": "\$13-\$23",
  //   },
  //   {
  //     "icon": "assets/img/car_1.png",
  //     "name": "First Class",
  //     "price": "\$25-\$30",
  //   },
  // ];

  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "Select Car Service",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var cObj = widget.serviceArr[index] as Map? ?? {};

                var estMinVal = (cObj["est_price_min"] as double? ?? 0.0);
                var estMaxVal = (cObj["est_price_max"] as double? ?? 0.0);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectIndex = index;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 45),
                        padding: const EdgeInsets.only(
                          left: 90,
                        ),
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: selectIndex == index
                                    ? TColor.primary
                                    : Colors.black26,
                                blurRadius: 3,
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cObj["service_name"],
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "\$${estMinVal.toStringAsFixed(1)} - \$${estMaxVal.toStringAsFixed(1)}",
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      CachedNetworkImage(
                        imageUrl: cObj["icon"] as String? ?? "",
                        fit: BoxFit.contain,
                        width: 130,
                        height: 100,
                      ),
                      // Image.asset(
                      //   cObj["icon"] as String? ?? "",
                      //   fit: BoxFit.contain,
                      //   width: 130,
                      //   height: 100,
                      // ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemCount: widget.serviceArr.length,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: RoundButton(
                title: "Book Ride",
                onPressed: () {
                  Navigator.pop(context);
                  widget
                      .didSelect(widget.serviceArr[selectIndex] as Map? ?? {});
                }),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
