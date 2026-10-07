import 'dart:async';
import 'dart:io';

import 'package:moviles/database/notes_dao.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesDB {
  static final nameDB = 'NOTESDB';
  static final versionDB = 1; //es la malnera en la que la aplicacion detecta la version de la base de datos,
  // si se cambia el numero de version, se ejecutara el metodo onUpgrade
  static Database? _database;
  static Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDB();
  }

  static Future<Database> _initDB() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: createTables);
  }

  static Future<void> createTables(Database db, int version) async {
    String query = '''
      CREATE TABLE tblNotes(
        idNote INTEGER PRIMARY KEY,
        title VARCHAR(35),
        content TEXT,
        dateNote CHAR(10)
      )
      ''';
    await db.execute(query);
  }

  Future<int> INSERT(Map<String, dynamic> note) async {
    var conexion = await database;
    return conexion!.insert("tblNotes", note);
  }

  Future<int> UPDATE(Map<String, dynamic> note) async {
    var conexion = await database;
    return conexion!.update(
      "tblNotes",
      note,
      where: "idNote = ?",
      whereArgs: [note['idNote']],
    );
  }

  Future<int> DELETE(int idNote) async {
    var conexion = await database;
    return conexion!.delete(
      "tblNotes",
      where: "idNote = ?",
      whereArgs: [idNote],
    );
  }

  Future<List<NotesDao>> SELECT() async {
    var conexion = await database;
    final res = await conexion!.query("tblNotes");
    return res.map((note) => NotesDao.fromMap(note)).toList();
  }
}
