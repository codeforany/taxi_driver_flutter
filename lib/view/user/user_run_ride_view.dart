import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/common_widget/icon_title_button.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/home/support/support_message_view.dart';
import 'package:taxi_driver/view/home/tip_detail_view.dart';

class UserRunRideView extends StatefulWidget {
  final Map rObj;
  const UserRunRideView({super.key, required this.rObj});

  @override
  State<UserRunRideView> createState() => _UserRunRideViewState();
}

const bsPending = 0;
const bsAccept = 1;
const bsGoUser = 2;
const bsWaitUser = 3;
const bsStart = 4;
const bsComplete = 5;
const bsCancel = 6;

class _UserRunRideViewState extends State<UserRunRideView>
    with OSMMixinObserver {
  bool isOpen = true;

  Map rideObj = {};

  TextEditingController txtOTP = TextEditingController();
  TextEditingController txtToll = TextEditingController();

  //1 = Accept Ride
  //2 = Start
  //4 = Complete

  late MapController controller;
  //23.02756018230479, 72.58131973941731
  //23.02726396414328, 72.5851928489523

  String timeCount = "...";
  String km = "...";

  double ratingVal = 5.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rideObj = widget.rObj;

    if (rideObj["booking_status"] < bsStart) {
      controller = MapController(
        initPosition: GeoPoint(
            latitude: double.tryParse(rideObj["pickup_lat"].toString()) ?? 0.0,
            longitude:
                double.tryParse(rideObj["pickup_long"].toString()) ?? 0.0),
      );
    } else {
      controller = MapController(
        initPosition: GeoPoint(
            latitude: double.tryParse(rideObj["drop_lat"].toString()) ?? 0.0,
            longitude: double.tryParse(rideObj["drop_long"].toString()) ?? 0.0),
      );
    }

    controller.addObserver(this);

    SocketManager.shared.socket?.on("driver_cancel_ride", (data) {
      print("driver_cancel_ride socket get : ${data.toString()}");
      if (data[KKey.status] == "1") {
        if (data[KKey.payload]["booking_id"] == rideObj["booking_id"]) {
          openUserRideCancelPopup();
        }
      }
    });

    SocketManager.shared.socket?.on("driver_wait_user", (data) {
      print("driver_wait_user socket get : ${data.toString()}");
      if (data[KKey.status] == "1") {
        if (data[KKey.payload]["booking_id"] == rideObj["booking_id"]) {
          rideObj["booking_status"] = data[KKey.payload]["booking_status"];

          if (mounted) {
            setState(() {});
          }
        }
      }
    });

    SocketManager.shared.socket?.on("ride_start", (data) {
      print("ride_start socket get : ${data.toString()}");
      if (data[KKey.status] == "1") {
        if (data[KKey.payload]["booking_id"] == rideObj["booking_id"]) {
          rideObj["booking_status"] = data[KKey.payload]["booking_status"];

          loadMapRoad();
        }
      }
    });

    SocketManager.shared.socket?.on("ride_stop", (data) {
      print("ride_stop socket get : ${data.toString()}");
      if (data[KKey.status] == "1") {
        if (data[KKey.payload]["booking_id"] == rideObj["booking_id"]) {
          rideObj["booking_status"] = data[KKey.payload]["booking_status"];
          rideObj["amt"] = data[KKey.payload]["amount"].toString();
          rideObj["tax_amt"] = data[KKey.payload]["tax_amount"].toString();
          rideObj["duration"] = data[KKey.payload]["duration"];
          rideObj["total_distance"] =
              data[KKey.payload]["total_distance"].toString();
          rideObj["toll_tax"] = data[KKey.payload]["toll_tax"].toString();
          loadMapRoad();
          
          if(mounted) {
            setState(() {});
          }
          
          showRideCompletedPopup();
        }
      }
    });
  }

  void openUserRideCancelPopup() async {
    mdShowAlert("Ride Cancel", "Driver cancel ride", () {
      context.pop();
    }, isForce: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var showPickUp = rideObj["booking_status"] < bsStart;

    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
                enableRotationByGesture: true,
                zoomOption: const ZoomOption(
                  initZoom: 15,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                staticPoints: [],
                roadConfiguration: const RoadOption(
                  roadColor: Colors.blueAccent,
                ),
                markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  ),
                ),
                showDefaultInfoWindow: false),
            onMapIsReady: (isReady) {
              if (isReady) {
                print("map is ready");
              }
            },
            onLocationChanged: (myLocation) {
              print("user location :$myLocation");
            },
            onGeoPointClicked: (myLocation) {
              print("GeoPointClicked location :$myLocation");
            },
          ),
          if (rideObj["booking_status"] != bsComplete)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (rideObj["booking_status"] == bsWaitUser)
                  // Ride Arrived Status
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            TimerCountdown(
                              format: CountDownTimerFormat.minutesSeconds,
                              endTime: DateTime.now().add(
                                const Duration(
                                  minutes: 2,
                                ),
                              ),
                              onEnd: () {
                                print("Timer finished");
                              },
                              timeTextStyle: TextStyle(
                                color: TColor.secondary,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                              ),
                              colonsTextStyle: TextStyle(
                                color: TColor.secondary,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                              ),
                              spacerWidth: 0,
                              daysDescription: "",
                              hoursDescription: "",
                              minutesDescription: "",
                              secondsDescription: "",
                            ),
                            Text(
                              "Waiting for rider",
                              textAlign: TextAlign.center,
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
                // if (rideObj["booking_status"] == bsStart)
                //   // Ride Started Status
                //   Container(
                //     margin: const EdgeInsets.all(20),
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 10, horizontal: 25),
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(50),
                //         boxShadow: const [
                //           BoxShadow(
                //             color: Colors.black12,
                //             blurRadius: 10,
                //             offset: Offset(0, -5),
                //           ),
                //         ]),
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Stack(
                //           alignment: Alignment.bottomCenter,
                //           children: [
                //             TimerCountdown(
                //               format: CountDownTimerFormat.minutesSeconds,
                //               endTime: DateTime.now().add(
                //                 const Duration(
                //                   minutes: 2,
                //                 ),
                //               ),
                //               onEnd: () {
                //                 print("Timer finished");
                //               },
                //               timeTextStyle: TextStyle(
                //                 color: TColor.secondary,
                //                 fontWeight: FontWeight.w800,
                //                 fontSize: 25,
                //               ),
                //               colonsTextStyle: TextStyle(
                //                 color: TColor.secondary,
                //                 fontWeight: FontWeight.w800,
                //                 fontSize: 25,
                //               ),
                //               spacerWidth: 0,
                //               daysDescription: "",
                //               hoursDescription: "",
                //               minutesDescription: "",
                //               secondsDescription: "",
                //             ),
                //             Text(
                //               "Arrived at dropoff",
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 color: TColor.secondaryText,
                //                 fontSize: 16,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isOpen = !isOpen;
                                });
                              },
                              icon: Image.asset(
                                isOpen
                                    ? "assets/img/open_btn.png"
                                    : "assets/img/close_btn.png",
                                width: 15,
                                height: 15,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$timeCount min",
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(17.5),
                                  child: CachedNetworkImage(
                                    imageUrl: rideObj["image"] as String? ?? "",
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "$km km",
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/img/call.png",
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${statusName()} ${rideObj["name"] ?? ""}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                      if (isOpen)
                        const SizedBox(
                          height: 8,
                        ),
                      if (isOpen)
                        const Divider(
                          height: 0.5,
                          endIndent: 20,
                          indent: 20,
                        ),
                      if (isOpen)
                        const SizedBox(
                          height: 8,
                        ),
                      if (isOpen)
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: rideObj["image"] as String? ?? "",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          rideObj["name"] as String? ?? "",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          statusText(),
                                          style: TextStyle(
                                              color: statusColor(),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${rideObj["mobile_code"] as String? ?? ""} ${rideObj["mobile"] as String? ?? ""}",
                                          style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          (rideObj["payment_type"] ?? 1) == 1
                                              ? "COD"
                                              : "Online",
                                          style: TextStyle(
                                            color: TColor.secondaryText,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      if (isOpen)
                        const Divider(
                          height: 0.5,
                          endIndent: 20,
                          indent: 20,
                        ),
                      if (isOpen)
                        const SizedBox(
                          height: 8,
                        ),
                      if (isOpen)
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: rideObj["icon"] as String? ?? "",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${rideObj["brand_name"] as String? ?? ""} - ${rideObj["model_name"] as String? ?? ""} - ${rideObj["series_name"] as String? ?? ""}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "No Plat: ${rideObj["car_number"] as String? ?? ""}",
                                          style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 14),
                                        ),
                                        if (rideObj["booking_status"] <=
                                            bsWaitUser)
                                          Text(
                                            "OTP Code: ${rideObj["otp_code"] as String? ?? ""}",
                                            style: TextStyle(
                                                color: TColor.secondaryText,
                                                fontSize: 14),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      if (isOpen)
                        const Divider(
                          height: 0.5,
                          endIndent: 20,
                          indent: 20,
                        ),
                      if (isOpen)
                        const SizedBox(
                          height: 8,
                        ),
                      if (isOpen)
                        Row(
                          children: [
                            Expanded(
                              child: IconTitleButton(
                                icon: "assets/img/chat.png",
                                title: "Chat",
                                onPressed: () {
                                  context.push(SupportMessageView(uObj: {
                                    "user_id": rideObj["user_id"],
                                    "name": rideObj["name"],
                                    "image": rideObj["image"]
                                  }));
                                },
                              ),
                            ),
                            Expanded(
                              child: IconTitleButton(
                                icon: "assets/img/message.png",
                                title: "Message",
                                onPressed: () {},
                              ),
                            ),
                            Expanded(
                              child: IconTitleButton(
                                icon: "assets/img/cancel_trip.png",
                                title: "Cancel Tip",
                                onPressed: () async {
                                  await showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      barrierColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 5, sigmaY: 5),
                                                child: Container(
                                                  color: Colors.black38,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 10,
                                                        offset: Offset(0, -5),
                                                      ),
                                                    ]),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Cancel ${rideObj["name"] ?? ""} trip?",
                                                      style: TextStyle(
                                                          color: TColor
                                                              .primaryText,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Divider(),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    RoundButton(
                                                        title: "YES, CANCEL",
                                                        type:
                                                            RoundButtonType.red,
                                                        onPressed: () {
                                                          context.pop();

                                                          apiCancelRide();

                                                          // context.push(
                                                          //     const ReasonView());
                                                        }),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    RoundButton(
                                                        title: "NO",
                                                        type: RoundButtonType
                                                            .boarded,
                                                        onPressed: () {
                                                          context.pop();
                                                        }),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]);
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                )
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ]),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "How was your rider?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        rideObj["name"] as String? ?? "",
                        textAlign: TextAlign.center,
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
                        initialRating: ratingVal,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          ratingVal = rating;
                          print(rating);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RoundButton(
                            title: "RATE RIDER",
                            onPressed: () {
                              apiSubmitRate();
                              // context.push(const TipDetailsView());
                            }),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                )
              ],
            ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            ),
                          ]),
                      child: Row(
                        children: [
                          Image.asset(
                            showPickUp
                                ? "assets/img/pickup_pin_1.png"
                                : "assets/img/drop_pin_1.png",
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              rideObj[showPickUp
                                      ? "pickup_address"
                                      : "drop_address"] as String? ??
                                  "",
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addMarker() async {
    await controller.setMarkerOfStaticPoint(
      id: "pickup",
      markerIcon: MarkerIcon(
        iconWidget: Image.asset(
          "assets/img/pickup_pin.png",
          width: 80,
          height: 80,
        ),
      ),
    );

    await controller.setMarkerOfStaticPoint(
      id: "dropoff",
      markerIcon: MarkerIcon(
        iconWidget: Image.asset(
          "assets/img/drop_pin.png",
          width: 80,
          height: 80,
        ),
      ),
    );

    loadMapRoad();
  }

  void loadMapRoad() async {
    if (rideObj["booking_status"] == bsGoUser ||
        rideObj["booking_status"] == bsWaitUser) {
      // Current to Pickup Location Road Draw
      await controller.setStaticPosition([
        GeoPoint(
            latitude: double.tryParse(rideObj["pickup_lat"].toString()) ?? 0.0,
            longitude:
                double.tryParse(rideObj["pickup_long"].toString()) ?? 0.0)
      ], "pickup");

      await controller.setStaticPosition([
        GeoPoint(
            latitude: double.tryParse(rideObj["drop_lat"].toString()) ?? 0.0,
            longitude: double.tryParse(rideObj["drop_long"].toString()) ?? 0.0)
      ], "dropoff");

      var roadInfo = await controller.drawRoad(
          GeoPoint(
              latitude: double.tryParse(rideObj["lati"].toString()) ?? 0.0,
              longitude: double.tryParse(rideObj["longi"].toString()) ?? 0.0),
          GeoPoint(
              latitude:
                  double.tryParse(rideObj["pickup_lat"].toString()) ?? 0.0,
              longitude:
                  double.tryParse(rideObj["pickup_long"].toString()) ?? 0.0),
          roadType: RoadType.car,
          roadOption: const RoadOption(
              roadColor: Colors.blueAccent, roadBorderWidth: 3));
      timeCount = ((roadInfo.duration ?? 0.0) / 60.0).toStringAsFixed(1);
      km = ((roadInfo.distance ?? 0.0)).toStringAsFixed(1);
    } else {
      // Current Location to Drop Off Location Draw Road
      await controller.setStaticPosition([
        GeoPoint(
            latitude: double.tryParse(rideObj["drop_lat"].toString()) ?? 0.0,
            longitude: double.tryParse(rideObj["drop_long"].toString()) ?? 0.0)
      ], "dropoff");

      var roadInfo = await controller.drawRoad(
          GeoPoint(
              latitude: double.tryParse(rideObj["lati"].toString()) ?? 0.0,
              longitude: double.tryParse(rideObj["longi"].toString()) ?? 0.0),
          GeoPoint(
              latitude: double.tryParse(rideObj["drop_lat"].toString()) ?? 0.0,
              longitude:
                  double.tryParse(rideObj["drop_long"].toString()) ?? 0.0),
          roadType: RoadType.car,
          roadOption: const RoadOption(
              roadColor: Colors.blueAccent, roadBorderWidth: 3));
      timeCount = ((roadInfo.duration ?? 0.0) / 60.0).toStringAsFixed(1);
      km = ((roadInfo.distance ?? 0.0)).toStringAsFixed(1);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      addMarker();
    }
  }

  //TODO: ApiCalling

  void apiCancelRide() {
    Globs.showHUD();
    ServiceCall.post({
      "booking_id": rideObj["booking_id"].toString(),
      "booking_status": rideObj["booking_status"].toString()
    }, SVKey.svUserRideCancel, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        mdShowAlert(
            Globs.appName, responseObj[KKey.message] as String? ?? MSG.success,
            () {
          context.pop();
        });
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }

  void apiSubmitRate() {
    Globs.showHUD();
    ServiceCall.post(
      {
        "booking_id": rideObj["booking_id"].toString(),
        "rating": ratingVal.toString(),
        "comment": "",
      },
      SVKey.svRideRating,
      isTokenApi: true,
      withSuccess: (responseObj) async {
        Globs.hideHUD();
        if (responseObj[KKey.status] == "1") {
          mdShowAlert(Globs.appName,
              responseObj[KKey.message] as String? ?? MSG.success, () {
            context.pop();
          });
        } else {
          mdShowAlert(Globs.appName,
              responseObj[KKey.message] as String? ?? MSG.fail, () {});
        }
      },
      failure: (err) async {
        Globs.hideHUD();
        mdShowAlert(Globs.appName, err.toString(), () {});
      },
    );
  }

  String statusName() {
    switch (rideObj["booking_status"]) {
      case 2:
        return "On Way Driver";
      case 3:
        return "Waiting Driver";
      case 4:
        return "Ride Started With";
      case 5:
        return "Ride Complete With";
      case 6:
        return "Ride Cancel";
      case 7:
        return "No Driver Found";
      default:
        return "Finding Driver Near By";
    }
  }

  String statusText() {
    switch (rideObj["booking_status"]) {
      case 2:
        return "On Way";
      case 3:
        return "Waiting";
      case 4:
        return "Started";
      case 5:
        return "Completed";
      case 6:
        return "Cancel";
      case 7:
        return "No Drivers";
      default:
        return "Pending";
    }
  }

  Color statusColor() {
    switch (rideObj["booking_status"]) {
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.green;
      case 5:
        return Colors.green;
      case 6:
        return Colors.red;
      case 7:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void showRideCompletedPopup() async {
    var taxAmt = double.tryParse(rideObj["tax_amt"] ?? "0.0") ?? 0.0;
    var tollAmt = double.tryParse(rideObj["toll_tax"] ?? "0.0") ?? 0.0;
    var payableAmt = double.tryParse(rideObj["amt"] ?? "0.0") ?? 0.0;
    var totalAmt = payableAmt - tollAmt - taxAmt;

    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black38,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5))
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ride Completed",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Mode:",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 20),
                        ),
                        Text(
                          (rideObj["payment_type"] ?? 1) == 1
                              ? "COD"
                              : "ONLINE",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Distance:",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 17),
                        ),
                        Text(
                          "${(double.tryParse(rideObj["total_distance"] ?? "0") ?? 0.0).toStringAsFixed(2)} KM",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Duration:",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 17),
                        ),
                        Text(
                          rideObj["duration"] ?? " 00:00",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount:",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 17),
                        ),
                        Text(
                          "\$${totalAmt.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tax Amount:",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 17),
                        ),
                        Text(
                          "+\$${taxAmt.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Toll Tax:",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 17),
                        ),
                        Text(
                          "+\$${tollAmt.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 90,
                          height: 2,
                          color: TColor.primaryText,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payable Amount:",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "\$${payableAmt.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RoundButton(
                        title: "Yes, Accept Toll Tax",
                        type: RoundButtonType.red,
                        onPressed: () {
                          // context.pop();
                          context.pop();
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    RoundButton(
                        title: "No",
                        onPressed: () {
                          // context.pop();
                          context.pop();
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
