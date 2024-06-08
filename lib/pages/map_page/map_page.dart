import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gadc/functions/shared_pref/past_location.dart';
import 'package:gadc/widgets/custom_map/custom_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();

  static const String routeName = "/mappage";
}

class MapPageState extends State<MapPage> with TickerProviderStateMixin {
  double currLat = 21, currLong = 78; // default location coordinates of India
  bool firstTimeStart =
      true; // to set zoom and animation for 1st time initialization of the map
  late final _animatedMapController = AnimatedMapController(vsync: this);
  ValueNotifier<LatLng> _mapCenterNotifier =
      ValueNotifier<LatLng>(const LatLng(21, 78));

  @override
  void initState() {
    super.initState();
    startLocationUpdates();
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  Future<void> startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      _mapCenterNotifier.value = LatLng(
        position.latitude,
        position.longitude,
      );

      PastLocation().writeMyLastLocation(
          position.latitude, position.longitude); // update last location
    });
  }

  // to get the center coordinates of the map, (will come to use in reverse geo-coding)
  LatLng _updateMapCenter() {
    return _animatedMapController.mapController.camera.center;
  }

  void animateMapView(double lat, double long, double zoom) {
    _animatedMapController.animateTo(
      dest: LatLng(lat, long),
      zoom: zoom,
      rotation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: PastLocation().readMyLastLocation(),
          builder: (context, snapshot) {
            bool appFirstTimeLaunch = false;
            if (snapshot.data != null) {
              _mapCenterNotifier = ValueNotifier<LatLng>(
                LatLng(
                  double.parse(snapshot.data![0]),
                  double.parse(snapshot.data![1]),
                ),
              );
              if (firstTimeStart) {
                animateMapView(double.parse(snapshot.data![0]),
                    double.parse(snapshot.data![1]), 17.5);
                firstTimeStart = false;
              }
            } else {
              appFirstTimeLaunch = true;
            }
            return ValueListenableBuilder<LatLng>(
              valueListenable: _mapCenterNotifier,
              builder: (context, mapCenter, child) {
                currLat = mapCenter.latitude;
                currLong = mapCenter.longitude;
                if (appFirstTimeLaunch) {
                  return map(
                    currLat,
                    currLong,
                    _animatedMapController.mapController,
                    _updateMapCenter,
                    context,
                    4.5,
                  );
                }
                return map(
                  currLat,
                  currLong,
                  _animatedMapController.mapController,
                  _updateMapCenter,
                  context,
                  17.5,
                );
              },
            );
          },
        ),
        Align(
          alignment: const AlignmentDirectional(1, 1),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _animatedMapController.animateTo(
                      dest: LatLng(currLat, currLong),
                      zoom: 17.5,
                      rotation: 0,
                    );
                  },
                  child: Card(
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? const Color.fromARGB(255, 29, 36, 40)
                        : Colors.white,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.my_location_rounded,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? const Color.fromARGB(255, 29, 36, 40)
                      : Colors.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.create_rounded,
                          size: 36,
                        ),
                        SizedBox(height: 16),
                        Icon(
                          Icons.threed_rotation_rounded,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
