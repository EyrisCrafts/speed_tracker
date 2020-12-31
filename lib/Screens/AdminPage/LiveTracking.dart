import 'dart:async';

import 'package:background_locator_example/Providers/ProviderFirebase.dart';
import 'package:flutter/material.dart';

import 'package:background_locator_example/Models/CarSpeed.dart';
import 'package:background_locator_example/Providers/ProviderFiles.dart';
import 'package:background_locator_example/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer';

class LiveTracking extends StatefulWidget {
  final String deviceID;

  const LiveTracking({Key key, @required this.deviceID}) : super(key: key);
  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  Stream<List<CarSpeed>> streamLocations;

  Set<Marker> markers;
  StreamSubscription subscription;
  List<CarSpeed> list;
  @override
  void initState() {
    super.initState();
    list = List();
    markers = Set();
    log("Reading file ${widget.deviceID}");
    subscription =
        ProviderFirebase.listenToDevice(widget.deviceID).listen((event) {
      event.docs.map((e) => e.get('list')).toList().forEach((element) {
        log("Adding doc");
        List<dynamic> elem = element;
        elem.forEach((element2) {
          log("Adding Adding marker");
          Map<String, dynamic> map = element2;
          markers.add(Marker(
              markerId: MarkerId(Utils.generateRandomString(20)),
              position: LatLng(map['lat'], map['lon']),
              infoWindow: InfoWindow(title: 'Speed: ${map['speed']}')));
        });
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await subscription.cancel();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Map"),
          ),
          body: GoogleMap(
            myLocationEnabled: true,
            mapType: MapType.normal,
            markers: markers,
            myLocationButtonEnabled: true,
            initialCameraPosition:
                CameraPosition(zoom: 5, target: LatLng(30.3753, 69.3451)),
          )),
    );
  }
}
