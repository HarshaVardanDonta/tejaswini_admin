import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Loc extends StatefulWidget {
  double lat;
  double long;

  Loc({Key? key, required this.lat, required this.long}) : super(key: key);

  @override
  State<Loc> createState() => _LocState();
}

class _LocState extends State<Loc> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    LatLng source = LatLng(widget.lat, widget.long);
    CameraPosition mpS =
        CameraPosition(target: LatLng(widget.lat, widget.long),zoom: 20);
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: mpS,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: source,
          ),
        },
      ),
    );
  }
}
