import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Store {
  ///create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE imgCart(
    image TEXT,
    price INTEGER,
    createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);

    await database.execute("""
    CREATE TABLE imgHistory(
    image TEXT,
    price INTEGER,
    createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  /// open database
  static Future<sql.Database> db() async {
    return sql.openDatabase('image_data.db', version: 2,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  /// add image and quantity in imgCart table
  static Future addCart(String img, int price) async {
    var db = await Store.db();
    var data = {
      'image': img,
      'price': price,
    };
    var details = await db.insert('imgCart', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return details;
  }

  /// get data from imgCart table
  static Future<List<dynamic>> getItemsCart() async {
    var db = await Store.db();
    return db.query('imgCart',);
  }

  /// add image and quantity in imgHistory table
  static Future addHistory(String img, int price) async {
    var db = await Store.db();
    var data = {
      'image': img,
      'price': price,
    };
    var details = await db.insert('imgHistory', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return details;
  }

  /// get data from imgHistory table
  static Future<List<dynamic>> getItemsHistory() async {
    var db = await Store.db();
    return db.query('imgHistory',);
  }

  /// delete imgCart all items
  static Future<void> deleteimgCartTable() async {
    var db = await Store.db();
    await db.delete("imgCart");
  }

  /// delete imgHistory all items
  static Future<void> deleteimgHistoryTable() async {
    var db = await Store.db();
    await db.delete("imgHistory");
  }


  // totalprice
  static Future<int> getTotalPrice() async {
    var db = await Store.db();
    var result = await db.rawQuery("SELECT SUM(price) as sum FROM imgCart");
    return int.parse(result[0]['sum'].toString());
  }

}
