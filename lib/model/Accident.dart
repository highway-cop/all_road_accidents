import 'package:google_maps_flutter/google_maps_flutter.dart';

class Accident {
  final String date;
  final String city;
  final String road;
  final String km;
  final String type;
  final String reason;

  final LatLng location;

  Accident({
    required this.date,
    required this.city,
    required this.road,
    required this.km,
    required this.type,
    required this.reason,
    required this.location,
  });

  factory Accident.fromJson(Map<String, dynamic> json) {
    return Accident(
      date: json['date'],
      city: json['city'],
      road: json['road'],
      km: json['km'],
      type: json['type'],
      reason: json['reason'],
      location: LatLng(
        json['location']['lat'],
        json['location']['lng'],
      ),
    );
  }
}
