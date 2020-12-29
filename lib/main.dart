import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:background_locator_example/MLocation.dart';
import 'package:background_locator_example/ProviderPrefs.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:developer' as dev;
import 'file_manager.dart';
import 'location_callback_handler.dart';
import 'location_service_repository.dart';
import 'dart:developer' as dev;
import 'Utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort port = ReceivePort();
  bool hasCrossedLimit;
  String logStr = '';
  bool isRunning;
  LocationDto lastLocation;
  DateTime lastTimeLocation;
  //In km / h
  double speed;
  @override
  void initState() {
    super.initState();
    speed = 0;
    hasCrossedLimit = false;
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateUI(LocationDto data) async {
    final log = await FileManager.readLogFile();
    await _updateNotificationText(data);
    dev.log("updating ui");
    //Read the two locations
    //In m / s ?
    if (data != null) speed = data.speed;
    ProviderPrefs.getLocations().then((List<MLocation> locations) {
      bool hasCrossed = hasCrossedLimit;
      // double tempSpeed = speed;
      // if (locations.length == 2) {
      //   double distance = Utils.calculateDistance(locations[0].getLat,
      //       locations[1].getLat, locations[0].getLon, locations[1].getLon);

      //   tempSpeed = Utils.calculateSpeed(
      //       distance,
      //       DateTime.fromMillisecondsSinceEpoch(
      //           int.parse(locations[0].getTime)),
      //       DateTime.fromMillisecondsSinceEpoch(
      //           int.parse(locations[1].getTime)));

      //   hasCrossed = Utils.speedLimitCrossed(
      //       20,
      //       distance,
      //       DateTime.fromMillisecondsSinceEpoch(
      //           int.parse(locations[0].getTime)),
      //       DateTime.fromMillisecondsSinceEpoch(
      //           int.parse(locations[1].getTime)));
      // } else {
      //   print("THERE ARE NOT TWO LOCATIONS");
      // }
      setState(() {
        if (data != null) {
          lastLocation = data;
          lastTimeLocation = DateTime.now();
        }
        if (hasCrossed != hasCrossedLimit) {
          hasCrossedLimit = hasCrossed;
        }
        // if (tempSpeed != speed) {
        //   speed = tempSpeed;
        // }
        logStr = log;
      });
    });
    //Calcualte Speed
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    final start = SizedBox(
      width: double.maxFinite,
      child: RaisedButton(
        child: Text('Start'),
        onPressed: () {
          _onStart();
        },
      ),
    );
    final stop = SizedBox(
      width: double.maxFinite,
      child: RaisedButton(
        child: Text('Stop'),
        onPressed: () {
          onStop();
        },
      ),
    );
    final clear = SizedBox(
      width: double.maxFinite,
      child: RaisedButton(
        child: Text('Clear Log'),
        onPressed: () {
          FileManager.clearLogFile();
          setState(() {
            logStr = '';
          });
        },
      ),
    );
    String msgStatus = "-";
    if (isRunning != null) {
      if (isRunning) {
        msgStatus = 'Is running';
      } else {
        msgStatus = 'Is not running';
      }
    }
    final status = Text("Status: $msgStatus");

    String lastRunTxt = "-";
    if (isRunning != null) {
      if (isRunning) {
        if (lastTimeLocation == null || lastLocation == null) {
          lastRunTxt = "?";
        } else {
          lastRunTxt =
              LocationServiceRepository.formatDateLog(lastTimeLocation) +
                  "-" +
                  LocationServiceRepository.formatLog(lastLocation);
        }
      }
    }
    final lastRun = Text(
      "Last run: $lastRunTxt",
    );

    final log = Text(
      logStr,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter background Locator'),
        ),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 30,
                    width: double.infinity,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text("Speed: ${speed.round()} m / s",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                Container(
                    height: 30,
                    width: double.infinity,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                        "Speed: ${Utils.calculateKMH(speed).round()} km / h",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                start,
                stop,
                clear,
                status,
                lastRun,
                log
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onStop() async {
    BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();

    setState(() {
      isRunning = _isRunning;
//      lastTimeLocation = null;
//      lastLocation = null;
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastTimeLocation = null;
        lastLocation = null;
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  void _startLocator() {
    Map<String, dynamic> data = {'countInit': 1};
    BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
/*
        Comment initDataCallback, so service not set init variable,
        variable stay with value of last run after unRegisterLocationUpdate
 */
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIcon: '',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }
}
