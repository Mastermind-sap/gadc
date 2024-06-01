import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gadc/functions/bottom_modal.dart';
import 'package:gadc/functions/nav_status.dart';
import 'package:latlong2/latlong.dart';

Widget map(double? myLat, double? myLong, MapController mapController,
    Function updateMapCenter, BuildContext context) {
  double zoom = 17.5;
  if (myLat == null || myLong == null) {
    myLat = 21.0000;
    myLong = 78.0000;
    zoom = 5;
  }
  return FlutterMap(
    mapController: mapController,
    options: MapOptions(
      cameraConstraint: CameraConstraint.contain(
        bounds: LatLngBounds(
          LatLng(-90, -180), // Southwest corner of the bounds
          LatLng(90, 180), // Northeast corner of the bounds
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
      backgroundColor: Colors.black45,
      onMapReady: () {
        // Get the initial map center when the map is ready
        updateMapCenter();
      },
      onPositionChanged: (MapPosition position, bool hasGesture) {
        // Update map center whenever the position changes
        updateMapCenter();
      },
      onLongPress: (tapPosition, point) {
        readNavStatus().then((navStatus) {
          if (navStatus == true || navStatus == null) {
            showOptionsBottomSheet(context);
          }
        });
      },
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        // errorImage: AssetImage(assetName), // set an image to load when map not load due to no network connection
      ),
      MarkerLayer(
        markers: [
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
}
