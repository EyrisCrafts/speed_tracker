import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:background_locator_example/MLocation.dart';

class FileManager {
  static Future<void> writeToLogFile(String log) async {
    final file = await _getTempLogFile();
    await file.writeAsString(log, mode: FileMode.append);
  }

  static Future<String> readLogFile() async {
    final file = await _getTempLogFile();
    return file.readAsString();
  }

  static Future<File> _getTempLogFile() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/log.txt');
    if (!await file.exists()) {
      await file.writeAsString('');
    }
    return file;
  }

  static Future<void> clearLogFile() async {
    final file = await _getTempLogFile();
    await file.writeAsString('');
    final file2 = await _getTempLogFile2();
    await file2.writeAsString('');
  }

  static Future<void> writeToLogFile2(List<MLocation> log) async {
    final file = await _getTempLogFile2();

    await file.writeAsString(
        JJL(log[0].lat, log[1].lat, log[0].lon, log[1].lon, log[0].time,
                log[1].time)
            .toJson(),
        mode: FileMode.write);
  }

  static Future<List<MLocation>> readLogFile2() async {
    final file = await _getTempLogFile2();
    String str = await file.readAsString();
    if (str == "") return List();
    JJL jj = JJL.fromJson(str);
    List<MLocation> ss = List()
      ..add(MLocation(lat: jj.lat1, lon: jj.lon1, time: jj.time1))
      ..add(MLocation(lat: jj.lat2, lon: jj.lon2, time: jj.time2));
    return ss;
  }

  static Future<File> _getTempLogFile2() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/log2.txt');
    if (!await file.exists()) {
      await file.writeAsString('');
    }
    return file;
  }
}

class JJL {
  double lat1;
  double lat2;
  double lon1;
  double lon2;
  String time1;
  String time2;
  JJL(
    this.lat1,
    this.lat2,
    this.lon1,
    this.lon2,
    this.time1,
    this.time2,
  );

  double get getLat1 => lat1;

  set setLat1(double lat1) => this.lat1 = lat1;

  double get getLat2 => lat2;

  set setLat2(double lat2) => this.lat2 = lat2;

  double get getLon1 => lon1;

  set setLon1(double lon1) => this.lon1 = lon1;

  double get getLon2 => lon2;

  set setLon2(double lon2) => this.lon2 = lon2;

  String get getTime1 => time1;

  set setTime1(String time1) => this.time1 = time1;

  String get getTime2 => time2;

  set setTime2(String time2) => this.time2 = time2;

  JJL copyWith({
    double lat1,
    double lat2,
    double lon1,
    double lon2,
    String time1,
    String time2,
  }) {
    return JJL(
      lat1 ?? this.lat1,
      lat2 ?? this.lat2,
      lon1 ?? this.lon1,
      lon2 ?? this.lon2,
      time1 ?? this.time1,
      time2 ?? this.time2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat1': lat1,
      'lat2': lat2,
      'lon1': lon1,
      'lon2': lon2,
      'time1': time1,
      'time2': time2,
    };
  }

  factory JJL.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return JJL(
      map['lat1'],
      map['lat2'],
      map['lon1'],
      map['lon2'],
      map['time1'],
      map['time2'],
    );
  }

  String toJson() => json.encode(toMap());

  factory JJL.fromJson(String source) => JJL.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JJL(lat1: $lat1, lat2: $lat2, lon1: $lon1, lon2: $lon2, time1: $time1, time2: $time2)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is JJL &&
        o.lat1 == lat1 &&
        o.lat2 == lat2 &&
        o.lon1 == lon1 &&
        o.lon2 == lon2 &&
        o.time1 == time1 &&
        o.time2 == time2;
  }

  @override
  int get hashCode {
    return lat1.hashCode ^
        lat2.hashCode ^
        lon1.hashCode ^
        lon2.hashCode ^
        time1.hashCode ^
        time2.hashCode;
  }
}
