//import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlfliteHelper {
  static late Database database;
  static Future initDB() async {
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
    }

    database = await openDatabase("cart.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE ${AppConfig.tableName} (${AppConfig.primaryKey} INTEGER PRIMARY KEY, ${AppConfig.itemTitle} TEXT, ${AppConfig.itemPrice} INTEGER, ${AppConfig.productId} INTEGER, ${AppConfig.itemQty} INTEGER)');
    });
  }

// fetching all cart elements

  static Future<List<Map>> getAllData() async {
    List<Map> items =
        await database.rawQuery("SELECT * FROM ${AppConfig.tableName}");
    return items;
  }

  // inserting elements

  static Future<void> addToCart(
      {required String? title,
      required double? price,
      required int? productId,
      int qty = 1}) async {
    await database.rawInsert(
        'INSERT INTO ${AppConfig.tableName}(${AppConfig.itemTitle}, ${AppConfig.itemPrice}, ${AppConfig.productId}, ${AppConfig.itemQty}) VALUES(?, ?, ?, ?)',
        [title, price, productId, qty]);
  }

  // update

  static Future<void> updateData({required int qty, required int id}) async {
    await database.rawUpdate(
        'UPDATE ${AppConfig.tableName} SET ${AppConfig.itemQty} = ? WHERE id = ?',
        [qty, id]);
  }

// delete
  static Future<void> deleteData({required int id}) async {
    await database.rawDelete(
        'DELETE FROM ${AppConfig.tableName} WHERE ${AppConfig.primaryKey} = ?',
        [id]);
  }

  //delete all

  static Future<int> deleteAll() async =>
      await database.delete(AppConfig.tableName);
}
