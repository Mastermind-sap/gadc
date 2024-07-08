import 'dart:async';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:gadc/caching/get_cache_directory.dart';
import 'package:gadc/functions/bottom_modal/bottom_modal_on_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CustomMap extends StatefulWidget {
  final double myLat;
  final double myLong;
  final double centerLat;
  final double centerLong;
  final MapController mapController;
  final Function updateMapCenter;
  final BuildContext context;
  final double zoom;

  CustomMap({
    required this.myLat,
    required this.myLong,
    required this.centerLat,
    required this.centerLong,
    required this.mapController,
    required this.updateMapCenter,
    required this.context,
    required this.zoom,
  });

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  ValueNotifier<double> _currentRotation = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  void _startListening() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate rotation angle based on accelerometer data
      double angle = event.y * 50.0; // Adjust sensitivity as needed
      _currentRotation.value = angle;
    });
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    final distance = Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCacheDirectory(),
      builder: (context, snapshot) {
        return FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                const LatLng(-90, -180), // Southwest corner of the bounds
                const LatLng(90, 180), // Northeast corner of the bounds
              ),
            ),
            keepAlive:
                true, // so that it does not reset to initial position on changing pages
            minZoom: 3.0,
            maxZoom: 18.0,
            enableScrollWheel: true, // Enable scroll wheel zoom
            interactiveFlags: InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.flingAnimation, // Use specific flags
            initialCenter: LatLng(widget.myLat, widget.myLong),
            initialZoom: widget.zoom,
            backgroundColor: (Theme.of(context).brightness == Brightness.dark)
                ? Colors.black
                : Colors.white,
            onMapReady: () {
              // Get the initial map center when the map is ready
              widget.updateMapCenter();
            },
            onPositionChanged: (MapPosition position, bool hasGesture) {
              // Update map center whenever the position changes
              widget.updateMapCenter();
            },
            onLongPress: (tapPosition, point) {
              bottomModalOnMap(context);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              tileProvider: CachedTileProvider(
                // maxStale keeps the tile cached for the given Duration and
                // tries to revalidate the next time it gets requested
                maxStale: const Duration(days: 30),
                store: HiveCacheStore(
                  snapshot.data,
                  hiveBoxName: 'HiveCacheStore',
                ),
              ),
            ),
            MarkerLayer(
              markers: [
                // My Location
                Marker(
                  point: LatLng(widget.myLat, widget.myLong),
                  width: 20,
                  height: 20,
                  child: Image.asset("assets/pin.png"),
                ),
                // Other Location Marker
                if (_calculateDistance(LatLng(widget.myLat, widget.myLong),
                        LatLng(widget.centerLat, widget.centerLong)) >
                    50.0) // Distance threshold in meters
                  Marker(
                    point: LatLng(widget.centerLat, widget.centerLong),
                    width: 20,
                    height: 20,
                    child: AnimatedBuilder(
                      animation: _currentRotation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _currentRotation.value *
                              3.1415926535 /
                              180, // Convert degrees to radians
                          child: Image.asset("assets/current_pointer.png"),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
