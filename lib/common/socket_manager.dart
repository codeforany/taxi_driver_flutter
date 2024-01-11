import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';

class SocketManager {
  static final SocketManager sigleton = SocketManager._internal();
  SocketManager._internal();
  IO.Socket? socket;
  static SocketManager get shared => sigleton;

  void initSocket() {
    socket = IO.io(SVKey.mainUrl, {
      "transports": ['websocket'],
      "autoConnect": true
    });

    socket?.on("connect", (data) {
      if (kDebugMode) {
        print("Socket Connect Done");
      }

      //Emit Method

      if(Globs.udValueBool(Globs.userLogin)) {
          updateSocketIdApi();
      }
    });

    socket?.on("connect_error", (data) {
      if (kDebugMode) {
        print("Socket Connect Error");
        print(data);
      }
    });

    socket?.on("error", (data) {
      if (kDebugMode) {
        print("Socket Error");
        print(data);
      }
    });

    socket?.on("disconnect", (data) {
      if (kDebugMode) {
        print("Socket disconnect");
        print(data);
      }
    });

    // Out Socket Emit Listener

    socket?.on("UpdateSocket", (data) {
      print(" UpdateSocket : ---------------- ");
      print(data);
    });
  }

  Future updateSocketIdApi() async {
    try {
      socket?.emit("UpdateSocket", jsonEncode( {'access_token' : ServiceCall.userObj["auth_token"].toString()} ));
    } catch (e) {
        if(kDebugMode) {
          print(e.toString());
        }
    }
  }
}
