import 'dart:math';

import 'package:geolocator/geolocator.dart' as dev;
import 'dart:developer' as dev;

import 'package:intl/intl.dart';

class Utils {
  static String translateDate(String number) {
    DateFormat format = DateFormat('hh:mm:ss   dd:MM:yyyy');
    return format.format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(number.substring(5).replaceAll('.txt', ''))));
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static bool speedLimitCrossed(double speedLimit, double distance,
      DateTime startingTime, DateTime currentTime) {
    dev.log("Distance covered is $distance in meters");
    //Find the minimum time to cross
    //Distance in m
    double trueDistance = distance / 1000;

    //Speed in m / s
    double trueSpeed = (speedLimit * 1000) / 3600;

    //Minimum time in that speed, in seconds
    double mini = trueDistance / trueSpeed;
    //Compare time
    double timeTaken =
        currentTime.difference(startingTime).inSeconds.toDouble();

    return timeTaken < mini;
  }

  static double calculateKMH(double speed) {
    return speed * 3.6;
  }

  static double calculateSpeed(
      double distance, DateTime startingTime, DateTime currentTime) {
    double timeTaken =
        currentTime.difference(startingTime).inSeconds.toDouble();
    double kms = distance / 1000;
    double timeh = timeTaken / 3600;
    return kms / timeh;
  }

  static double calculateDistance(
      double lat1, double lat2, double lon1, double lon2) {
    return dev.Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
