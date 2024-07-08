import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng point1, LatLng point2) {
  final distance = Distance();
  return distance.as(LengthUnit.Meter, point1, point2);
}
