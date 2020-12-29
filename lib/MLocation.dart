import 'dart:convert';

class MLocation {
  double lat;
  double lon;
  String time;
  MLocation({
    this.lat,
    this.lon,
    this.time,
  });
  double get getLat => lat;

  set setLat(double lat) => this.lat = lat;

  double get getLon => lon;

  set setLon(double lon) => this.lon = lon;

  String get getTime => time;

  set setTime(String time) => this.time = time;

  MLocation copyWith({
    double lat,
    double lon,
    String time,
  }) {
    return MLocation(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lon': lon,
      'time': time,
    };
  }

  factory MLocation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MLocation(
      lat: map['lat'],
      lon: map['lon'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MLocation.fromJson(String source) =>
      MLocation.fromMap(json.decode(source));

  @override
  String toString() => 'MLocation(lat: $lat, lon: $lon, time: $time)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MLocation && o.lat == lat && o.lon == lon && o.time == time;
  }

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode ^ time.hashCode;
}
