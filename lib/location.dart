import 'package:floor/floor.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

@Entity(tableName: 'track_points')
class Location {
  Location(
      {this.id,
      this.timestamp,
      this.lat,
      this.lng,
      this.accuracy,
      this.speed,
      this.speedAccuracy,
      this.heading,
      this.altitude,
      this.floor,
      this.isMoving,
      });

  factory Location.fromBGLocation(bg.Location position) => Location(
        timestamp: position.timestamp,
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        accuracy: position.coords.accuracy,
        speed: position.coords.speed,
        speedAccuracy: position.coords.speedAccuracy,
        heading: position.coords.heading,
        altitude: position.coords.altitude,
        floor: position.coords.floor,
        isMoving: position.isMoving,
      );

  @PrimaryKey(autoGenerate: true)
  int? id;
  String? timestamp;
  double? lat;
  double? lng;
  double? accuracy;
  double? speed;
  double? speedAccuracy;
  double? heading;
  double? altitude;
  int? floor;
  bool? isMoving;
}
