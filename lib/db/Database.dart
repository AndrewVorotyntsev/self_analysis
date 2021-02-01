import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:self_analysis/models/MessageModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:self_analysis/db/MyConstants.dart';

//Создадим конструтор
class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  // Создаем объект базы данных
  static Database _database;
  // Ленивая инициализация объекта базы данных : созадем если еще не создан
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  //Если база данных еще не создана создадим её
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "messagesDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(MyConstants.TABLE_STRUCTURE);
        });
  }

  //Добавялем новое сообщение в базу
  newMessage(Message newMessage) async {
    final db = await database;
    //Получаем наибольшее значение id в таблице
    var table = await db.rawQuery("SELECT MAX(id)+1 as ${MyConstants.ID}"
        " FROM ${MyConstants.TABLE_NAME}");

    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Messages (id,content)"
            " VALUES (?,?)",
        [id, newMessage.content]);
    return raw;
  }


  //Получаем всe сообщения из таблицы и сохраняем в список
  Future<List<Message>> getAllMessages() async {
    final db = await database;
    var res = await db.query("Messages");
    List<Message> list =
    res.isNotEmpty ? res.map((c) => Message.fromMap(c)).toList() : [];
    return list;
  }

}
