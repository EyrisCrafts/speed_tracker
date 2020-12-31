import 'dart:convert';

import 'package:flutter/foundation.dart';

class ListCarSpeed {
  List<CarSpeed> list;
  ListCarSpeed({
    this.list,
  });

  List get getList => list;

  set setList(List list) => this.list = list;

  ListCarSpeed copyWith({
    List<CarSpeed> list,
  }) {
    return ListCarSpeed(
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'list': list?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory ListCarSpeed.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ListCarSpeed(
      list: List<CarSpeed>.from(map['list']?.map((x) => CarSpeed.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListCarSpeed.fromJson(String source) =>
      ListCarSpeed.fromMap(json.decode(source));

  @override
  String toString() => 'ListCarSpeed(list: $list)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ListCarSpeed && listEquals(o.list, list);
  }

  @override
  int get hashCode => list.hashCode;
}

class CarSpeed {
  String time;
  double lat;
  double lon;
  double speed;
  CarSpeed({
    this.time,
    this.lat,
    this.lon,
    this.speed,
  });

  CarSpeed copyWith({
    String time,
    double lat,
    double lon,
    double speed,
  }) {
    return CarSpeed(
      time: time ?? this.time,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      speed: speed ?? this.speed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'lat': lat,
      'lon': lon,
      'speed': speed,
    };
  }

  factory CarSpeed.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CarSpeed(
      time: map['time'],
      lat: map['lat'],
      lon: map['lon'],
      speed: map['speed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CarSpeed.fromJson(String source) =>
      CarSpeed.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CarSpeed(time: $time, lat: $lat, lon: $lon, speed: $speed)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CarSpeed &&
        o.time == time &&
        o.lat == lat &&
        o.lon == lon &&
        o.speed == speed;
  }

  @override
  int get hashCode {
    return time.hashCode ^ lat.hashCode ^ lon.hashCode ^ speed.hashCode;
  }
}
