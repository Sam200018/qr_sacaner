import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_reader/pages/direciones_page.dart';

import 'package:qr_reader/pages/maps_page.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

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
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false)
                  .deleteScans();
            },
          ),
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
    //Usar el scanListProvider, y samos false para no redibujar la variable final sino lo que queremos que se redibuje son los page
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    switch (currentIndex) {
      case 0:
        scanListProvider.loadScansByType('geo');
        return MapPage();
        break;
      case 1:
        scanListProvider.loadScansByType('http');
        return DireccionesPage();
      default:
        return MapPage();
    }
  }
}
