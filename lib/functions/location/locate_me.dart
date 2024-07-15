import 'package:geolocator/geolocator.dart';

Future<Position> locateMe() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return getDefaultPosition(); // Location services are disabled, return default position
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return getDefaultPosition(); // Location permissions are denied, return default position
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return getDefaultPosition(); // Location permissions are permanently denied, return default position
  }

  // Get current position if all conditions are met
  Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );

  return currentPosition;
}

Position getDefaultPosition() {
  return Position(
    longitude: 21,
    latitude: 78,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
    isMocked: true,
  );
}

// Function to handle asking for location permission
Future<LocationPermission> askLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  return permission;
}
