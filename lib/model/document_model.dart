import 'package:taxi_driver/common/db_helper.dart';

class DocumentModel {
  String docId = "";
  String name = "";
  String type = "";
  String status = "";
  String createdDate = "";
  String modifyDate = "";

  DocumentModel.map(dynamic obj) {
    docId = obj["doc_id"].toString();
    name = obj["name"].toString();
    type = obj["type"].toString();
    status = obj["status"].toString();
    createdDate = obj["created_date"].toString();
    modifyDate = obj["modify_date"].toString();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> obj = {};
    obj["doc_id"] = docId;
    obj["name"] = name;
    obj["type"] = type;
    obj["status"] = status;
    obj["created_date"] = createdDate;
    obj["modify_date"] = modifyDate;

    return obj;
  }

  static Future<List> getList() async {
    var db = await DBHelper.shared().db;
    if (db != null) {
      List<Map> list = await db.rawQuery(
          'SELECT * FROM `${DBHelper.tbDocument}` WHERE `${DBHelper.status}` = 1',
          []);
      return list;
    } else {
      return [];
    }
  }
}
