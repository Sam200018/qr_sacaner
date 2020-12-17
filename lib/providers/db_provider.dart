import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

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

    //Inserta en la base de datos
    final db = await databases;
    final res = await db
        .rawInsert('INSERT INTO Scans(id,type,value) VALUES($id,$type,$value)');

    return res;
  }

  //inserta en la base de datos pero de otra manera
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await databases;
    final res = await db.insert('Scans', nuevoScan.toJson());
    //res es el id del último registro insertado
    return res;
  }

  //obtenemos el scan por si id
  Future<ScanModel> getScanById(int id) async {
    final db = await databases;
    final res = await db.query(
      'Scans',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //Se obtiene todos los registros de la base de datos
  Future<List<ScanModel>> getAllScans() async {
    final db = await databases;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  //Se obtienen todos los registro de la base de datos que sean del mismo tipo
  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await databases;
    final res = await db.query('Scans', where: 'type= $type');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  //update
  Future<int> updateScan(ScanModel newScan) async {
    final db = await databases;
    final res = await db.update('Scans', newScan.toJson(),
        where: 'id= ?', whereArgs: [newScan.id]);

    return res;
  }

  //delete everything
  Future<int> deleteAllScans() async {
    final db = await databases;
    final res = await db.delete('Scans');

    return res;
  }

  //delete by id
  Future<int> deleteScan(int id) async {
    final db = await databases;
    final res = await db.delete('Scans', where: 'id =?', whereArgs: [id]);

    return res;
  }
}
