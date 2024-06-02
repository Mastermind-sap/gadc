import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:gadc/caching/get_cache_directory.dart';
import 'package:gadc/functions/bottom_modal/bottom_modal_on_map.dart';
import 'package:latlong2/latlong.dart';

Widget map(double myLat, double myLong, MapController mapController,
    Function updateMapCenter, BuildContext context, double zoom) {
  return FutureBuilder(
    future: getCacheDirectory(),
    builder: (context, snapshot) {
      return FlutterMap(
        mapController: mapController,
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
          initialCenter: LatLng(myLat, myLong),
          initialZoom: zoom,
          backgroundColor: (Theme.of(context).brightness == Brightness.dark)
              ? Colors.black
              : Colors.white,
          onMapReady: () {
            // Get the initial map center when the map is ready
            updateMapCenter();
          },
          onPositionChanged: (MapPosition position, bool hasGesture) {
            // Update map center whenever the position changes
            updateMapCenter();
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
              // EED NITS
              Marker(
                point: const LatLng(24.7577, 92.7923),
                width: 20,
                height: 20,
                child: Image.asset("assets/pin.png"),
              ),
              // My Location
              Marker(
                point: LatLng(myLat, myLong),
                width: 20,
                height: 20,
                child: Image.asset("assets/pin.png"),
              ),
            ],
          )
        ],
      );
    },
  );
}
