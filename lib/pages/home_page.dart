import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/models/scan_model.dart';

import 'package:qr_reader/pages/direciones_page.dart';
import 'package:qr_reader/pages/map_page.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(child: Text('Historial')),
        actions: [
          Icon(Icons.delete_forever),
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButtom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //obtener el selectedManuOpt que ya exxite en nuestro árbol de widgtes
    final uiProvider = Provider.of<UiProvider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;
    //TODO: temporal leer la base de datos
    final tempScan = new ScanModel(value: 'http://google.com');
    DBProvider.db.nuevoScan(tempScan);

    switch (currentIndex) {
      case 0:
        return MapsPage();
        break;
      case 1:
        return DireccionesPage();
      default:
        return MapsPage();
    }
  }
}
