import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:background_geolocation_sample/location.dart';
import 'package:background_geolocation_sample/location_dao.dart';
import 'package:floor/floor.dart';

part 'app_db.g.dart';

@Database(version: 1, entities: [Location])
abstract class AppDB extends FloorDatabase {
  static AppDB? dbInstance;

  static Future<AppDB> initDB() async {
    dbInstance ??= await $FloorAppDB.databaseBuilder('app_database').build();
    return dbInstance!;
  }

  LocationDao get locationDao;
}
