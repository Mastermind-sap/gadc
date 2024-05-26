import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gadc/pages/test_page/test_page.dart';
import 'package:latlong2/latlong.dart';

import '../../config/assets.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            LatLng(-90, -180), // Southwest corner of the bounds
            LatLng(90, 180), // Northeast corner of the bounds
          ),
        ),
        keepAlive:
            true, // so that it doesnot reset to inital position on changing pages
        initialCenter: const LatLng(24.7577, 92.7923),
        initialZoom: 10.0,
        backgroundColor: Colors.black,
        onMapReady: () {},
        onLongPress: (tapPosition, point) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TestingPage(l: point),
            ),
          );
          print(point.latitude); //prints latitude
          print(point.longitude); //prints latitude
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          // errorImage: AssetImage(assetName), //set a image to load when map not load due to no network connection
        ),
        const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(24.7577, 92.7923),
              width: 80,
              height: 80,
              child: Image(image: AssetImage(Assets.logo)),
            ),
          ],
        )
      ],
    );
  }
}
