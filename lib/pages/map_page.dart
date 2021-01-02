import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    final CameraPosition initialPoint = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50,
    );

    //Marcadores
    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
      markerId: MarkerId('geo-location'),
      position: scan.getLatLng(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(initialPoint),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        mapToolbarEnabled: true,
        markers: markers,
        mapType: mapType,
        initialCameraPosition: initialPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.layers),
        onPressed: () {
          if (mapType == MapType.normal) {
            mapType = MapType.satellite;
          } else {
            mapType = MapType.normal;
          }
          setState(() {});
        },
      ),
    );
  }
}
