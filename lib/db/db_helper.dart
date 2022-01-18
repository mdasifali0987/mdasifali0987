import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Dbconstant {
  static const String TABLE_NAME = 'items';
  static const String COLOMN_ID = 'id';
  static const String COLOMN_TITLE = 'title';
  static const String COLOMN_DESCRIPTION = 'description';
  static const String COLOMN_DATE = 'date';
  static const String COLOMN_CREATE_AT = 'createdAt';
}

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE ${Dbconstant.TABLE_NAME}(
        ${Dbconstant.COLOMN_ID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${Dbconstant.COLOMN_TITLE}  TEXT,
        ${Dbconstant.COLOMN_DESCRIPTION}  TEXT,
        ${Dbconstant.COLOMN_DATE}  TEXT,
        ${Dbconstant.COLOMN_CREATE_AT}  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'asif.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  /// Create new item (todolist)
  static Future<int> createItem(
      String title, String? descrption, String date) async {
    final db = await SQLHelper.db();

    final data = {
      Dbconstant.COLOMN_TITLE: title,
      Dbconstant.COLOMN_DESCRIPTION: descrption,
      Dbconstant.COLOMN_DATE: date
    };
    final id = await db.insert(Dbconstant.TABLE_NAME, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  /// Read all items (todolist)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query(Dbconstant.TABLE_NAME, orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> sortbytitle(String title) async {
    final db = await SQLHelper.db();
    return db.query(Dbconstant.TABLE_NAME, orderBy: Dbconstant.COLOMN_TITLE);
  }

  static Future<List<Map<String, dynamic>>> sortbydate(String date) async {
    final db = await SQLHelper.db();
    return db.query(Dbconstant.TABLE_NAME, orderBy: Dbconstant.COLOMN_DATE);
  }

  /// Read a single item by id
  /// The app doesn't use this method but I put here in case you want to see it
  /* static Future<List<Map<String, dynamic>>> getItem(int id,String title,String date) async {
    final db = await SQLHelper.db();
    return db.query(Dbconstant.TABLE_NAME, where: "id = ?", whereArgs: [id,title,date], limit: 1);
  }
*/
  /// Update an todolist_items by id
  static Future<int> updateItem(
      int id, String title, String? descrption, String date) async {
    final db = await SQLHelper.db();

    final data = {
      Dbconstant.COLOMN_TITLE: title,
      Dbconstant.COLOMN_DESCRIPTION: descrption,
      Dbconstant.COLOMN_DATE: date,
      Dbconstant.COLOMN_CREATE_AT: DateTime.now().toString()
    };

    final result = await db
        .update(Dbconstant.TABLE_NAME, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// Delete an todolist_items by id
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(Dbconstant.TABLE_NAME, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
