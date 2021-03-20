import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_sql_user/sql_modal/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlModal {
  static final String sqlName = "user.sqlite";
  static final String sqlPathCopy = "assets/sqflite/user.sqlite";
  static Future<Database> accessSql() async {
    String sqlPathApp = join(await getDatabasesPath(), sqlName);
    if (await databaseExists(sqlPathApp)) {
      print("kopyalama gereği yok");
    } else {
      ByteData data = await rootBundle.load(sqlPathCopy);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(sqlPathApp).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(sqlPathApp);
  }
}

class SqlAccess {
  Future<List<Users>> allUser() async {
    var database = await SqlModal.accessSql();

    List<Map<String, dynamic>> maps =
        await database.rawQuery("SELECT * FROM user");

    return List.generate(maps.length, (index) {
      var user = maps[index];
      return Users(
        user["user_id"],
        user["user_name"],
      );
    });
  }

  Future<void> addUser(String name) async {
    var database = await SqlModal.accessSql();
    var maps = Map<String, dynamic>();
    maps["user_name"] = name;
    await database.insert("user", maps);
  }
}
