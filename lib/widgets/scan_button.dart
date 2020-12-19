import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class ScanButtom extends StatelessWidget {
  const ScanButtom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {
        // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        //     '#3D8BEF', 'Cancel', false, ScanMode.QR);
        final barcodeScanRes = 'http://google.com';
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        //buscca en el arbol de widgets la instancia de ScanListProvider

        scanListProvider.nuevoScan(barcodeScanRes);
        scanListProvider.nuevoScan('geo:15.33.15.66');
      },
      child: Icon(Icons.filter_center_focus),
    );
  }
}
