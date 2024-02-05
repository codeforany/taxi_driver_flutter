import 'package:taxi_driver/common/db_helper.dart';

class ZoneDocumentModel {
  String zoneDocId = "";
  String zoneId = "";
  String serviceId = "";
  String personalDoc = "";
  String carDoc = "";
  String requiredPersonalDoc = "";
  String requiredCarDoc = "";
  String status = "";
  String createdDate = "";
  String modifyDate = "";

  ZoneDocumentModel.map(dynamic obj) {
    zoneDocId = obj["zone_doc_id"].toString();
    zoneId = obj["zone_id"].toString();
    serviceId = obj["service_id"].toString();
    personalDoc = obj["personal_doc"].toString();
    carDoc = obj["car_doc"].toString();
    requiredPersonalDoc = obj["required_personal_doc"].toString();
    requiredCarDoc = obj["required_car_doc"].toString();
    status = obj["status"].toString();
    createdDate = obj["created_date"].toString();
    modifyDate = obj["modify_date"].toString();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> obj = {};
    obj["zone_doc_id"] = zoneDocId;
    obj["zone_id"] = zoneId;
    obj["service_id"] = serviceId;
    obj["personal_doc"] = personalDoc;
    obj["car_doc"] = carDoc;
    obj["required_personal_doc"] = requiredPersonalDoc;
    obj["required_car_doc"] = requiredCarDoc;
    obj["status"] = status;
    obj["created_date"] = createdDate;
    obj["modify_date"] = modifyDate;
    return obj;
  }

  static Future<List> getList() async {
    var db = await DBHelper.shared().db;
    if (db != null) {
      List<Map> list = await db.rawQuery(
          'SELECT * FROM `${DBHelper.tbZoneDocument}` WHERE `${DBHelper.status}` = 1',
          []);
      return list;
    } else {
      return [];
    }
  }
}
