import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/title_subtitle_row.dart';
import 'package:taxi_driver/view/home/run_ride_view.dart';

class TipDetailsView extends StatefulWidget {
  const TipDetailsView({super.key});

  @override
  State<TipDetailsView> createState() => _TipDetailsViewState();
}

class _TipDetailsViewState extends State<TipDetailsView> with OSMMixinObserver {
  bool isOpen = true;

  late MapController controller;
  //23.02756018230479, 72.58131973941731
  //23.02726396414328, 72.5851928489523

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = MapController(
      initPosition:
          GeoPoint(latitude: 23.02756018230479, longitude: 72.58131973941731),
    );

    controller.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 30,
            height: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Trip Details",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Image.asset(
              "assets/img/question_mark.png",
              width: 20,
              height: 20,
            ),
            label: Text(
              "Help",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: TColor.secondary,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "1 Ash Park, Pembroke Dock, SA72",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: TColor.primary),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "54 Hollybank Rd, Southampton",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: context.width,
              height: context.width * 0.5,
              child: OSMFlutter(
                controller: controller,
                osmOption: OSMOption(
                    enableRotationByGesture: true,
                    zoomOption: const ZoomOption(
                      initZoom: 8,
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
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: const BoxDecoration(color: Colors.white, ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "\$154.57",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Payment made sucessfully by Cash",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "15 min",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "Time",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: TColor.lightGray.withOpacity(0.5),
                          width: 1,
                          height: 70,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "10 mi",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "Distance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Column(
                      children: [
                        TitleSubtitleRow(
                          title: "Date & Time",
                          subtitle: "14 Feb'23 at 9:42am",
                        ),
                        TitleSubtitleRow(
                          title: "Service Type",
                          subtitle: "Sedan",
                        ),
                        TitleSubtitleRow(
                          title: "Trip Type",
                          subtitle: "Normal",
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You rated \"JohnDon\"",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        "assets/img/ride_user_profile.png",
                        width: 35,
                        height: 35,
                      ),
                      const SizedBox(
                        width: 15,
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
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "RECEIPT",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ]),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                   Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Column(
                      children: [
                        TitleSubtitleRow(
                          title: "Trip fares",
                          subtitle: "\$40.25",
                          color: TColor.secondaryText,
                        ),
                        TitleSubtitleRow(
                          title: "Fee",
                          subtitle: "\$20.00",
                          color: TColor.secondaryText,
                        ),
                        TitleSubtitleRow(
                          title: "+Tax",
                          subtitle: "\$400.50",
                          color: TColor.secondaryText,
                        ),
                        TitleSubtitleRow(
                          title: "+Tolls",
                          subtitle: "\$400.50",
                          color: TColor.secondaryText,
                        ),
                        TitleSubtitleRow(
                          title: "Discount",
                          subtitle: "\$40.25",
                          color: TColor.secondaryText,
                        ),
                        TitleSubtitleRow(
                          title: "+Topup Added",
                          subtitle: "\$20.00",
                          color: TColor.secondaryText,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TitleSubtitleRow(
                            title: "Your payment",
                            subtitle: "\$1000.00",
                            color: TColor.primary,
                            weight: FontWeight.w800,
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "This trip was towards your destination you received Guaranteed fare",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
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

    //23.02756018230479, 72.58131973941731
    //23.02726396414328, 72.5851928489523

    await controller.setStaticPosition(
        [GeoPoint(latitude: 23.02756018230479, longitude: 72.58131973941731)],
        "pickup");

    await controller.setStaticPosition(
        [GeoPoint(latitude: 23.02726396414328, longitude: 72.5851928489523)],
        "dropoff");

    loadMapRoad();
  }

  void loadMapRoad() async {
    await controller.drawRoad(
        GeoPoint(latitude: 23.02756018230479, longitude: 72.58131973941731),
        GeoPoint(latitude: 23.02726396414328, longitude: 72.5851928489523),
        roadType: RoadType.car,
        roadOption:
            const RoadOption(roadColor: Colors.blueAccent, roadBorderWidth: 3));
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      addMarker();
    }
  }
}
