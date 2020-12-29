import 'package:background_locator_example/file_manager.dart';

import 'MLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ProviderPrefs {
  static addNewLocation(MLocation newlocation) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get previous location
    log("Saving location");
    List<MLocation> list = await FileManager.readLogFile2();
    if (list == null || list.length == 0 || list.length == 1) {
      list = List();
      list.add(newlocation);
      list.add(newlocation);
      // prefs.setStringList('speed', list);
      FileManager.writeToLogFile2(list);
    } else {
      //Convert to list
      list.add(newlocation);
      log("Saved List ${list.skip(1).toList().length}");
      FileManager.writeToLogFile2(list.skip(1).toList());

      // prefs.setStringList(
      //     'speed', .map((e) => e.toJson()).toList());
    }
  }

  static Future<List<MLocation>> getLocations() async {
    List<MLocation> list = await FileManager.readLogFile2();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> ss = prefs.getStringList('speed');
    if (list == null) return List();
    return list;
  }
}
