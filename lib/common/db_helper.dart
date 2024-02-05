import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper singleton = DBHelper.internal();
  factory DBHelper() => singleton;
  static Database? _db;
  DBHelper.internal();
  static DBHelper shared() => singleton;

  static const String tbZoneList = 'zone_list';
  static const String tbServiceDetail = 'service_detail';
  static const String tbPriceDetail = 'price_detail';
  static const String tbDocument = 'document';
  static const String tbZoneDocument = 'zone_detail';

  static const String zoneId = "zone_id";
  static const String zoneName = "zone_name";
  static const String zoneJson = "zone_json";
  static const String city = "city";
  static const String tax = "tax";
  static const String status = "status";
  static const String createdDate = "created_date";
  static const String modifyDate = "modify_date";

  static const String serviceId = "service_id";
  static const String serviceName = "service_name";
  static const String seat = "seat";
  static const String color = "color";
  static const String icon = "icon";
  static const String topIcon = "top_icon";
  static const String gender = "gender";
  static const String description = "description";

  static const String priceId = "price_id";
  static const String baseCharge = "base_charge";
  static const String perKmCharge = "per_km_charge";
  static const String perMinCharge = "per_min_charge";
  static const String bookingCharge = "booking_charge";
  static const String miniFair = "mini_fair";
  static const String miniKm = "mini_km";
  static const String cancelCharge = "cancel_charge";

  static const String docId = "doc_id";
  static const String name = "name";
  static const String type = "type";

  static const String zoneDocId = "zone_doc_id";
  static const String personalDoc = "personal_doc";
  static const String carDoc = "car_doc";
  static const String requiredPersonalDoc = "required_personal_doc";
  static const String requiredCarDoc = "required_car_doc";

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();

    return _db;
  }

  initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'data.db');
    var isDBExists = await databaseExists(path);
    if (kDebugMode) {
      print(isDBExists);
      print(path);
    }
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  void onCreate(Database db, int newVersion) async {
   

    await db.execute(
        'CREATE TABLE $tbZoneList ($zoneId TEXT PRIMARY KEY, $zoneName TEXT, $zoneJson TEXT, $city TEXT, $tax TEXT, $status Text, $createdDate Text, $modifyDate Text)');

    await db.execute(
        'CREATE TABLE $tbServiceDetail ($serviceId TEXT PRIMARY KEY, $serviceName TEXT, $seat TEXT, $color TEXT, $icon TEXT, $topIcon TEXT, $gender TEXT, $description TEXT, $status TEXT, $createdDate TEXT, $modifyDate TEXT)');

    await db.execute(
        'CREATE TABLE $tbPriceDetail ($priceId TEXT PRIMARY KEY, $zoneId TEXT, $serviceId TEXT, $baseCharge TEXT, $perKmCharge TEXT, $perMinCharge TEXT,$bookingCharge TEXT,$miniFair TEXT,$miniKm TEXT,$cancelCharge TEXT, $tax TEXT, $status TEXT, $createdDate TEXT, $modifyDate TEXT)');

    await db.execute(
        'CREATE TABLE $tbDocument ($docId TEXT PRIMARY KEY, $name TEXT, $type TEXT,$status TEXT, $createdDate TEXT, $modifyDate TEXT)');

    await db.execute(
        'CREATE TABLE $tbZoneDocument ($zoneDocId TEXT PRIMARY KEY, $zoneId TEXT, $serviceId TEXT, $personalDoc TEXT, $carDoc TEXT, $requiredPersonalDoc TEXT, $requiredCarDoc TEXT,  $status TEXT, $createdDate TEXT, $modifyDate TEXT)');

     debugPrint("db create table");
  }

  static Future dbClearAll() async {
    if(_db == null) {
      return;
    }

    await _db?.execute('DELETE FROM $tbZoneList');
    await _db?.execute('DELETE FROM $tbServiceDetail');
    await _db?.execute('DELETE FROM $tbPriceDetail');
    await _db?.execute('DELETE FROM $tbDocument');
    await _db?.execute('DELETE FROM $tbZoneDocument');
  }

  static Future dbClearTable(String table) async {
     if (_db == null) {
      return;
    }

    await _db?.execute('DELETE FROM $table');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient?.close();
  }
}
