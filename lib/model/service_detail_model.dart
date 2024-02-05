import 'package:taxi_driver/common/db_helper.dart';

class ServiceDetailModel {
  String serviceId = "";
  String serviceName = "";
  String seat = "";
  String color = "";
  String icon = "";
  String topIcon = "";
  String gender = "";
  String description = "";
  String status = "";
  String createdDate = "";
  String modifyDate = "";

  ServiceDetailModel.map(dynamic obj) {
    serviceId = obj["service_id"].toString();
    serviceName = obj["service_name"].toString();
    seat = obj["seat"].toString();
    color = obj["color"].toString();
    icon = obj["icon"].toString();
    topIcon = obj["top_icon"].toString();
    gender = obj["gender"].toString();
    description = obj["description"].toString();
    status = obj["status"].toString();
    createdDate = obj["created_date"].toString();
    modifyDate = obj["modify_date"].toString();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> obj = {};
    obj["service_id"] = serviceId;
    obj["service_name"] = serviceName;
    obj["seat"] = seat;
    obj["color"] = color;
    obj["icon"] = icon;
    obj["top_icon"] = topIcon;
    obj["gender"] = gender;
    obj["description"] = description;
    obj["status"] = status;
    obj["created_date"] = createdDate;
    obj["modify_date"] = modifyDate;

    return obj;
  }

  static Future<List> getList() async {
    var db = await DBHelper.shared().db;
    if (db != null) {
      List<Map> list = await db.rawQuery(
          'SELECT * FROM `${DBHelper.tbServiceDetail}` WHERE `${DBHelper.status}` = 1',
          []);
      return list;
    } else {
      return [];
    }
  }
}
