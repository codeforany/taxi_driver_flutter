import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';

class LocationHelper {
  static final LocationHelper singleton = LocationHelper.internal();
  factory LocationHelper() => singleton;
  LocationHelper.internal();
  static LocationHelper shared() => singleton;

  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

  StreamSubscription<Position>? positionStreamSub;
  StreamSubscription<ServiceStatus>? serviceStatusStreamSub;
  bool positionSteamStarted = true;

  void startInit() async {
    var isAccess = await handlePermission();

    if(!isAccess) {
      return;
    }

    if(serviceStatusStreamSub == null) {
      final serviceStatusStream = geolocatorPlatform.getServiceStatusStream();
      serviceStatusStreamSub = serviceStatusStream.handleError( (error) {

          serviceStatusStreamSub?.cancel();
          serviceStatusStreamSub = null;

      } ).listen((serviceStatus) {
          String serviceStatusValue;

          if(serviceStatus == ServiceStatus.enabled) {
            if(positionSteamStarted) { 
              //Start Location Listen logic
              locationChangeListening();
            }
            serviceStatusValue = "enabled";

          }else{
            if(positionStreamSub != null) {
              positionStreamSub?.cancel();
              positionStreamSub = null;

              print("Position Stream han been canceled");
            }

            serviceStatusValue = "disabled";

          }
          print("Location service has been $serviceStatusValue");
      });
    }
  }

  void locationSendPause() {
      if( positionStreamSub != null) {
        positionStreamSub?.cancel();
        positionStreamSub = null;
        positionSteamStarted = false;
      }
  }

  void locationSendStart() {
    if(positionSteamStarted) {
      return;
    }

    locationChangeListening();
  }

  Future<bool> handlePermission() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnable) {
      return false;
    }

    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if(permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void locationChangeListening() {
      if( positionStreamSub == null ) {
        final positionStream = geolocatorPlatform.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation,
              distanceFilter: 15
            )
        );

        positionStreamSub = positionStream.handleError( (error) {

            positionStreamSub?.cancel();
            positionStreamSub = null;

        } ).listen((position) {
            //Api Calling REST Api Calling
            apiCallingLocationUpdate(position);
        });
      }
  }


  //TODO: ApiCall

  void apiCallingLocationUpdate(Position pos) {

      if(ServiceCall.userType != 2) {
        return;
      } 

      debugPrint(" Driver Location sending api calling");

      ServiceCall.post( {
        "latitude": pos.latitude.toString(),
        "longitude": pos.longitude.toString(),
        "socket_id": SocketManager.shared.socket?.id ?? ""
      }, SVKey.svUpdateLocationDriver, isTokenApi: true, withSuccess: (responseObj) async {

          if(responseObj[KKey.status]  == "1" ) {
            debugPrint(" Location send success");
          }else{
            debugPrint(" Location send fill : ${  responseObj[KKey.message].toString() }");
          }

      }, failure: (error) async {
            debugPrint(" Location send fill : $error");
      } );


  }
}
