import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String _noDoTable = "nodoTable";
  final String _idColumn = "id";
  final String _itemNameColumn = "itemName";
  final String _dateColumn = "date";

  static Database _db;

  Future<Database> get getDb async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory doc = await getApplicationDocumentsDirectory();
    String path = join(doc.path, "nodo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _create);
    return ourDb;
  }

  void _create(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_noDoTable($_idColumn INTEGER PRIMARY KEY,$_itemNameColumn TEXT,$_dateColumn TEXT)");
  }

  // insert
  Future<int> insertItem(Item item) async {
    var myDb = await getDb;
    int res = await myDb.insert("$_noDoTable", item.toMap());
    return res;
  }

  // get all users
  Future<List> getAllItems() async {
    var mydb = await getDb;
    var res = await mydb.rawQuery("SELECT * FROM $_noDoTable ORDER BY $_itemNameColumn ASC");
    return res.toList();
  }

  Future<int> getCount() async {
    var mydb = await getDb;
    return Sqflite.firstIntValue(
        await mydb.rawQuery("SELECT COUNT(*) FROM$_noDoTable"));

  }

Future<Item> getItem(int id) async {
    var mydb = await getDb;

    var res= await mydb.rawQuery("SELECT * FROM$_noDoTable WHERE $_idColumn = $id");
    if(res.length == 0) return null;
    return new Item.map(res.first);
  }

  Future<int> deleteItem(int id) async {
    var mydb = await getDb;
    return await mydb.delete("$_noDoTable",where: "$_idColumn = ?",whereArgs: [id]);

  }
  Future<int> updateItem(Item item) async {
    var mydb = await getDb;
    return await mydb.update("$_noDoTable", item.toMap(),where: "$_idColumn = ?" , whereArgs: [item.id]);


  }
  Future close() async{
    var d = await getDb;
    return d.close();
  }
  
}
