import 'dart:io';
import 'package:dbonspot/model/Item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';

class Databasehelper{
  static Databasehelper _instance=Databasehelper.internal();
  factory Databasehelper()=>_instance;
  Databasehelper.internal();
  static Database _db;
  final tableName='nodotable';
  final columnId="id";
  final columnTitle="title";
  final columnContent="content";
  final columnDate="date";

 Future<Database> get db async{
  if(_db != null){
    return _db;
  }else{
    _db=await _initDb();
    return _db;
  }
}
_initDb() async{
  Directory directory=await getApplicationDocumentsDirectory();
  String path=join(directory.path,'noto.db');
  var myDb=await openDatabase(path,version:1, onCreate:_onCreateDb);
  return myDb;
}

 void _onCreateDb(Database db,int version)async{
   await db.execute("CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,$columnTitle TEXT,$columnContent TEXT,$columnDate TEXT)");
   print('Database table Created Successfully');
}

  Future<int> saveItem(Item item)async{
    var dbClient=await db;
    int result=await dbClient.insert("$tableName",item.toMap());
    return result;
  }

  Future<int> deleteItem(int id)async{
    var dbClient=await db;
    int result=await dbClient.delete("$tableName",where:"$columnId=?" ,whereArgs: [id] );
    return result;
  }

  Future<int> updateItem(Item item)async{
    var dbClient=await db;
    int result=await dbClient.update("$tableName",item.toMap(),where: "$columnId =?",whereArgs: [item.id]);
    return result;
  }

  Future<int> getCount() async{
    var dbClient=await db;
    var result=await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName");
    int count=Sqflite.firstIntValue(result);
    return count;
  }

  Future<Item> getItem(int id)async{
    var dbClient=await db;
    var result=await dbClient.rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");
    if(result.length==0){
      return null;
    }else{
      return new Item.fromMap(result.first);
    }
  }

  Future<List> getAllItems()async{
    var dbClient=await db;
    var result=await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnTitle ASC");
    return result.toList();
  }

  Future close()async{
    var dbClient=await db;
    return dbClient.close();
  }

}