import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gadc/functions/locate_me.dart';
import 'package:gadc/pages/test_page/test_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();

  static const String routeName = "/homescreen";
}

class _MapPage extends State<MapPage> {
  Widget map(double myLat, double myLong) {
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
            true, // so that it does not reset to initial position on changing pages
        minZoom: 3.0,
        maxZoom: 18.0,
        enableScrollWheel: true, // Enable scroll wheel zoom
        interactiveFlags: InteractiveFlag.pinchZoom |
            InteractiveFlag.drag |
            InteractiveFlag.doubleTapZoom |
            InteractiveFlag.flingAnimation, // Use specific flags
        initialCenter: LatLng(myLat, myLong),
        initialZoom: 17.5,
        backgroundColor: Colors.black45,
        onMapReady: () {},
        onLongPress: (tapPosition, point) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TestingPage(l: point),
            ),
          );
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

  // write user last location in shared pref
  void writeMyLastLocation(double lat, double long) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'myLastLocation', <String>[lat.toString(), long.toString()]);
  }

  Future<List<String>?> readMyLastLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? temp = prefs.getStringList('myLastLocation');
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // return map(widget.myLat, widget.myLong);
    return FutureBuilder(
        future: locateMe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future Builder to get the stored data
            return FutureBuilder(
                future: readMyLastLocation(),
                builder: (context, snapshot) {
                  double? lastLat = double.parse(snapshot.data?[0] ?? "-1");
                  double? lastLong = double.parse(snapshot.data?[1] ?? "-1");

                  // nul safety checks
                  if (lastLat == -1 && lastLong == -1) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Stack(
                    children: [
                      map(lastLat, lastLong),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  );
                });
          }
          double currLat = snapshot.data!.latitude;
          double currLong = snapshot.data!.longitude;

          writeMyLastLocation(currLat, currLong);

          // Implement to access the stored data
          return map(currLat, currLong);
        });
  }
}
