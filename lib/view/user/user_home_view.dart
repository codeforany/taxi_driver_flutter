import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/common_widget/location_select_button.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/model/price_detail_mode.dart';
import 'package:taxi_driver/model/zone_list_model.dart';
import 'package:taxi_driver/view/menu/menu_view.dart';
import 'package:taxi_driver/view/user/car_service_select_view.dart';
import 'package:taxi_driver/view/user/user_run_ride_view.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  bool isOpen = true;
  bool isSelectPickup = true;
  bool isLock = false;
  bool isLocationChange = true;

  GeoPoint? pickupLocation;
  Placemark? pickupAddressObj;
  String pickupAddressString = "";

  GeoPoint? dropLocation;
  Placemark? dropAddressObj;
  String dropAddressString = "";

  List<ZoneListModel> zoneListArr = [];
  ZoneListModel? selectZone;

  List servicePriceArr = [];

  double estTimesInMin = 0.0;
  double estKm = 0.0;

  MapController controller = MapController(
    initPosition: GeoPoint(latitude: 21.1702, longitude: 72.8311),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeLocation();

    controller.listenerRegionIsChanging.addListener(() {
      if (controller.listenerRegionIsChanging.value != null) {
        if (isLock && !isLocationChange) {
          return;
        }

        getSelectLocation(isSelectPickup);
      }
    });

    SocketManager.shared.socket?.on("user_request_accept", (data) {
      if(data[KKey.status] == "1" ) {
        apiHome();
      }
    });

    apiHome();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void changeLocation() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    controller.goToLocation(GeoPoint(latitude: 21.1702, longitude: 72.8311));

    zoneListArr = await ZoneListModel.getActiveList();
  }

  void getSelectLocation(bool isPickup) async {
    GeoPoint centerMap = await controller.centerMap;
    print("lat: ${centerMap.latitude}, long:${centerMap.longitude}");

    List<Placemark> addressArr =
        await placemarkFromCoordinates(centerMap.latitude, centerMap.longitude);
    print("------------------");

    if (addressArr.isNotEmpty) {
      if (isPickup) {
        pickupLocation = centerMap;
        pickupAddressObj = addressArr.first;
        print(pickupAddressObj.toString());

        pickupAddressString =
            "${pickupAddressObj?.name}, ${pickupAddressObj?.street}, ${pickupAddressObj?.subLocality}, ${pickupAddressObj?.subAdministrativeArea}, ${pickupAddressObj?.administrativeArea}, ${pickupAddressObj?.postalCode}";
      } else {
        dropLocation = centerMap;
        dropAddressObj = addressArr.first;
        print(dropAddressObj.toString());

        dropAddressString =
            "${dropAddressObj?.name}, ${dropAddressObj?.street}, ${dropAddressObj?.subLocality}, ${dropAddressObj?.subAdministrativeArea}, ${dropAddressObj?.administrativeArea}, ${dropAddressObj?.postalCode}";
      }

      updateView();
    }

    //Select Location inside zone find
    if (isPickup) {
      selectZone = null;
      for (var zmObj in zoneListArr) {
        if (PolygonUtil.containsLocation(
            LatLng(centerMap.latitude, centerMap.longitude),
            zmObj.zonePathArr,
            true)) {
          // Found Inside Zone

          selectZone = zmObj;
          print("Found Inside Zone -------");

          print(zmObj.toMap().toString());
        }
      }

      if (selectZone == null) {
        print("Not Found Inside Zone -------");
      }
    }

    drawRoadPickupToDrop();
  }

  void drawRoadPickupToDrop() async {
    await controller.clearAllRoads();

    if (pickupLocation != null &&
        dropLocation != null &&
        pickupLocation?.latitude != dropLocation?.latitude &&
        pickupLocation?.longitude != dropLocation?.longitude) {
      RoadInfo roadObj = await controller.drawRoad(
        pickupLocation!,
        dropLocation!,
        roadType: RoadType.car,
        roadOption: RoadOption(
          roadColor: TColor.secondary,
          roadWidth: 10,
          zoomInto: false,
        ),
      );

      estTimesInMin = (roadObj.duration ?? 0) / 60.0;
      estKm = roadObj.distance ?? 0.0;

      if (kDebugMode) {
        print("EST Duration in Sec : ${roadObj.duration ?? 0.0} sec");
        print("EST Distance in Km : ${roadObj.distance ?? 0.0} km");
      }

      if (selectZone != null) {
        servicePriceArr =
            (await PriceDetailModel.getSelectZoneGetServiceAndPriceList(
                selectZone!.zoneId)).map((pObj) {
                     var price = getESTValue(pObj);
                  return {
                    "est_price_min": price,
                    "est_price_max": price * 1.3,
                    "service_name": pObj["service_name"],
                    "icon": pObj["icon"],
                    "service_id": pObj["service_id"],
                    "price_id": pObj["price_id"],
                  };
                } ).toList();


       
      
      }


    }
  }


  double getESTValue( dynamic pObj ) {

    var amount = ( double.tryParse(pObj["base_charge"]) ?? 0.0) +
     (( double.tryParse(pObj["per_km_charge"]) ?? 0.0) * estKm ) +
     (( double.tryParse(pObj["per_min_charge"]) ?? 0.0) * estTimesInMin ) +
      ( double.tryParse(pObj["booking_charge"]) ?? 0.0);

    if( ( double.tryParse(pObj["mini_km"]) ?? 0.0 ) >= estKm ) {
      amount = (double.tryParse(pObj["mini_fair"]) ?? 0.0);
      
    }

    var minPrice = amount;

    if( (double.tryParse(pObj["mini_fair"]) ?? 0.0) >= minPrice ) {
      minPrice = (double.tryParse(pObj["mini_fair"]) ?? 0.0);
    }


    return minPrice;
  }

  void updateView() {
    if (mounted) {
      setState(() {});
    }
  }

  void addMarkerLocation(GeoPoint point, String icon) async {
    await controller.addMarker(point,
        markerIcon: MarkerIcon(
          iconWidget: Image.asset(
            icon,
            width: 100,
            height: 100,
          ),
        ));
  }

  void removeMarkerLocation(GeoPoint point) async {
    await controller.removeMarker(point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          OSMFlutter(
              controller: controller,
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: false,
                  unFollowUser: false,
                ),
                zoomOption: const ZoomOption(
                  initZoom: 13,
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
          Image.asset(
            isSelectPickup
                ? "assets/img/pickup_pin.png"
                : "assets/img/drop_pin.png",
            width: 100,
            height: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                    LocationSelectButton(
                        title: "Pickup",
                        placeholder: "Select Pickup Location",
                        color: TColor.secondary,
                        value: pickupAddressString,
                        isSelect: isSelectPickup,
                        onPressed: () async {
                          setState(() {
                            isSelectPickup = true;
                          });

                          if (dropAddressString.isNotEmpty &&
                              dropLocation != null) {
                            //"assets/img/pickup_pin.png" : "assets/img/drop_pin.png"
                            addMarkerLocation(
                                dropLocation!, "assets/img/drop_pin.png");
                          }

                          if (pickupLocation != null) {
                            isLocationChange = false;
                            controller.goToLocation(pickupLocation!);
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            isLocationChange = true;

                            removeMarkerLocation(pickupLocation!);
                          }
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    LocationSelectButton(
                        title: "DropOff",
                        placeholder: "Select DropOff Location",
                        color: TColor.primary,
                        value: dropAddressString,
                        isSelect: !isSelectPickup,
                        onPressed: () {
                          setState(() {
                            isSelectPickup = false;
                          });

                          if (pickupAddressString.isNotEmpty &&
                              pickupLocation != null) {
                            addMarkerLocation(
                                pickupLocation!, "assets/img/pickup_pin.png");
                          }

                          if (dropAddressString.isEmpty) {
                            getSelectLocation(isSelectPickup);
                          } else {
                            isLocationChange = false;
                            controller.goToLocation(dropLocation!);
                            isLocationChange = true;
                            removeMarkerLocation(dropLocation!);
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                        title: "Continue",
                        onPressed: () {
                          openCarService();
                        }),
                    const SizedBox(
                      height: 25,
                    )
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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

  //TODO: Action

  void openCarService() {
    if (pickupLocation == null) {
      mdShowAlert("Select", "Please your pickup location", () {});
      return;
    }

    if (dropLocation == null) {
      mdShowAlert("Select", "Please you drop off location", () {});
      return;
    }

    if (selectZone == null) {
      mdShowAlert("", "Not provide any service in this area", () {});
      return;
    }

    if (servicePriceArr.isEmpty) {
      mdShowAlert("", "Not provide any service in this area", () {});
      return;
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CarServiceSelectView(
            serviceArr: servicePriceArr,
            didSelect: (selectObj) {

                print(selectObj);

                apiBookingRequest({
                  "pickup_latitude":"${ pickupLocation?.latitude ?? 0.0 }",
                  "pickup_longitude": "${pickupLocation?.longitude ?? 0.0}",
                  "pickup_address": pickupAddressString ,
                  "drop_latitude": "${dropLocation?.latitude ?? 0.0}",
                  "drop_longitude": "${dropLocation?.longitude ?? 0.0}",
                  "drop_address": dropAddressString,
                  "pickup_date": DateTime.now().stringFormat( format : "yyyy-MM-dd HH:mm:ss") ,
                  "payment_type":"1",
                  "card_id":"",
                  "price_id": selectObj["price_id"].toString() ,
                  "service_id": selectObj["service_id"].toString(),
                  "est_total_distance": estKm.toStringAsFixed(2),
                  "est_duration": estTimesInMin.toString(),
                  "amount": selectObj["est_price_max"].toStringAsFixed(2) ,
                });

            },
          );
        });
  }

  

  //TODO: ApiCalling

  void apiBookingRequest(Map<String,String> parameter) {
      Globs.showHUD();
      ServiceCall.post(parameter, SVKey.svBookingRequest, isTokenApi: true,  withSuccess: ( responseObj ) async {
        Globs.hideHUD();
        if( responseObj[KKey.status] == "1" ) {
            mdShowAlert(
            Globs.appName, responseObj[KKey.message] as String? ?? MSG.success, () {});
        }else{
          mdShowAlert("Error", responseObj[KKey.message] as String? ?? MSG.fail  , () { });
        }
      }, failure: (err) async {
          Globs.hideHUD();
          debugPrint(err.toString());
      } );

  }

  void apiHome() {
    Globs.showHUD();
    ServiceCall.post({}, SVKey.svHome, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        var rObj =
            (responseObj[KKey.payload] as Map? ?? {})["running"] as Map? ?? {};

        if (rObj.keys.isNotEmpty) {
          context.push(UserRunRideView(rObj: rObj));
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
