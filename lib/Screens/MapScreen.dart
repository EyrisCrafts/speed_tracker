import 'package:background_locator_example/Models/CarSpeed.dart';
import 'package:background_locator_example/Providers/ProviderFiles.dart';
import 'package:background_locator_example/Utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer';

class MapScreen extends StatefulWidget {
  final String fileName;

  const MapScreen({Key key, @required this.fileName}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Future<List<CarSpeed>> futureLocations;

  Set<Marker> markers;
  @override
  void initState() {
    super.initState();
    log("Reading file ${widget.fileName}");
    futureLocations = ProviderFiles.readLogFile(widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: FutureBuilder<List<CarSpeed>>(
          future: futureLocations,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length != 0) {
              return GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                markers: snapshot.data
                    .toSet()
                    .map((e) => Marker(
                        markerId: MarkerId(Utils.generateRandomString(30)),
                        position: LatLng(e.lat, e.lon),
                        infoWindow: InfoWindow(title: e.speed.toString())))
                    .toSet(),
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                    zoom: 14,
                    target: LatLng(snapshot.data[0].lat, snapshot.data[0].lon)),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
