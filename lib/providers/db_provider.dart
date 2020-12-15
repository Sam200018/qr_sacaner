import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  //creando un singlenton
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get databases async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  //Este método retorna una base de datos
  Future<Database> initDB() async {
    //path de donde almacenaremos la base de datos para eso usamos Directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //creamos la base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Scans (id INTEGER PRIMARY KEY, type TEXT, value TEXT)');
    });

    //siempre que haya un cambio estructural en la base de datos hay que iterar la versión porque cuando se vuelve a llamar la db y es la misma versión no genera cambios y por ende no crea unas nuevas tablas
  }

  //Inserción
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final type = nuevoScan.type;
    final value = nuevoScan.value;

    //verificar
    final db = await databases;
    final res = await db
        .rawInsert('INSERT INTO Scans(id,type,value) VALUES($id,$type,$value)');

    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await databases;
    final res = await db.insert('Scans', nuevoScan.toJson());
    //res es el id del último registro insertado
    return res;
  }
}
