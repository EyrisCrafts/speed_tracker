import 'package:background_locator_example/Screens/AdminPage/AdminMain.dart';
import 'package:background_locator_example/Screens/LoginPage.dart';
import 'package:background_locator_example/Screens/TrackerScreen.dart';

import 'Providers/ProviderPreferences.dart';
import 'dart:async';

import 'package:background_locator_example/Models/CarSpeed.dart';
import 'Providers/ProviderFirebase.dart';
import 'dart:isolate';
import 'dart:ui';
import 'Screens/History.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:background_locator_example/Global.dart';
import 'package:background_locator_example/MLocation.dart';
import 'package:background_locator_example/ProviderPrefs.dart';
import 'package:background_locator_example/Providers/ProviderFiles.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:developer' as dev;
import 'file_manager.dart';
import 'location_callback_handler.dart';
import 'location_service_repository.dart';
import 'Utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  final Future startup = ProviderPreferences.init();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toll Checker',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //Only if logged in
        home: FutureBuilder(
            future: startup,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return buildPage();
              } else {
                return Container();
              }
            }));
  }

  buildPage() {
    if (FirebaseAuth.instance.currentUser == null) return LoginPage();
    if (Global.isAdmin) {
      //Load list
      return AdminMain();
    }
    return TrackerScreen();
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   ReceivePort port = ReceivePort();
//   bool hasCrossedLimit;
//   String logStr = '';
//   bool isRunning;
//   LocationDto lastLocation;
//   DateTime lastTimeLocation;
//   final player = AudioPlayer();
//   bool isLocating;
//   TextEditingController controllerSpeed;
//   double speedLimit;

//   initAudio() async {
//     try {
//       await player.setAsset('assets/alarm.mp3');
//     } on PlayerException catch (e) {
//       // iOS/macOS: maps to NSError.code
//       // Android: maps to ExoPlayerException.type
//       // Web: maps to MediaError.code
//       print("Error code: ${e.code}");
//       // iOS/macOS: maps to NSError.localizedDescription
//       // Android: maps to ExoPlaybackException.getMessage()
//       // Web: a generic message
//       print("Error message: ${e.message}");
//     } on PlayerInterruptedException catch (e) {
//       // This call was interrupted since another audio source was loaded or the
//       // player was stopped or disposed before this audio source could complete
//       // loading.
//       print("Connection aborted: ${e.message}");
//     } catch (e) {
//       // Fallback for all errors
//       print(e);
//     }
//     // await player.setLoopMode(LoopMode.one);
//   }

//   Timer firebaseTimer;
//   //In km / h
//   double speed;
//   @override
//   void initState() {
//     super.initState();
//     controllerSpeed = TextEditingController();
//     initAudio();
//     speed = 0;
//     speedLimit = 0;
//     ProviderFirebase.autologin();
//     hasCrossedLimit = false;
//     if (IsolateNameServer.lookupPortByName(
//             LocationServiceRepository.isolateName) !=
//         null) {
//       IsolateNameServer.removePortNameMapping(
//           LocationServiceRepository.isolateName);
//     }

//     IsolateNameServer.registerPortWithName(
//         port.sendPort, LocationServiceRepository.isolateName);

//     port.listen(
//       (dynamic data) async {
//         await updateUI(data);
//       },
//     );
//     initPlatformState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   playaudio() {
//     player.play();
//   }

//   Future<void> updateUI(LocationDto data) async {
//     final log = await FileManager.readLogFile();
//     await _updateNotificationText(data);
//     if (data != null) {
//       ProviderPreferences.countUp();
//       ProviderFiles.writeToLogFile(
//           CarSpeed(
//               lat: data.latitude,
//               lon: data.longitude,
//               time: DateTime.now().millisecondsSinceEpoch.toString(),
//               speed: data.speed),
//           Global.logName);
//       if (Utils.calculateKMH(data.speed) > speedLimit && !player.playing) {
//         player.play();
//       }
//       if (Utils.calculateKMH(data.speed) < speedLimit && player.playing) {
//         player.stop();
//       }
//     }
//     //Read the two locations
//     //In m / s ?
//     if (data != null) speed = data.speed;
//     ProviderPrefs.getLocations().then((List<MLocation> locations) {
//       bool hasCrossed = hasCrossedLimit;

//       // double tempSpeed = speed;
//       // if (locations.length == 2) {
//       //   double distance = Utils.calculateDistance(locations[0].getLat,
//       //       locations[1].getLat, locations[0].getLon, locations[1].getLon);

//       //   tempSpeed = Utils.calculateSpeed(
//       //       distance,
//       //       DateTime.fromMillisecondsSinceEpoch(
//       //           int.parse(locations[0].getTime)),
//       //       DateTime.fromMillisecondsSinceEpoch(
//       //           int.parse(locations[1].getTime)));

//       //   hasCrossed = Utils.speedLimitCrossed(
//       //       20,
//       //       distance,
//       //       DateTime.fromMillisecondsSinceEpoch(
//       //           int.parse(locations[0].getTime)),
//       //       DateTime.fromMillisecondsSinceEpoch(
//       //           int.parse(locations[1].getTime)));
//       // } else {
//       //   print("THERE ARE NOT TWO LOCATIONS");
//       // }
//       setState(() {
//         if (data != null) {
//           lastLocation = data;
//           lastTimeLocation = DateTime.now();
//         }
//         if (hasCrossed != hasCrossedLimit) {
//           hasCrossedLimit = hasCrossed;
//         }
//         // if (tempSpeed != speed) {
//         //   speed = tempSpeed;
//         // }
//         logStr = log;
//       });
//     });
//     //Calcualte Speed
//   }

//   Future<void> _updateNotificationText(LocationDto data) async {
//     if (data == null) {
//       return;
//     }

//     await BackgroundLocator.updateNotificationText(
//         title: "new location received",
//         msg: "${DateTime.now()}",
//         bigMsg: "${data.latitude}, ${data.longitude}");
//   }

//   Future<void> initPlatformState() async {
//     print('Initializing...');
//     await BackgroundLocator.initialize();
//     logStr = await FileManager.readLogFile();
//     print('Initialization done');
//     final _isRunning = await BackgroundLocator.isServiceRunning();
//     setState(() {
//       isRunning = _isRunning;
//     });
//     print('Running ${isRunning.toString()}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final clear = SizedBox(
//       width: double.maxFinite,
//       child: RaisedButton(
//         child: Text('Clear Log'),
//         onPressed: () {
//           // ProviderFiles.clearHistory();
//           // String id = FirebaseAuth.instance.currentUser.uid;
//           // dev.log("userid is $id");

//           // FileManager.clearLogFile();
//           // setState(() {
//           //   logStr = '';
//           // });
//         },
//       ),
//     );
//     String msgStatus = "-";
//     if (isRunning != null) {
//       if (isRunning) {
//         msgStatus = 'Is running';
//       } else {
//         msgStatus = 'Is not running';
//       }
//     }
//     final status = Text("Status: $msgStatus");

//     String lastRunTxt = "-";
//     if (isRunning != null) {
//       if (isRunning) {
//         if (lastTimeLocation == null || lastLocation == null) {
//           lastRunTxt = "?";
//         } else {
//           lastRunTxt =
//               LocationServiceRepository.formatDateLog(lastTimeLocation) +
//                   "-" +
//                   LocationServiceRepository.formatLog(lastLocation);
//         }
//       }
//     }
//     final lastRun = Text(
//       "Last run: $lastRunTxt",
//     );

//     final log = Text(
//       logStr,
//     );

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Tracker'),
//           actions: [
//             Builder(builder: (context) {
//               return IconButton(
//                 icon: Icon(Icons.history),
//                 onPressed: () {
//                   //Go to History
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => HistoryScreen()));
//                 },
//               );
//             })
//           ],
//         ),
//         body: Container(
//           width: double.maxFinite,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   width: double.infinity,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           child: TextFormField(
//                             keyboardType: TextInputType.number,
//                             controller: controllerSpeed,
//                             decoration:
//                                 InputDecoration(labelText: "Speed Limit"),
//                           ),
//                         ),
//                       ),
//                       RaisedButton(
//                         onPressed: () {
//                           // ProviderFiles.listFiles();
//                           if (controllerSpeed.text.isNotEmpty) {
//                             setState(() {
//                               speedLimit = double.parse(controllerSpeed.text);
//                             });
//                           }
//                           controllerSpeed.clear();
//                         },
//                         child: Text("Set"),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Speed Limit: ${speedLimit.toString()}"),
//                       Text("Speed: ${Utils.calculateKMH(speed).round()} km / h",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),

//                 // RaisedButton(onPressed: playaudio, child: Text("play song")),

//                 Container(
//                   width: 150,
//                   height: 150,
//                   child: RaisedButton(
//                     color: isRunning != null && isRunning
//                         ? Colors.red
//                         : Colors.green,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100)),
//                     onPressed: () {
//                       if (firebaseTimer != null && firebaseTimer.isActive)
//                         firebaseTimer.cancel();
//                       else {
//                         firebaseTimer =
//                             Timer.periodic(Duration(minutes: 1), (timer) async {
//                           dev.log("Adding to firebase");

//                           int counter = await ProviderPreferences.getCount();

//                           List<CarSpeed> list =
//                               await ProviderFiles.getDocumentSpeeds(
//                                   counter, Global.logName);
//                           //TODO Send to firebase
//                           ProviderPreferences.resetCount();
//                           dev.log("uploading to firebase");
//                           ProviderFirebase.uploadToFirebase(list, 'EDGP3');
//                         });
//                       }

//                       Global.logName = "data_" +
//                           DateTime.now().millisecondsSinceEpoch.toString();

//                       ProviderPreferences.resetCount();

//                       ProviderFiles.resetFileName().then((value) {
//                         if (isRunning) {
//                           //Stop
//                           onStop();
//                           if (player.playing) {
//                             player.stop();
//                           }
//                         } else {
//                           //Start
//                           _onStart();
//                         }
//                       });
//                     },
//                     child: Text(
//                         isRunning != null && isRunning ? "Stop" : "Start",
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ),

//                 clear,
//                 status,
//                 lastRun,
//                 log
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void onStop() async {
//     BackgroundLocator.unRegisterLocationUpdate();
//     final _isRunning = await BackgroundLocator.isServiceRunning();

//     setState(() {
//       isRunning = _isRunning;
// //      lastTimeLocation = null;
// //      lastLocation = null;
//     });
//   }

//   void _onStart() async {
//     if (await _checkLocationPermission()) {
//       _startLocator();
//       final _isRunning = await BackgroundLocator.isServiceRunning();

//       setState(() {
//         isRunning = _isRunning;
//         lastTimeLocation = null;
//         lastLocation = null;
//       });
//     } else {
//       // show error
//     }
//   }

//   Future<bool> _checkLocationPermission() async {
//     final access = await LocationPermissions().checkPermissionStatus();
//     switch (access) {
//       case PermissionStatus.unknown:
//       case PermissionStatus.denied:
//       case PermissionStatus.restricted:
//         final permission = await LocationPermissions().requestPermissions(
//           permissionLevel: LocationPermissionLevel.locationAlways,
//         );
//         if (permission == PermissionStatus.granted) {
//           return true;
//         } else {
//           return false;
//         }
//         break;
//       case PermissionStatus.granted:
//         return true;
//         break;
//       default:
//         return false;
//         break;
//     }
//   }

//   void _startLocator() {
//     Map<String, dynamic> data = {'countInit': 1};
//     BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
//         initCallback: LocationCallbackHandler.initCallback,
//         initDataCallback: data,
// /*
//         Comment initDataCallback, so service not set init variable,
//         variable stay with value of last run after unRegisterLocationUpdate
//  */
//         disposeCallback: LocationCallbackHandler.disposeCallback,
//         iosSettings: IOSSettings(
//             accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
//         autoStop: false,
//         androidSettings: AndroidSettings(
//             accuracy: LocationAccuracy.NAVIGATION,
//             interval: 5,
//             distanceFilter: 0,
//             client: LocationClient.google,
//             androidNotificationSettings: AndroidNotificationSettings(
//                 notificationChannelName: 'Location tracking',
//                 notificationTitle: 'Start Location Tracking',
//                 notificationMsg: 'Track location in background',
//                 notificationBigMsg:
//                     'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
//                 notificationIcon: '',
//                 notificationIconColor: Colors.grey,
//                 notificationTapCallback:
//                     LocationCallbackHandler.notificationCallback)));
//   }
// }
