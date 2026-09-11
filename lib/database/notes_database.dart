import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesDB{

  static final nameDB = 'NOTESDB';
  static final versionDB = 1; //es la malnera en la que la aplicacion detecta la version de la base de datos,
  // si se cambia el numero de version, se ejecutara el metodo onUpgrade
  static Database? _database;
  static Future<Database?> get database async{
    if(_database != null) return _database;
    return _database = await _initDB();
  }
  static Future<Database> _initDB() async{
    Directory folder = await getApplicationDocumentsDirectory();
    final path = '${folder.path}/$nameDB.db';
    return await openDatabase(path, version: versionDB);
  }
}
