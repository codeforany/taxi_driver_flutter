import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as pth;
import 'package:sqflite/sqflite.dart';
import 'package:taxi_driver/common/db_helper.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/model/document_model.dart';
import 'package:taxi_driver/model/price_detail_mode.dart';
import 'package:taxi_driver/model/service_detail_model.dart';
import 'package:taxi_driver/model/zone_document_model.dart';
import 'package:taxi_driver/model/zone_list_model.dart';

typedef ResSuccess = Future<void> Function(Map<String, dynamic>);
typedef ResFailure = Future<void> Function(dynamic);

class ServiceCall {
  static Map userObj = {};
  static int userType = 1;

  static void post(
    Map<String, dynamic> parameter,
    String path, {
    bool isTokenApi = false,
    ResSuccess? withSuccess,
    ResFailure? failure,
  }) {
    Future(() {
      try {
        var headers = {"Content-Type": 'application/x-www-form-urlencoded'};

        if (isTokenApi) {
          headers["access_token"] = userObj["auth_token"] as String? ?? "";
        }

        http
            .post(Uri.parse(path), body: parameter, headers: headers)
            .then((value) {
          if (kDebugMode) {
            print(value.body);
          }

          try {
            var jsonObj =
                json.decode(value.body) as Map<String, dynamic>? ?? {};
            if (withSuccess != null) withSuccess(jsonObj);
          } catch (e) {
            if (failure != null) failure(e.toString());
          }
        }).catchError((e) {
          if (failure != null) failure(e.toString());
        });
      } catch (e) {
        if (failure != null) failure(e.toString());
      }
    });
  }

  static void multipart(Map<String, String> parameter, String path,
      {bool isTokenApi = false,
      Map<String, File>? imgObj,
      ResSuccess? withSuccess,
      ResFailure? failure}) {
    Future(() {
      try {
        var uri = Uri.parse(path);
        var request = http.MultipartRequest('POST', uri);
        request.fields.addAll(parameter);

        if (isTokenApi) {
          request.headers
              .addAll({"access_token": userObj["auth_token"] as String? ?? ""});
        }

        if (kDebugMode) {
          print('Service Call: $path');
          print('Service para: ${parameter.toString()}');
          print('Service header: ${request.headers.toString()}');
        }

        if (imgObj != null) {
          imgObj.forEach((key, value) async {
            var multipartFile = http.MultipartFile(
                key, value.readAsBytes().asStream(), value.lengthSync(),
                filename: pth.basename(value.path));
            request.files.add(multipartFile);
          });
        }

        request.send().then((response) async {
          var value = await response.stream.transform(utf8.decoder).join();

          try {
            if (kDebugMode) {
              print(value);
            }

            var jsonObj = json.decode(value) as Map<String, dynamic>? ?? {};
            if (withSuccess != null) {
              withSuccess(jsonObj);
            }
          } catch (e) {
            if (failure != null) failure(e.toString());
          }
        }).catchError((err) {
          if (failure != null) failure(err.toString());
        });
      } on SocketException catch (e) {
        if (failure != null) failure(e.toString());
      } catch (e) {
        if (failure != null) failure(e.toString());
      }
    });
  }

  static void getStaticDateApi() {
    post({"last_call_time":""}, SVKey.svStaticData, withSuccess: (responseObj) async {
      try {
        if (responseObj[KKey.status] == "1") {
          var payload = responseObj[KKey.payload] as Map? ?? {};

          var db = await DBHelper.shared().db;

          var batch = db?.batch();

          for (var zObj in (payload["zone_list"] as List? ?? [])) {
            batch?.insert(DBHelper.tbZoneList, ZoneListModel.map(zObj).toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }

          for (var sObj in (payload["service_detail"] as List? ?? [])) {
            batch?.insert(
                DBHelper.tbServiceDetail, ServiceDetailModel.map(sObj).toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }

          for (var pObj in (payload["price_detail"] as List? ?? [])) {
            batch?.insert(
                DBHelper.tbPriceDetail, PriceDetailModel.map(pObj).toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }

          for (var dObj in (payload["document"] as List? ?? [])) {
            batch?.insert(
                DBHelper.tbDocument, DocumentModel.map(dObj).toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }

           for (var dObj in (payload["zone_document"] as List? ?? [])) {
            batch?.insert(DBHelper.tbZoneDocument, ZoneDocumentModel.map(dObj).toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } 

         var bResult =  batch?.commit();

         print(bResult);

          debugPrint("Static Save Successfully");

        } else {
          debugPrint(responseObj.toString());
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }, failure: (err) async {
      debugPrint(err.toString());
    });
  }
}
