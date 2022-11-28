import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database _db;

  Future<Database> get db async {
    if(_db!=null)
    {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mylocaldatabase.db');
    var db = await openDatabase(path,version: 4, onCreate: _onCreate , onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE Registration(Id INTEGER PRIMARY KEY,"
      'name TEXT,'
      'password TEXT,'
        'imageNameBase64 TEXT'
    ")");
  }

 void  _onUpgrade(Database db, int oldVersion, int newVersion)async{
    if(oldVersion<newVersion){
      await db.execute('DROP TABLE IF EXISTS Registration');

      await db.execute("CREATE TABLE Registration(Id INTEGER PRIMARY KEY,"
          'name,'
          'password,'
          'imageNameBase64'
          ")");
    }

  }
}