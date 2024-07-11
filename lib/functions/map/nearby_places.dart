// Function to calculate the distance between two lat/long points using the Haversine formula

import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

double calculateDistanceBetweenTwoPos(
    double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // Radius of the Earth in km
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final distance = R * c;
  return distance;
}

// Convert degree to radians
double _deg2rad(double deg) {
  return deg * (pi / 180);
}
