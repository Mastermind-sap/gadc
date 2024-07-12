import 'dart:async';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:gadc/caching/get_cache_directory.dart';
import 'package:gadc/functions/bottom_modal/bottom_modal_on_map.dart';
import 'package:gadc/functions/location/calculateDistance.dart';
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
  final List<Marker> markers;

  const CustomMap({
    super.key,
    required this.myLat,
    required this.myLong,
    required this.centerLat,
    required this.centerLong,
    required this.mapController,
    required this.updateMapCenter,
    required this.context,
    required this.zoom,
    required this.markers,
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
      double angle = event.y * 10.0; // Adjust sensitivity as needed
      _currentRotation.value = angle;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    String tileLayerUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

    return Stack(
      children: [
        FutureBuilder(
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
                backgroundColor: isDarkMode ? Colors.black : Colors.white,
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
                  urlTemplate: tileLayerUrl,
                  subdomains: ['a', 'b', 'c'],
                  retinaMode: true,
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
                MarkerLayer(markers: widget.markers),
                MarkerLayer(
                  markers: [
                    // My Location
                    Marker(
                      point: LatLng(widget.myLat, widget.myLong),
                      width: 20,
                      height: 20,
                      child: const Opacity(
                        opacity: 0.5,
                        child: Icon(
                          Icons.location_history,
                          // color: Colors.blueAccent,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        if (calculateDistance(LatLng(widget.myLat, widget.myLong),
                LatLng(widget.centerLat, widget.centerLong)) >
            10.0)
          const Center(
              child: Icon(
            Icons.location_on,
            size: 20,
          ))
      ],
    );
  }
}
