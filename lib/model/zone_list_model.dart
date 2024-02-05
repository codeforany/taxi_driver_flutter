import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:taxi_driver/common/db_helper.dart';

class ZoneListModel {
  String zoneId = "";
  String zoneName = "";
  String zoneJson = "";
  String city = "";
  String tax = "";
  String status = "";
  String createdDate = "";
  String modifyDate = "";
  List<LatLng> zonePathArr = [];

  ZoneListModel.map(dynamic obj) {
    zoneId = obj["zone_id"].toString();
    zoneName = obj["zone_name"].toString();
    zoneJson = obj["zone_json"].toString();
    city = obj["city"].toString();
    tax = obj["tax"].toString();
    status = obj["status"].toString();
    createdDate = obj["created_date"].toString();
    modifyDate = obj["modify_date"].toString();

    try {
      zonePathArr = (json.decode(zoneJson) as List? ?? [])
          .map((pObj) => LatLng(
              pObj["lat"] as double? ?? 0.0, pObj["lng"] as double? ?? 0.0))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> obj = {};
    obj["zone_id"] = zoneId;
    obj["zone_name"] = zoneName;
    obj["zone_json"] = zoneJson;
    obj["city"] = city;
    obj["tax"] = tax;
    obj["status"] = status;
    obj["created_date"] = createdDate;
    obj["modify_date"] = modifyDate;

    return obj;
  }

  static Future<List> getList() async {
    var db = await DBHelper.shared().db;
    if (db != null) {
      List<Map> list = await db.rawQuery(
          'SELECT * FROM `${DBHelper.tbZoneList}` WHERE `${DBHelper.status}` = 1',
          []);
      return list;
    } else {
      return [];
    }
  }

  static Future<List<ZoneListModel>> getActiveList() async {
    var db = await DBHelper.shared().db;

    if (db != null) {
      List<Map> list = await db.rawQuery(
          "SELECT `zl`.* FROM `${DBHelper.tbZoneList}` AS `zl` INNER JOIN `${DBHelper.tbPriceDetail}` AS `pd` ON `pd`.`${DBHelper.zoneId}` = `zl`.`${DBHelper.zoneId}` AND `pd`.`${DBHelper.status}` = '1' WHERE `zl`.`${DBHelper.status}` = '1' GROUP BY `zl`.`${DBHelper.zoneId}`  ",
          []);

      return list.map((zObj) => ZoneListModel.map(zObj)).toList();
    } else {
      return [];
    }
  }
}
