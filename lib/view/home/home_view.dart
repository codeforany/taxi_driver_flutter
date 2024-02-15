import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/location_helper.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/common_widget/Icon_title_subtitle_button.dart';
import 'package:taxi_driver/view/home/run_ride_view.dart';
import 'package:taxi_driver/view/home/tip_request_view.dart';
import 'package:taxi_driver/view/menu/menu_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isOpen = true;

  bool isDriverOnline = false;

  MapController controller = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiHome();
    isDriverOnline = Globs.udValueBool("is_online");

    if (ServiceCall.userType == 2) {
      LocationHelper.shared().startInit();
    
      // Received Message In Socket On Event
      SocketManager.shared.socket?.on("new_ride_request", (data) {
        print("new_ride_request socket get :${data.toString()} ");
        if (data[KKey.status] == "1") {
          var bArr = data[KKey.payload] as List? ?? [];

          
          if(mounted && bArr.isNotEmpty){
            context.push( TipRequestView(bObj: bArr[0]) );
          }
        }
      });
      
    }
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
      body: Stack(
        children: [
          OSMFlutter(
              controller: controller,
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: const RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                markerOption: MarkerOption(
                    defaultMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(35),
                      onTap: () {


                          isDriverOnline = !isDriverOnline;
                          
                          apiGoOnline();
                       // context.push(const TipRequestView());
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                color: isDriverOnline ? TColor.red : TColor.primary,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ]),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            alignment: Alignment.center,
                            child:  Text(
                              isDriverOnline ? "OFF"  : "GO",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        child: Image.asset(
                          "assets/img/current_location.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                    Row(
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
                        Text(
                          isDriverOnline ? "You're online" : "You're offline",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    if (isOpen)
                      Container(
                        height: 0.5,
                        width: double.maxFinite,
                        color: TColor.placeholder.withOpacity(0.5),
                      ),
                    if (isOpen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: IconTitleSubtitleButton(
                                title: "95.0%",
                                subtitle: "Acceptance",
                                icon: "assets/img/acceptance.png",
                                onPressed: () {}),
                          ),
                          Container(
                            height: 100,
                            width: 0.5,
                            color: TColor.placeholder.withOpacity(0.5),
                          ),
                          Expanded(
                            child: IconTitleSubtitleButton(
                                title: "4.75",
                                subtitle: "Rating",
                                icon: "assets/img/rate.png",
                                onPressed: () {}),
                          ),
                          Container(
                            height: 100,
                            width: 0.5,
                            color: TColor.placeholder.withOpacity(0.5),
                          ),
                          Expanded(
                            child: IconTitleSubtitleButton(
                                title: "2.0%",
                                subtitle: "Cancelleation",
                                icon: "assets/img/cancelleation.png",
                                onPressed: () {}),
                          ),
                        ],
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
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 60,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                ),
                              ]),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\$",
                                style: TextStyle(
                                    color: TColor.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "157.75",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 60,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            InkWell(
                              onTap: () {
                                context.push(const MenuView());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/img/u1.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              constraints: const BoxConstraints(minWidth: 15),
                              child: const Text(
                                "3",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //MARK: ApiCalling
  void apiGoOnline() {
    Globs.showHUD();
    ServiceCall.post(
        {"is_online": isDriverOnline ? "1" : "0"}, SVKey.svDriverGoOnline,
        isTokenApi: true, withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        Globs.udBoolSet(isDriverOnline, "is_online");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(responseObj[KKey.message] as String? ?? MSG.success)));

        if (mounted) {
          setState(() {});
        }
      } else {
         isDriverOnline = !isDriverOnline;
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (error) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, error.toString(), () {});
    });
  }

  void apiHome() {
    Globs.showHUD();
    ServiceCall.post(
        {}, SVKey.svHome,
        isTokenApi: true, withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
          var rObj = (responseObj[KKey.payload] as Map? ?? {})["running"] as Map? ?? {};
          
          if(rObj.keys.isNotEmpty) {
            context.push(RunRideView(rObj: rObj));
          }
          

      } else {
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (error) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, error.toString(), () {});
    });
  }
}
