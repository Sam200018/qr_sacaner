import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  nuevoScan(String valor) async {
    final nuevoScan = new ScanModel(value: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    //asingar el id de la base de datos al modelo
    nuevoScan.id = id;

    if (this.tipoSeleccionado == nuevoScan.type) {
      this.scans.add(nuevoScan);
      notifyListeners();
    }
  }

  cargarScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [
      ...scans
    ]; //rellena nuevamente this.scans con lo que nos regresa la base de datos
    notifyListeners();
  }

  loadScansByType(String type) async {
    final scans = await DBProvider.db.getScansByType(type);
    this.scans = [...scans];
    this.tipoSeleccionado = type; //para que permanezca en esa sección
    notifyListeners();
  }

  deleteScans() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  deleteById(int id) async {
    await DBProvider.db.deleteScan(id);
  }
}
